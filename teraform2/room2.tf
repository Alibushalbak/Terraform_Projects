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


resource "google_compute_network" "vpc-5"{  
name = "vpc-5"
project = "devops-343007"
auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "room-2-subnet-a"{  
name = "room-2-subnet-a"
ip_cidr_range = "172.16.0.0/16"
region ="europe-west1"
network =google_compute_network.vpc-5.id
}

resource "google_compute_subnetwork" "room-2-subnet-b"{  
name = "room-2-subnet-b"
ip_cidr_range = "172.17.0.0/16"
region ="europe-west2"
network =google_compute_network.vpc-5.id
}

resource "google_compute_instance" "room-2-webserver1"{  
name = "room-2-webserver1"
machine_type= "e2-medium"
zone ="europe-west1-c"


boot_disk{
    initialize_params{
        image="debian-cloud/debian-9"
    }
}
network_interface{
    subnetwork=google_compute_subnetwork.room-2-subnet-a.id
    access_config{
        // Ephemeral public IP
    }
}

}

resource "google_compute_instance" "room-2-webserver2"{  
name = "room-2-webserver2"
machine_type= "e2-medium"
zone ="europe-west2-b"


boot_disk{
    initialize_params{
        image="debian-cloud/debian-9"
    }
}
network_interface{
    subnetwork=google_compute_subnetwork.room-2-subnet-b.id
    access_config{
        // Ephemeral public IP
    }
}

}




