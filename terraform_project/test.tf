terraform {    # here we provide what the company i want work?aws or google or azure(here i want work with google) 
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {     #here we connect my code with project in gcp
project = "devops-343007"
}

###################################################################################

resource "google_compute_network" "test"{  # here we define vpc and proparties for this vpc ,the resource here mean vpc or vm or any thing 
# the test above mean name of function 
name = "vpc-one"
auto_create_subnetworks = true
project = "devops-343007"
}

