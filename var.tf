variable "app_name" {
  default = "my watson car dashboard"
}

variable "app_version" {
  default = "1"
}

variable "git_repo" {
  default = "https://github.com/watson-developer-cloud/car-dashboard"
}

variable "dir_to_clone" {
  default = "/tmp/car-app"
}

variable "app_zip" {
  default = "/tmp/myzip.zip"
}

variable "org" {
  default = ""
}

variable "space" {
  default = ""
}

variable "route" {
  default = "my-watson-card-dashboard-0"
}

//Conversation service 
variable "conv_service_instance_name" {
  default = "myConversationService"
}

variable "conv_service_offering" {
  default = "conversation"
}

variable "conv_service_plan" {
  default = "standard"
}

//Speech to text service

variable "s2t_service_instance_name" {
  default = "mySpeech2TextService"
}

variable "s2t_service_offering" {
  default = "speech_to_text"
}

variable "s2t_plan" {
  default = "standard"
}

// Text to speech
variable "t2s_service_instance_name" {
  default = "myText2SpeechService"
}

variable "t2s_service_offering" {
  default = "text_to_speech"
}

variable "t2s_plan" {
  default = "standard"
}
