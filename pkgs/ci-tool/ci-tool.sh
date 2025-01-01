set -eo pipefail

filter_docker_warning() {
  grep -E -v "^WARNING! Your password will be stored unencrypted in |^Configure a credential helper to remove this warning. See|^https://docs.docker.com/engine/reference/commandline/login/#credentials-store" || true
}

# necessary to keep the CLI nice and tidy
docker_cli=$(which docker)

# @cmd                              Utilities around Docker image creation and management
docker() { :; }

# @cmd                              Print debug info about what docker is used under the hood
docker::info() {
  ${docker_cli} --version
}

# @cmd 		                          Build and publish a Docker image
# @env 		DOCKER_REGISTRY						Private Docker registry
# @env 		DOCKER_REGISTRY_USERNAME	Private Docker registry username for authentication
# @env 		DOCKER_REGISTRY_PASSWORD	Private Docker registry password for authentication
# @env 		IMAGE_REPOSITORY					Repository for prefixing Docker image names
# @flag   --from-nix-build		      Load Docker image from Nix result file instead of performing a Docker build
# @flag   --skip-login              Skip logging into Docker registry, e.g. when credentials are already present
# @arg 		image-name!								The final image name. Will be prefixed by DOCKER_REGISTRY or IMAGE_REPOSITORY when set
# @arg    image-tag=latest					The final image tag
docker::build-and-publish() {
	# login if creds are supplied
	if [[ -n "$DOCKER_REGISTRY" && -n "$DOCKER_REGISTRY_USERNAME" && -n "$DOCKER_REGISTRY_PASSWORD" && ${argc_skip_login} -ne "1" ]]; then
		echo "Logging in to Docker container registry..." 

		# this filters the stderr of the `docker login`, without merging stdout and stderr together
		{ printenv DOCKER_REGISTRY_PASSWORD | ${docker_cli} login -u "${DOCKER_REGISTRY_USERNAME}" --password-stdin "${DOCKER_REGISTRY}" 2>&1 1>&3 | filter_docker_warning 1>&2; } 3>&1  
	fi

	# create full image tag
	if [[ -n "$DOCKER_REGISTRY" ]]; then
		full_image_tag="${DOCKER_REGISTRY%/}/"
	fi
	if [[ -n "$IMAGE_REPOSITORY" ]]; then
		full_image_tag+="${IMAGE_REPOSITORY%/}/"
	fi
	full_image_tag+="${argc_image_name}:${argc_image_tag}"
	
	# build image
	if [[ -n "$argc_from_nix_build" ]]; then
    echo "Loading image from Nix result file..."
		nix_image_name=$(${docker_cli} load < result | sed -e 's/Loaded image: //')

    echo "Tagging image ${full_image_tag}..."
		${docker_cli} tag "${nix_image_name}" "${full_image_tag}"
	else
		# TODO(2024-03-03): support --file
		# TODO(2024-03-03): support --cache-from
    echo "Building image ${full_image_tag}..."
		${docker_cli} build --tag "${full_image_tag}" .
	fi

	# push image
  echo "Pushing image ${full_image_tag}..."
	${docker_cli} push "${full_image_tag}"
}

# necessary to keep the CLI nice and tidy
aws_cli=$(which aws)

# @cmd                              Tools around managing and using AWS resources
aws() { :; }

# @cmd                              Deploy a folder of static assets to S3
# @env    AWS_ACCESS_KEY_ID!
# @env    AWS_SECRET_ACCESS_KEY!
# @env    AWS_PAGER=""
# @arg    local-dir!                The local directory
# @arg    s3-bucket!                The s3 bucket
aws::deploy-static-assets() {
  echo 'Making receipts directory...'
  mkdir -p receipts

  # read all files in s3 bucket
  echo 'Generating S3 receipt...'
  ${aws_cli} s3 ls --recursive "s3://${argc_s3_bucket}" | awk -e '{ print $4 }' | sort > receipts/original-remote-paths

  # copy folders up
  echo 'Copying to S3...'
  ${aws_cli} s3 cp "${argc_local_dir%/}/" "s3://${argc_s3_bucket}" --sse --recursive

  # generate file manifest to help cache invalidation later
  echo 'Generating local receipt...'
  find "${argc_local_dir%/}/" -type f | sed "s/${argc_local_dir%/}\///" | sort > receipts/local-paths

  # get list of files that are stale (only in s3)
  echo 'Generating stale paths receipt...'
  comm -23 receipts/original-remote-paths receipts/local-paths > receipts/stale-paths

  # delete stale paths from s3
  # TODO: aws s3api DeleteObjects for performance
  echo 'Deleting stale paths from S3...'
  cat receipts/stale-paths | xargs -I '%' ${aws_cli} s3 rm "s3://${argc_s3_bucket}/%"
}

# @cmd                              Invalidate CloudFront distribution paths
# @env    AWS_ACCESS_KEY_ID!
# @env    AWS_SECRET_ACCESS_KEY!
# @env    AWS_PAGER=""
# @option --strict                  Only invalidate strict, e.g. this will not invalidate assets that contain hashes as they likely do not have changes
# @option --recalculate             Recalculate the deployed files used for cache invalidation
# @arg    distribution-id!          The CloudFront distribution
aws::invalidate-static-assets() {
  
  mkdir -p receipts

  # recalculate the local paths from the supplied file
  if [[ -n "${argc_recalculate}" ]] then
    find "${argc_recalculate%/}/" -type f | sed "s/${argc_recalculate%/}\///" | sort > receipts/local-paths
  fi

  # get list of paths in s3 that have been updated
  comm -12 receipts/original-remote-paths receipts/local-paths > receipts/updated-paths

  # filter to non-hash type files, e.g. parcel.js file "bird.09ee210b.webp"
  cat receipts/updated-paths | rg -v '.*\.[a-z0-9]{8}\..*$' > receipts/updated-paths-strict

  # create CloudFront invalidation
  awk '{printf("\"/%s\" ",$0)}' receipts/updated-paths-strict |
    xargs ${aws_cli} cloudfront create-invalidation --distribution-id "${argc_distribution_id}" --paths
}
