terraform {
  cloud {
    organization = "luisroset-org"

    workspaces {
      name = "OAuth"
    }
  }
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.57.0"
    }
  }
}

# TFE token used to connect to HCP to create the VCS connection

provider "tfe" {
  token = var.tfe_token
}

# Would be possible to use gitlab provider to add the project and the branch in an automated way

/*provider "gitlab" {
  token    = var.oauth_token
}
resource "gitlab_project" "dynamic_OAuth" {
 name = "dynamic-OAuth" # demo_repo will create. Change the repo name as per your repo.
 description = "My demo github repository" # this is the description field.
 visibility_level = "public"
}
resource "gitlab_branch" "main" {
  name    = "example"
  ref     = "main"
  project = gitlab_project.dynamic_OAuth.id
}*/

resource "tfe_organization" "oauth" {
  name  = "oauth-org"
  email = "luis.roset@hashicorp.com"
}
resource "tfe_oauth_client" "gitlab" {
  organization = tfe_organization.oauth.id
  api_url      = "https://gitlab.com/api/v4"
  http_url     = "https://gitlab.com"
  oauth_token     = var.oauth_token   
  service_provider = "gitlab_hosted"
}
resource "tfe_workspace" "dynamic_vcs" {
  name                 = "dynamic-vcs-ws"
  organization         = tfe_organization.oauth.name
  queue_all_runs       = false
  vcs_repo {
    branch             = "main"
    identifier         = "luisroset1/Oauth"
    oauth_token_id     = tfe_oauth_client.gitlab.oauth_token_id
  }
}
resource "tfe_variable" "oauth_token" {
  key          = "TF_VAR_oauth_token"
  value        = var.oauth_token
  category     = "terraform"
  workspace_id = tfe_workspace.dynamic_vcs.id
  description  = "a useful description"
  sensitive    = true
}

resource "tfe_variable" "tfe_token" {
  key          = "TFE_TOKEN"
  value        = var.tfe_token
  category     = "env"
  workspace_id = tfe_workspace.dynamic_vcs.id
  description  = "a useful description"
  sensitive    = true
}