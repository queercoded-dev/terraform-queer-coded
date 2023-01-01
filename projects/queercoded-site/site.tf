# Create a Cloudflare Pages project
resource "cloudflare_pages_project" "queercoded_site" {
  account_id        = var.cloudflare_account_id         # Account ID for the domain, can be found in the dashboard
  name              = var.cloudflare_pages_project_name # Name of the project
  production_branch = var.production_branch             # The branch that will be deployed to production

  source {
    type = "github" // The person holding the API token must have access to this repo, link your GitHub account to your Cloudflare account
    config {
      owner                         = var.github_owner      # The owner of the repo
      repo_name                     = var.github_repo_name  # The name of the repo
      production_branch             = var.production_branch # The branch that will be deployed to production
      pr_comments_enabled           = true
      deployments_enabled           = true
      production_deployment_enabled = true
    }
  }
}

resource "cloudflare_pages_domain" "my-domain" {
  account_id   = var.cloudflare_account_id         # Account ID for the domain, can be found in the dashboard
  project_name = var.cloudflare_pages_project_name # Name of the project. This must match the name of the project resource
  domain       = var.domain                        # The domain you want to use
}
