# queercoded.dev site
| File | Purpose |
|---|---|
| `main.tf` | Terraform configuration |
| `provider.tf` | Provider (Cloudflare) configuration |
| `variables.tf` | Variables that need to be given |
| `site.tf` | Code to deploy the site |
| `env/prod.tfvars` | Variables for the production site, still needs an API key |

## Usage
To deploy the site, go to this directory and run:  
`terraform plan -var-file env/prod.tfvars`  

It will prompt for a Cloudflare API token, if you're supposed to be doing this, you know where to find it, if you're not, shoo!  

Seems like the Cloudflare provider doesn't have the best scheduling, so it can fail at the `cloudflare_pages_domain` with an error that the project doesn't exist, because the API calls were sent too quickly. Just run the apply command again, it's idempotent.  

The deployment might need to be triggered manually the first time.  
