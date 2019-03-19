provider "aws"{
    region  = "us-east-1"
}


resource "aws_launch_configuration" "conf_g4" {
  image_id      = "ami-00bcb399b38eb0f53"
  instance_type = "t2.micro"
  security_groups=["sg-0ec31b01a356e011e"]
  associate_public_ip_address=true
  key_name="KeyPairGrupo4"
  lifecycle {
    create_before_destroy = true
  }
  user_data= <<-EOF
    #!/bin/bash
    java -jar /home/ec2-user/demo-0.0.1-SNAPSHOT.jar
  EOF
}

resource "aws_autoscaling_group" "auto_scaling_g4" {
  launch_configuration = "${aws_launch_configuration.conf_g4.name}"
  min_size             = 2
  max_size             = 2
  vpc_zone_identifier=["subnet-07dbb197fc8d72d93"]
    load_balancers = ["${aws_elb.elb_g4.name}"]
  lifecycle {
    create_before_destroy = true
  }}

resource "aws_elb" "elb_g4" {
  name               = "elbG4"
  subnets= ["subnet-07dbb197fc8d72d93"]
    security_groups=["sg-0ec31b01a356e011e"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  tags = {
    Name = "elb_g4"
  }}





