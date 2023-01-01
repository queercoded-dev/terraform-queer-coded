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
      preview_branch_includes       = ["dev"]
    }
  }
  deployment_configs {
    production {
      compatibility_date = "2023-01-01"
    }
    preview {
      compatibility_date = "2023-01-01"
    }
  }
}

# Create a binding between the project and the domain
resource "cloudflare_pages_domain" "queercoded_site" {
  account_id   = var.cloudflare_account_id         # Account ID for the domain, can be found in the dashboard
  project_name = var.cloudflare_pages_project_name # Name of the project. This must match the name of the project resource
  domain       = var.domain                        # The domain you want to use
}

# Create a CNAME record for the domain
resource "cloudflare_record" "cname" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "CNAME"
  value   = "${var.cloudflare_pages_project_name}.pages.dev"
  ttl     = 1
  proxied = true
}

resource "cloudflare_ruleset" "discord_redirect" {
  zone_id = var.cloudflare_zone_id
  name    = "Discord Redirect"
  description = "Redirects /discord to the Discord invite link"
  kind    = "zone"
  phase   = "http_request_dynamic_redirect"

  rules {
    action = "redirect"
    action_parameters {
      from_value {
        status_code           = 301
        preserve_query_string = false
        target_url {
          value = var.discord_invite_link
        }
      }
    }
    expression = "http.request.uri.path eq \"/discord\" and http.host eq \"${var.domain}\""
    enabled    = true
  }
}
