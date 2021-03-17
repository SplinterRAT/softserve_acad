
data "template_file" "buildspec" {
  template = "${file("buildspec.yml")}"
  vars = {
    env = var.env
  }
}
resource "aws_codebuild_project" "mantis-cb-tf" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "mantis-cb-tf"
  queued_timeout = 480
  service_role   = aws_iam_role.mantis_tf_role.arn
  tags = {
    Environment = var.env
    ita_group = "Lv-543"
  }

  artifacts {
   type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

   source {
    buildspec       = data.template_file.buildspec.rendered
    type            = "GITHUB"
    location        = "https://github.com/SplinterRAT/mantisbt"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }
}