resource "aws_elastic_beanstalk_application" "mantis-tf" {
  name        = "mantis-tf-test"
  tags = {
    ita_group = "Lv-543"
  }
}
resource "aws_elastic_beanstalk_environment" "mantis-env-tf" {
  name                = "mantis-tf-env"
  application         = "${aws_elastic_beanstalk_application.mantis-tf.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.9.13 running PHP 7.3"
  setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "IamInstanceProfile"
      value     = "aws-elasticbeanstalk-ec2-role"
    }
  tags = {
    ita_group = "Lv-543"
  }
}