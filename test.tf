### Inıtılızıng Project ###
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
    project = "devops-343007"
}

# Defining Image that will be used
data "google_compute_image" "debian_image" {
  family  = "debian-9"
  project = "debian-cloud"
}


########### Creating VPCs ###########

#### Managment VPC ####

# # VPC 
# resource "google_compute_network" "mngt-vpc" {
#     name = "mngt-vpc"
#     auto_create_subnetworks = false
# }

# # Subnet 
# resource "google_compute_subnetwork" "mngt-subnet" {
# name = "mngt-subnet"
# ip_cidr_range = "172.16.0.0/24"
# region = "europe-west3"
# network = google_compute_network.mngt-vpc.id
# }

# # VMs
# resource "google_compute_instance" "mngt-vm" {
#   name         = "mngt-vm"
#   machine_type = "e2-medium"
#   zone         = "europe-west3-a"
#   boot_disk {
#     initialize_params {
#       image = data.google_compute_image.debian_image.self_link
#     }
#   }
#   network_interface {
#     subnetwork = google_compute_subnetwork.mngt-subnet.id
#   }
# }

#### Development VPC ####

# VPC
resource "google_compute_network" "dev-vpc" {
    name = "dev-vpc-omar-dont-delete"
    auto_create_subnetworks = false
}

# Subnets
resource "google_compute_subnetwork" "dev-subnet-1" {
name = "dev-subnet-1-omar"
ip_cidr_range = "10.0.1.0/24"
region = "europe-west2"
network = google_compute_network.dev-vpc.id
}

resource "google_compute_subnetwork" "dev-subnet-2" {
name = "dev-subnet-2-omar"
ip_cidr_range = "10.0.2.0/24"
region = "us-west2"
network = google_compute_network.dev-vpc.id
}


# VMs

#WebServer 1 
resource "google_compute_instance" "dev-webserver-1" {
  name         = "dev-webserver-1-omar"
  machine_type = "e2-medium"
  zone         = "europe-west2-b"
  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

 network_interface {
    subnetwork = google_compute_subnetwork.dev-subnet-1.id
      access_config {
      // Ephemeral public IP
    }
  }
  metadata_startup_script = "sudo apt install apache2 -y"

}

#WebServer 2 
resource "google_compute_instance" "dev-webserver-2" {
  name         = "dev-webserver-2-omar"
  machine_type = "e2-medium"
  zone         = "us-west2-b"
  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

 network_interface {
    subnetwork = google_compute_subnetwork.dev-subnet-2.id
      access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = "sudo apt install apache2 -y"
}

#SqlServer 1 
resource "google_compute_instance" "dev-sqlserver-1" {
  name         = "dev-sqlserver-1-omar"
  machine_type = "e2-medium"
  zone         = "europe-west2-b"
  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

 network_interface {
    subnetwork = google_compute_subnetwork.dev-subnet-1.id
      access_config {
      // Ephemeral public IP
    }
  }
}

#SqlServer 2 
resource "google_compute_instance" "dev-sqlserver-2" {
  name         = "dev-sqlserver-2-omar"
  machine_type = "e2-medium"
  zone         = "us-west2-b"
  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }
 network_interface {
    subnetwork = google_compute_subnetwork.dev-subnet-2.id
      access_config {
      // Ephemeral public IP
    }
  }

}


# Instance Gruop 

resource "google_compute_instance_group" "instance-group-dev-group-1" {
  name      = "instance-group-dev-group-1"
  zone        = "europe-west2-b"
  instances = [google_compute_instance.dev-webserver-1.id]

  named_port {
    name = "http"
    port = "80"
  }
}

resource "google_compute_instance_group" "instance-group-dev-group-2" {
  name      = "instance-group-dev-group-2"
  zone        = "us-west2-b"
  instances = [google_compute_instance.dev-webserver-2.id]

  named_port {
    name = "http"
    port = "80"
  }
}

resource "google_compute_health_check" "my-health-check" {
  name = "tcp-health-check"
  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_backend_service" "backend-omar" {
  name      = "backend-omar"
  port_name = "http"
  protocol  = "HTTP"
  load_balancing_scheme  = "EXTERNAL"
  timeout_sec   = 10



  backend {
    group = google_compute_instance_group.instance-group-dev-group-1.id
    max_utilization = 1.0
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 0.8
  }

  backend {
    group = google_compute_instance_group.instance-group-dev-group-2.id
    max_utilization = 1.0
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 0.8
  }

  health_checks = [
    google_compute_health_check.my-health-check.id,
  ]
}


# reserved IP address
resource "google_compute_global_address" "default" {
  name = "lb-static-ip"
}

# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "lb-test-forwarding-rule"
  ip_protocol           = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

# http proxy
resource "google_compute_target_http_proxy" "default" {
  name     = "lb-test-http-proxy"
  url_map  = google_compute_url_map.default.id
}

# url map
resource "google_compute_url_map" "default" {
  name            = "lb-test-url-map"
  default_service = google_compute_backend_service.backend-omar.id
}


# create firewall rules port 80 only
resource "google_compute_firewall" "allow-http-80-engress" {
  name    = "allow-http-80-engress"
  network = google_compute_network.dev-vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80","22","443"]
  }

  source_ranges = ["0.0.0.0/0"]
}




#### Production VPC ####

# # VPC
# resource "google_compute_network" "prod-vpc" {
#     name = "prod-vpc"
#     auto_create_subnetworks = false
# }

# # Subnets
# resource "google_compute_subnetwork" "prod-subnet-1" {
# name = "prod-subnet-1"
# ip_cidr_range = "192.168.1.0/24"
# region = "europe-west2"
# network = google_compute_network.prod-vpc.id
# }

# resource "google_compute_subnetwork" "prod-subnet-2" {
# name = "prod-subnet-2"
# ip_cidr_range = "192.168.2.0/24"
# region = "us-west2"
# network = google_compute_network.prod-vpc.id
# }






