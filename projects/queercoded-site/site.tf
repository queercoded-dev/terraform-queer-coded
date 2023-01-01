resource "cloudflare_pages_project" "queercoded_site" {
  account_id        = var.cloudflare_account_id
  name              = "queercoded-site"
  production_branch = var.production_branch

  source {
    type = "github"
    config {
      owner                         = var.github_owner
      repo_name                     = var.github_repo_name
      production_branch             = var.production_branch
      pr_comments_enabled           = true
      deployments_enabled           = true
      production_deployment_enabled = true
    }
  }
}

resource "cloudflare_pages_domain" "my-domain" {
  account_id   = var.cloudflare_account_id
  project_name = "queercoded-site"
  domain       = var.domain
}
