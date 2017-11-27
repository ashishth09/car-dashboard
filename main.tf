resource "null_resource" "prepare_app_zip" {
  triggers = {
    app_version = "${var.app_version}"
  }

  provisioner "local-exec" {
    command = <<EOF
        mkdir -p ${var.dir_to_clone}
        cd ${var.dir_to_clone}
        git init
        git remote add origin ${var.git_repo}
        git fetch
        git checkout -t origin/master
        zip -r ${var.app_zip} *
        EOF
  }
}

data "ibm_space" "space" {
  org   = "${var.org}"
  space = "${var.space}"
}

data "ibm_app_domain_shared" "domain" {
  name = "mybluemix.net"
}

resource "ibm_app_route" "route" {
  domain_guid = "${data.ibm_app_domain_shared.domain.id}"
  space_guid  = "${data.ibm_space.space.id}"
  host        = "${var.route}"
}

resource "ibm_service_instance" "conversation-service" {
  name       = "${var.conv_service_instance_name}"
  space_guid = "${data.ibm_space.space.id}"
  service    = "${var.conv_service_offering}"
  plan       = "${var.conv_service_plan}"
  tags       = ["conversation_service"]
}

resource "ibm_service_key" "cskey" {
  name                  = "conv-service-key"
  service_instance_guid = "${ibm_service_instance.conversation-service.id}"
}

resource "ibm_service_instance" "s2t" {
  name       = "${var.s2t_service_instance_name}"
  space_guid = "${data.ibm_space.space.id}"
  service    = "${var.s2t_service_offering}"
  plan       = "${var.s2t_plan}"
  tags       = ["my-Speech2Text-service"]
}

resource "ibm_service_key" "s2tkey" {
  name                  = "s2tkey"
  service_instance_guid = "${ibm_service_instance.s2t.id}"
}

resource "ibm_service_instance" "t2s" {
  name       = "${var.t2s_service_instance_name}"
  space_guid = "${data.ibm_space.space.id}"
  service    = "${var.t2s_service_offering}"
  plan       = "${var.t2s_plan}"
  tags       = ["my-Text2Speech-service"]
}

resource "ibm_service_key" "t2tkey" {
  name                  = "t2skey"
  service_instance_guid = "${ibm_service_instance.t2s.id}"
}

resource "ibm_app" "app" {
  depends_on            = ["ibm_service_key.cskey", "ibm_service_key.t2tkey", "ibm_service_key.s2tkey", "null_resource.prepare_app_zip"]
  name                  = "${var.app_name}"
  space_guid            = "${data.ibm_space.space.id}"
  app_path              = "${var.app_zip}"
  wait_time_minutes     = 20
  disk_quota            = 512
  memory                = 256
  instances             = 1
  disk_quota            = 1024
  route_guid            = ["${ibm_app_route.route.id}"]
  service_instance_guid = ["${ibm_service_instance.conversation-service.id}", "${ibm_service_instance.s2t.id}", "${ibm_service_instance.t2s.id}"]
  app_version           = "${var.app_version}"
}
