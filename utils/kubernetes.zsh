# Kubernetes utilities

source <(kubectl completion zsh)
alias kc='kubectl'

# ex. kcg, kcg all, kcg pod watch, kcg deployment yaml
kcg() {
  if [[ "$1" == "all" ]]; then
    kubectl get ingress,services,nodes,deployments,replicasets,pods
  else
    local resource="${1:-$(kubectl api-resources --no-headers | fzf --prompt="Select Resource: " | awk '{print $1}')}"
    [[ $# -gt 0 ]] && shift
    local extra_opts=("$@")
    [[ -n "$resource" ]] &&
      kubectl get "$resource" \
      $([[ "${extra_opts[*]}" == *'yaml'* ]] && echo '-o yaml') \
      $([[ "${extra_opts[*]}" == *'watch'* ]] && echo '--watch')
  fi
}

kca() {
  local manifest=$(_selected_manifest)
  [[ -n "$manifest" ]] && kubectl apply --filename "$manifest"
}

kcd() {
  local manifest=$(_selected_manifest)
  [[ -n "$manifest" ]] && kubectl delete --filename "$manifest"
}

kce() {
  local pod=$(_selected_pod)
  [[ -n "$pod" ]] && kubectl exec -it "$pod" -- /bin/sh
}

kcl() {
  local pod=$(_selected_pod)
  [[ -n "$pod" ]] && kubectl logs -f "$pod"
}

kcdb() {
  local pod=$(_selected_pod)
  local container=$(kubectl get pod "$pod" -o jsonpath='{.spec.containers[*].name}' | tr ' ' '\n' | fzf --prompt="Select Container: ")
  [[ -n "$pod" ]] && [[ -n "$container" ]] && kubectl debug -it "$pod" --image curlimages/curl --target="$container" -- sh
}

kcds() {
  local resource="${1:-$(kubectl api-resources --no-headers | fzf --prompt="Select Resource: " | awk '{print $1}')}"
  [[ -n "$resource" ]] &&
    echo "-----\nResource: $resource\n-----" && \
    kubectl describe "$resource"
}

# Private functions

_selected_pod() {
  kubectl get pods | fzf | awk '{print $1}'
}

_selected_manifest() {
  find . -type f \( -name '*.yaml' -o -name '*.yml' \) | fzf | awk '{print $1}'
}

