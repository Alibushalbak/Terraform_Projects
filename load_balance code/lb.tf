
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
######################################VPC##################################################

resource "google_compute_network" "production-vpc-room10"{  
name = "production-vpc-room10"
project = "devops-343007"
auto_create_subnetworks = false
}
######################################SUBNET##################################################
resource "google_compute_subnetwork" "subnet-room10"{  
name = "subnet-room10"
ip_cidr_range = "172.192.50.0/24"
region ="us-central1"
network =google_compute_network.production-vpc-room10.id
}

######################################VM_INSTANCE##################################################

resource "google_compute_instance" "webserver1"{  
name = "webserver1"
machine_type= "e2-micro"
zone ="us-central1-b"


boot_disk{
    initialize_params{
        image="ubuntu-os-cloud/ubuntu-2004-lts"
    }
}

metadata_startup_script = "sudo apt install apache2 -y"

network_interface{
    subnetwork=google_compute_subnetwork.subnet-room10.id
    access_config{
        // Ephemeral public IP
    }
}

}

resource "google_compute_instance" "webserver2"{  
name = "webserver2"
machine_type= "e2-micro"
zone ="us-central1-b"


boot_disk{
    initialize_params{
        image="ubuntu-os-cloud/ubuntu-2004-lts"
    }
}

metadata_startup_script = "sudo apt install apache2 -y"

network_interface{
    subnetwork=google_compute_subnetwork.subnet-room10.id
    access_config{
        // Ephemeral public IP
    }
}

}

resource "google_compute_instance" "webserver3"{  
name = "webserver3"
machine_type= "e2-micro"
zone ="us-central1-b"


boot_disk{
    initialize_params{
        image="ubuntu-os-cloud/ubuntu-2004-lts"
    }
}

metadata_startup_script = "sudo apt install apache2 -y"

network_interface{
    subnetwork=google_compute_subnetwork.subnet-room10.id
    access_config{
        // Ephemeral public IP
    }
}

}
####################################INSTANCE_GROUP####################################################

resource "google_compute_instance_group" "instancegrouproom10" {
  name        = "instancegrouproom10"
  

  instances = [
    google_compute_instance.webserver1.id,
    google_compute_instance.webserver2.id,
    google_compute_instance.webserver3.id,
  ]

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "http"
    port = "8080"
  }

  zone = "us-central1-b"
}

####################################INSTANCE_GROUP####################################################


module "gce-lb-http" {
  source            = "GoogleCloudPlatform/lb-http/google"
  version           = "~> 4.4"

  project           = "my-project-id"
  name              = "group-http-lb"
  target_tags       = [module.mig1.target_tags, module.mig2.target_tags]
  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = var.service_port
      port_name                       = var.service_port_name
      timeout_sec                     = 30
      enable_cdn                      = false
      custom_request_headers          = null
      custom_response_headers         = null
      security_policy                 = null

      connection_draining_timeout_sec = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/"
        port                = 80
        host                = null
        logging             = null
      }

      log_config = {
        enable = false
        
      }

      groups = [
        {
          # Each node pool instance group should be added to the backend.
          group                        = var.backend
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }
    }
  }
}





