# Google Kubernetes Engine utilities

gauth() {
  export GOOGLE_APPLICATION_CREDENTIALS=$(find ~/.gcloud/*.json -type f | fzf)
  export GOOGLE_PROJECT_ID=$(cat $GOOGLE_APPLICATION_CREDENTIALS | jq -r '.project_id')
  gcloud auth activate-service-account \
      --key-file=$GOOGLE_APPLICATION_CREDENTIALS \
      --project=$GOOGLE_PROJECT_ID > /dev/null 2>&1
  _kctx
  _gcfg
  gcloud auth print-access-token
}

proxy() {
  INSTANCE_CONNECTION_NAME=`
    gcloud sql instances list --format 'value(name)' \
      | fzf \
      | xargs gcloud sql instances describe --format 'value(connectionName)'
  `
  ~/cloud_sql_proxy -instances=$INSTANCE_CONNECTION_NAME=tcp:3306 \
                    -credential_file=$GOOGLE_APPLICATION_CREDENTIALS
}

# Private functions

_kctx() {
  kubectl config unset current-context > /dev/null 2>&1
  export REGION_NAME=asia-northeast1
  export CLUSTER_NAME=$(gcloud container clusters list --format 'value(name)' --limit 1 2>/dev/null)
  if [[ ! -z $CLUSTER_NAME ]]; then
    gcloud container clusters get-credentials \
      --region $REGION_NAME $CLUSTER_NAME > /dev/null 2>&1
  fi
}

_gcfg() {
  echo -e "project: $(gcloud config get-value project)"
  if [[ ! -z $CLUSTER_NAME ]]; then
    echo -e "context: $(kubectl config current-context)"
  else
    echo -e "context: "
  fi
}

