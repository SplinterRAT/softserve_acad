resource "aws_codepipeline" "mantis-tf-pipeline" {
  name     = "mantis-tf-pipeline"
  role_arn = aws_iam_role.mantis_cp_role.arn
  tags     = {
    Environment = var.env
  }

  artifact_store {
    location = aws_s3_bucket.mantis-tf-bucket.bucket
    type     = "S3"
  }
  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        OAuthToken             = var.gittocken
        "Branch"               = var.repository_branch
        "Owner"                = var.repository_owner
        "PollForSourceChanges" = "false"
        "Repo"                 = var.repository_name
      }
      input_artifacts = []
      name            = "Source"
      output_artifacts = [
        "SourceArtifact"
      ]
      owner     = "ThirdParty"
      provider  = "GitHub"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
       input_artifacts = [
        "SourceArtifact",
      ]
      output_artifacts = ["BuildArtifact"]
      configuration = {
        ProjectName = aws_codebuild_project.mantis-cb-tf.name
      }
    }
  }
  stage {
    name = "Deploy"

    action {
      category = "Deploy"
      configuration = {
         BucketName = aws_s3_bucket.mantis-tf-bucket.bucket
         Extract = false
         ObjectKey = "mantis.zip"
      }
      input_artifacts = [
        "BuildArtifact"
      ]
      name             = "Deploy"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
    }
    action {
      name = "Deploy_to_Elastic"
      category = "Deploy"
      owner = "AWS"
      provider = "ElasticBeanstalk"
      input_artifacts = [
        "BuildArtifact"]
      version = "1"

      configuration = {
        ApplicationName = "${aws_elastic_beanstalk_application.mantis-tf.name}"
        EnvironmentName = "${aws_elastic_beanstalk_environment.mantis-env-tf.name}"
      }
    }
  }
}