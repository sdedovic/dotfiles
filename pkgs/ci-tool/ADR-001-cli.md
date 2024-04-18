# ADR 001 - CI/CD CLI Interface
## Status
Proposed

## Context
I want to standardize the tooling that is used to perform general CI/CD tasks. 

Examples include building and publishing Docker containers, deploying DigitalOcean apps, and deploying static sites to AWS S3 + CloudFront.

Other future work includes building ready-to-flash SD card images for RaspberryPis, and publishing base Docker containers for automated builds, and performing automatic Terraform executions.

The goal is to define a robust yet extensible CLI that can be easily used in all of my repositories.

Another important goal is to support multi-output builds, i.e. a "monorepo" pattern.

### Docker Image Tagging
Docker defines the "naming" of a container as a tagging, e.g. `docker build -t some-name:latest .`. For the purpose of this document, the Docker nomenclature will be ignored. 

Docker images are identified using two coordinate:
```
<name>:<tag>
```
e.g. `python:3.11` or `python:3.11-apline`

The `name` is structured using up to three pieces:
```
<registry>/<user-or-repo>/<name>
```
e.g. `quay.io/fedora/python-311` or `docker.nix-community.org/nixpkgs/caddy`

It is important to note the image will be pulled / pushed from the registry and repository specified using the fully qualified name. Therefore, any and all tooling must parameterize all Docker operations to up to 4 compnents.

In this document the following convention will be used:
```
<registry>/<repository>/<name>:<tag>
|-------- image name ---------| tag |
|--- fully qualified name ----|
```
**Note:** `name` can be ambiguous.

### Examples
#### Example 1 - Build, Publish, and Deploy a DigitalOcean App from a Nix built Docker container
Steps:
1. build - `nix build .#<target>`
1. load built tarball - `docker load < result`
    - **note:** this will print the image tag to stdout and the result must be parsed and propagated to the next step
1. tag container - `docker tag <original> <new-tag>`
1. publish container to registry - `docker push <new-tag>`
    - **note:** publishing to a private registry requires logging in first, via `docker login`
1. trigger deployment to digitalocean - `doctl ...` using DO app id and new image tag

Required Inputs:
- nix
    - build target
- docker 
    - image name
    - image tag
    - registry and repo name
    - registry credentials
- digitalocean 
    - credentials
    - app id

#### Example 2 - Build, Publish, and Deploy a DigitalOcean App using a 3rd party builder and Docker
Steps:
1. build - `npm install && npm run build` or equivalent
1. build and tag container - `docker build -t <new-tag> .`
1. publish container to registry - `docker push <new-tag>`
    - **note:** publishing to a private registry requires logging in first, via `docker login`
1. trigger deployment to digitalocean - `doctl ...` using DO app id and new image tag

Required Inputs:
- 3rd party builder
    - build script
- docker 
    - path to dockerfile
    - image name
    - image tag
    - registry and repo name
    - registry credentials
- digitalocean 
    - credentials
    - app id

#### Example 3 - Build, Publish, and Deploy a static site to S3 bucking using Nix build target
Steps:
1. build - `nix build .#<target>`
1. copy to new s3 path - `aws s3 cp result s3://<bucket>/<prefix>/ --recursive <additional flags>`
1. reconfigure cloudfront somehow for blue/green deployment `???`

Required Inputs:
- nix
    - build target
- aws 
    - credentials
    - s3
        - bucket name / path
        - prefix
        - version info
    - cloudfront
        - version info
        - s3 bucket, prefix
    - route 53
        - ???
## Decision
### General
#### Artifact Tagging
All artifacts will be tagged by the first 6 characters of the Git SHA. 
Tagging is context-specific, e.g. a file name may be suffixed by a tag and contain other characters.

The term "artifacts" includes, but is not limited to:
- docker containers
- zip files
- S3 bucket contents
- Terraform files

### Proposed Usage
#### build-nix
```
ci-tool build-nix [--target]
```

#### publish-docker
```
# @env DOCKER_REGISTRY
# @env DOCKER_REGISTRY_USER
# @env DOCKER_REGISTRY_PASSWORD
# @env IMAGE_REPOSITORY
ci-tool publish-docker [--from-nix-build] [--dockerfile] name:tag

Note: if DOCKER_REGISTRY is set, the image name is prefixed
Note: if both IMAGE_REPOSITORY is set, the image name is prefixed
```

#### deploy-digitalocean-app
```
# @env DOCKER_REGISTRY
# @env IMAGE_REPOSITORY
ci-tool deploy-digitalocean-app [--image-tag] [--image-name] app_id

Note: if DOCKER_REGISTRY is set, the image name is prefixed
Note: if both IMAGE_REPOSITORY is set, the image name is prefixed
Note: this tool will only update the supplied options, leaving others unchanged
```

#### deploy-s3-assets
```
# @env AWS_CREDS...
ci-tool deploy-s3-assets from-file bucket-url
```

