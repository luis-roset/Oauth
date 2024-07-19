# Oauth

## Prerequisites
`oauth_token` terraform variable -> Personal Access Token from the VCS provider (Github in this case)

`TFE_TOKEN` env variable -> Token to athenticate againts HCP Terraform to create the org/workspace and the VCS connection.

`<github-username>/Oauth` repository created -> This is the repository where the created workspace will be attached to using the VCS connection.

![architecture](https://github.com/user-attachments/assets/98d945e1-f4a7-477c-960b-3e9e0b7ad227)
