# ADR 002 - CI/CD CLI Interface
## Status
Implemented

This document obsoletes ADR 001.

## Context
In implementing the ideas in [ADR 001](./ADR-001-cli.md) I have made several changes. This document serves to catalog these changes, note perceived shortcomings, document the current state of the CLI including usage, and set up a framework for further changes.

## General Command Structure
The CLI is a single executable that supports the building and deployment of artifacts to various infrastructure. The CLI is structured as subcommands grouped by the underlying infrastructure. This current and planned structure is documented in the following table:

| command | subcommand               | description                                           |
|---------|--------------------------|-------------------------------------------------------|
| docker  |                          | Utilities around Docker image creation and management |
|         | build-and-publish        | Build and publish a Docker image                      |
| aws     |                          | Tools for managing AWS resources                      |
|         | deploy-static-assets     | Deploy a folder of static assets to S3                |
|         | invalidate-static-assets | Invalidate CloudFront distribution paths              |
| do      |                          | Tools for managing Digital Ocean resources            |
|         | deploy-app               | Update and deploy an App                              |

This ADR will not document these commands in detail, instead relying on CLI help documentation and code comments.

## Receipts
One pattern I've discovered while building and using this tool is the necessity of _receipts_. A receipt is a record of the side-effects of the CI tool, for example a list of newly created S3 paths or the identifier of an App deployment in Digital Ocean.

Generating receipts is required for auditing and allows splitting up individual jobs in a CI/CD pipeline. An example of a multi-stage pipeline using receipts is the following:
1. Build Assets - Compile static website assets, copying to shared directory.
1. Deploy to S3 - Upload static assets to S3 from shared directory. Generate receipt of newly created S3 paths.
1. Invalidate Caches - List all paths in S3 bucket and diff against receipt. Coalitions must be invalidated in CloudFront.

Currently, I am placing all receipts in a directory called `receipts` in the working directory of the CI jobs. These can be uploaded to the CI/CD system, in my case Gitlab, as artifacts. This allows for auditing and sharing across jobs. Two downsides to this approach exist, first is pollution of the working directory. This is especially prevalent when using the CI tool from a development machine (i.e. my laptop). The second issue is of persistence. It would be preferable to use a temporary folder for storage, ideally using `mktemp`. But this complicates sharing receipts during CI/CD execution where directories must be static and defined ahead of time. Neither of these concerns are pressing so I will make no changes, yet.

## Secrets Management
This is currently unsatisfactory. The CI tool requires certain secrets and the CLI verifies required environment variables are set. I will likely move towards using a secrets manager, such as Bitwarden's BWS, to manage all various secrets. This will allow the CI tool to dynamically lookup required secrets and require the operator to only specify one value. It will additionally help with security auditing, being able to track usages and rotate keys more easily.

## Name
The final unsolved hurdle is naming this tool. Thus far, I have called it "CI tool", "the CLI", and the nix package is is simply, `ci-tool`.
