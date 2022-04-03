######################################GCP_PROJECT##################################################
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


######################################VPC_Managment##################################################

resource "google_compute_network" "mngt-vpc"{  
name = "mngt-vpc"
project = "devops-343007"
auto_create_subnetworks = false
}
######################################SUBNET##################################################
resource "google_compute_subnetwork" "mngt-subnet"{  
name = "mngt-subnet"
ip_cidr_range = "172.16.0.0/24"
region ="europe-west3"
network = google_compute_network.mngt-vpc.id
}

######################################VM_INSTANCE##################################################

resource "google_compute_instance" "mngt-vm"{  
name = "mngt-vm"
machine_type= "e2-micro"
zone ="europe-west3-a"


boot_disk{
    initialize_params{
        image="ubuntu-os-cloud/ubuntu-2004-lts"
    }
}

metadata_startup_script = "sudo apt install apache2 -y"

network_interface{
    subnetwork = google_compute_subnetwork.mngt-subnet.id
    
}

}

########################################################################################################################################

######################################VPC_DEV##################################################


resource "google_compute_network" "dev-vpc"{  
name = "dev-vpc"
project = "devops-343007"
auto_create_subnetworks = false
}

######################################SUBNET-DEV-1##################################################
resource "google_compute_subnetwork" "dev-subnet-1"{  
name = "dev-subnet-1"
ip_cidr_range = "10.0.1.0/24"
region ="europe-west2"
network = google_compute_network.dev-vpc.id
}

######################################WEBSERVER-DEV-1##################################################

resource "google_compute_instance" "dev-webserver-1" {
  name         = "dev-webserver-1"
  machine_type = "e2-micro"
  zone         = "europe-west2-b"
  
boot_disk{
    initialize_params{
        image="ubuntu-os-cloud/ubuntu-2004-lts"
    }
}

metadata_startup_script = "sudo apt install apache2 -y"

 network_interface {
    subnetwork = google_compute_subnetwork.dev-subnet-1.id
      access_config {
      // Ephemeral public IP
    }
  }
  

}
######################################SQL-DEV-1##################################################

resource "google_compute_instance" "dev-sqlserver-1" {
  name         = "dev-sqlserver-1"
  machine_type = "e2-micro"
  zone         = "europe-west2-b"

  boot_disk{
    initialize_params{
        image="ubuntu-os-cloud/ubuntu-2004-lts"
    }
}
  
 network_interface {
    subnetwork = google_compute_subnetwork.dev-subnet-1.id
      access_config {
      // Ephemeral public IP
    }
  }
}

######################################SUBNET-DEV-2##################################################
resource "google_compute_subnetwork" "dev-subnet-2" {
name = "dev-subnet-2"
ip_cidr_range = "10.0.2.0/24"
region = "europe-west2"
network = google_compute_network.dev-vpc.id
}




######################################WEBSERVER-DEV-2##################################################
resource "google_compute_instance" "dev-webserver-2" {
  name         = "dev-webserver-2"
  machine_type = "e2-micro"
  zone         = "europe-west2-b"
  boot_disk{
    initialize_params{
        image="ubuntu-os-cloud/ubuntu-2004-lts"
    }
}
metadata_startup_script = "sudo apt install apache2 -y"

 network_interface {
    subnetwork = google_compute_subnetwork.dev-subnet-2.id
      access_config {
      // Ephemeral public IP
    }
  }

 
}


######################################SQL-DEV-2##################################################
resource "google_compute_instance" "dev-sqlserver-2" {
  name         = "dev-sqlserver-2"
  machine_type = "e2-micro"
  zone         = "europe-west2-b"

  boot_disk{
    initialize_params{
        image="ubuntu-os-cloud/ubuntu-2004-lts"
    }
}

 network_interface {
    subnetwork = google_compute_subnetwork.dev-subnet-2.id
      access_config {
      // Ephemeral public IP
    }
  }

}

########################################################################################################################################


######################################VPC_PROD##################################################


resource "google_compute_network" "prod-vpc"{  
name = "prod-vpc"
project = "devops-343007"
auto_create_subnetworks = false
}

######################################SUBNET-prod-1##################################################
resource "google_compute_subnetwork" "prod-subnet-1"{  
name = "prod-subnet-1"
ip_cidr_range = "192.168.1.0/24"
region ="us-west2"
network = google_compute_network.prod-vpc.id
}

######################################WEBSERVER-prod-1##################################################

resource "google_compute_instance" "prod-webserver-1" {
  name         = "prod-webserver-1"
  machine_type = "e2-micro"
  zone         = "us-west2-c"
  
boot_disk{
    initialize_params{
        image="ubuntu-os-cloud/ubuntu-2004-lts"
    }
}

metadata_startup_script = "sudo apt install apache2 -y"

 network_interface {
    subnetwork = google_compute_subnetwork.prod-subnet-1.id
      access_config {
      // Ephemeral public IP
    }
  }
  

}
######################################SQL-prod-1##################################################

resource "google_compute_instance" "prod-sqlserver-1" {
  name         = "prod-sqlserver-1"
  machine_type = "e2-micro"
  zone         = "us-west2-c"

  boot_disk{
    initialize_params{
        image="ubuntu-os-cloud/ubuntu-2004-lts"
    }
}
  
 network_interface {
    subnetwork = google_compute_subnetwork.prod-subnet-1.id
      access_config {
      // Ephemeral public IP
    }
  }
}

######################################SUBNET-prod-2##################################################
resource "google_compute_subnetwork" "prod-subnet-2" {
name = "prod-subnet-2"
ip_cidr_range = "192.168.2.0/24"
region = "us-west2"
network = google_compute_network.prod-vpc.id 
}




######################################WEBSERVER-prod-2##################################################
resource "google_compute_instance" "prod-webserver-2" {
  name         = "prod-webserver-2"
  machine_type = "e2-micro"
  zone         = "us-west2-c"
  boot_disk{
    initialize_params{
        image="ubuntu-os-cloud/ubuntu-2004-lts"
    }
}
metadata_startup_script = "sudo apt install apache2 -y"

 network_interface {
    subnetwork = google_compute_subnetwork.prod-subnet-2.id
      access_config {
      // Ephemeral public IP
    }
  }

 
}


######################################SQL-prod-2##################################################
resource "google_compute_instance" "prod-sqlserver-2" {
  name         = "prod-sqlserver-2"
  machine_type = "e2-micro"
  zone         = "us-west2-c"

  boot_disk{
    initialize_params{
        image="ubuntu-os-cloud/ubuntu-2004-lts"
    }
}

 network_interface {
    subnetwork = google_compute_subnetwork.prod-subnet-2.id
      access_config {
      // Ephemeral public IP
    }
  }

}

########################################################################################################################################


####################################INSTANCE_GROUP-DEV####################################################

resource "google_compute_instance_group" "instance-group-dev" {
  name        = "instance-group-dev"
  

  instances = [
    google_compute_instance.dev-webserver-1.id,
    google_compute_instance.dev-webserver-2.id,
  ]

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "http"
    port = "8080"
  }

  zone = "europe-west2-b"
}

####################################INSTANCE_GROUP-PROD####################################################


resource "google_compute_instance_group" "instance-group-prod" {
  name        = "instance-group-prod"
  

  instances = [
    google_compute_instance.prod-webserver-1.id,
    google_compute_instance.prod-webserver-2.id,
  ]

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "http"
    port = "8080"
  }

  zone = "us-west2-c"
}



####################################Load_Balancing_INSTANCE_GROUP-DEV####################################################


resource "google_compute_health_check" "health-check-dev" {
  name = "health-check-dev"
  timeout_sec        = 5
  check_interval_sec = 10

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_backend_service" "backend-dev" {
  name      = "backend-dev"
  port_name = "http"
  protocol  = "HTTP"
  load_balancing_scheme  = "EXTERNAL"
  timeout_sec   = 30



  backend {
    group = google_compute_instance_group.instance-group-dev.id
    max_utilization = 1.0
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 0.7
  }


  health_checks = [
    google_compute_health_check.health-check-dev.id,
  ]
}



resource "google_compute_global_address" "default" {
  name = "loadbalance-static-ip"
}


resource "google_compute_global_forwarding_rule" "default" {
  name                  = "lb-test-forwarding-rule"
  ip_protocol           = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}


resource "google_compute_target_http_proxy" "default" {
  name     = "lb-test-http-proxy"
  url_map  = google_compute_url_map.default.id
}


resource "google_compute_url_map" "default" {
  name            = "lb-test-url-map"
  default_service = google_compute_backend_service.backend-dev.id
}



####################################Load_Balancing_INSTANCE_GROUP-PROD####################################################

resource "google_compute_health_check" "health-check-prod" {
  name = "health-check-prod"
  timeout_sec        = 5
  check_interval_sec = 10

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_backend_service" "backend-prod" {
  name      = "backend-prod"
  port_name = "http"
  protocol  = "HTTP"
  load_balancing_scheme  = "EXTERNAL"
  timeout_sec   = 30



  backend {
    group = google_compute_instance_group.instance-group-prod.id
    max_utilization = 1.0
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 0.7
  }


  health_checks = [
    google_compute_health_check.health-check-prod.id,
  ]
}



resource "google_compute_global_address" "default2" {
  name = "lb-static-ip2"
}


resource "google_compute_global_forwarding_rule" "default2" {
  name                  = "lb-test-forwarding-rule2"
  ip_protocol           = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default2.id
  ip_address            = google_compute_global_address.default2.id
}


resource "google_compute_target_http_proxy" "default2" {
  name     = "lb-test-http-proxy2"
  url_map  = google_compute_url_map.default2.id
}


resource "google_compute_url_map" "default2" {
  name            = "lb-test-url-map2"
  default_service = google_compute_backend_service.backend-prod.id
}



####################################Firewall-DEV####################################################

resource "google_compute_firewall" "allow-ingress-dev" {
  name    = "allow-ingress-dev"
  direction     = "INGRESS"
  network = google_compute_network.dev-vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80","22","443"]
  }

  source_ranges = ["172.16.0.0/24"]
}

resource "google_compute_firewall" "allow-ingress-dev2" {
  name    = "allow-ingress-dev2"
  direction     = "INGRESS"
  network = google_compute_network.dev-vpc.name
  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }
 target_tags = [google_compute_instance.dev-sqlserver-1.id,
    google_compute_instance.dev-sqlserver-2.id,]

  source_ranges = ["10.0.1.0/24","10.0.2.0/24"]
 

}

####################################Firewall-PROD####################################################

resource "google_compute_firewall" "allow-ingress-prod" {
  name    = "allow-ingress-prod"
  direction     = "INGRESS"
  network = google_compute_network.prod-vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  
  target_tags = [google_compute_instance.prod-webserver-1.id,
    google_compute_instance.prod-webserver-2.id,]

  source_ranges = ["0.0.0.0/0"]

    
}

resource "google_compute_firewall" "allow-ingress-prod2" {
  name    = "allow-ingress-prod2"
  direction     = "INGRESS"
  network = google_compute_network.prod-vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["172.16.0.0/24"]

    
}

resource "google_compute_firewall" "allow-ingress-prod3" {
  name    = "allow-ingress-prod3"
  direction     = "INGRESS"
  network = google_compute_network.prod-vpc.name
  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }
 target_tags = [google_compute_instance.prod-sqlserver-1.id,
    google_compute_instance.prod-sqlserver-2.id,]

  source_ranges = ["192.168.1.0/24","192.168.2.0/24"]
 


    
}


 
####################################Firewall-MNGT####################################################

resource "google_compute_firewall" "allow-ingress-mngt" {
  name    = "allow-ingress-mngt"
  direction     = "INGRESS"
  network = google_compute_network.mngt-vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}





####################################PEERING####################################################


resource "google_compute_network_peering" "peering-mngt-dev" {
  name         = "peering1"
  network      = google_compute_network.mngt-vpc.id
  peer_network = google_compute_network.dev-vpc.id
}

resource "google_compute_network_peering" "peering-mngt-prod" {
  name         = "peering2"
  network      = google_compute_network.mngt-vpc.id
  peer_network = google_compute_network.prod-vpc.id
}







