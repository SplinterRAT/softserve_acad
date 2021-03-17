resource "aws_codepipeline_webhook" "codepipeline_webhook" {
  authentication  = "GITHUB_HMAC"
  name            = "codepipeline-webhook"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.mantis-tf-pipeline.name

  authentication_configuration {
    secret_token = var.gittocken
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
  tags = {}
}

resource "github_repository_webhook" "github_hook" {
  repository = var.repository_name
  events     = ["push"]

  configuration {
    url          = aws_codepipeline_webhook.codepipeline_webhook.url
    insecure_ssl = "0"
    content_type = "json"
    secret       = var.gittocken
  }
}
