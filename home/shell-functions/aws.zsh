# shellcheck shell=bash
function _aws_set_profile {
  if [ -n "${AWS_PROFILE}" ]; then
    echo "!! Error: AWS_PROFILE is already set. Exiting."
    return
  else
    AWS_PROFILE=$(jc --ini <~/.aws/config | jq --raw-output 'keys[] | select(contains("sso") | not) | sub("^profile "; "")' | fzf)
    export AWS_PROFILE
    AWS_REGION=$(jc --ini <~/.aws/config | jq --raw-output --arg aws_profile "$AWS_PROFILE" 'with_entries(select(.key | contains("sso") and contains($aws_profile))) | .[].sso_region')
    export AWS_REGION
  fi
}

function _aws_eks_refresh_kubeconfig {
  if [ -z "${AWS_PROFILE}" ]; then
    echo "!! Error: AWS_PROFILE is not set. Exiting."
    return
  fi
  if [ -z "${AWS_REGION}" ] || [ -z "${AWS_DEFAULT_REGION}" ]; then
    echo "!! Error: Neither AWS_DEFAULT_REGION or AWS_REGION are set. Exiting."
    return
  fi
  EKS_CLUSTER_NAME=$(aws eks list-clusters | jq --raw-output '.clusters[]' | fzf)
  echo "** Refreshing kubeconfig for cluster $EKS_CLUSTER_NAME"
  aws eks update-kubeconfig --name "$EKS_CLUSTER_NAME"
}

function _aws_eks_list_clusters {
  if [ -z "${AWS_PROFILE}" ]; then
    echo "!! Error: AWS_PROFILE is not set. Exiting."
    return
  fi
  if [ -z "${AWS_REGION}" ]; then
    AWS_REGION="eu-central-1"
  fi
  aws ec2 describe-regions | jq --raw-output '.Regions[] | .RegionName' | while read -r region; do
    echo -n "$region: "
    aws eks list-clusters --region "$region" | jq .clusters
  done
}
