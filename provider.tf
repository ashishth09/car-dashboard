variable "bluemix_api_key" {
  description = "Your IBM Cloud Infrastructure (Bluemix) API key."
}

provider "ibm" {
  bluemix_api_key = "${var.bluemix_api_key}"
}