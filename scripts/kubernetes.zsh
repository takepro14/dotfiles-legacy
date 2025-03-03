source <(kubectl completion zsh)
alias kc='kubectl'

export MANIFESTS_DIR=.

# ex. kcg | kcg all | kcg pod [options]
kcg() {
  if [[ -z "$1" ]]; then
    local resource=$(_selected_resource)
    [[ -n "$resource" ]] && kubectl get "$resource" -n default
  elif [[ "$1" == "all" ]]; then
    kubectl get ingress,services,nodes,deployments,replicasets,pods
  else
    kubectl get "$@"
  fi
}

# ex. kca | kca -f *.yaml [options]
kca() {
  if [[ -z "$1" ]]; then
    local manifest=$(_selected_manifest)
    [[ -n "$manifest" ]] && kubectl apply -f "$manifest" -n default
  else
    kubectl apply "$@"
  fi
}

# ex. kcd | kcd -f *.yaml [options]
kcd() {
  if [[ -z "$1" ]]; then
    local manifest=$(_selected_manifest)
    [[ -n "$manifest" ]] && kubectl delete -f "$manifest" -n default
  else
    kubectl delete "$@"
  fi
}

# ex. kce | kce -it <pod-name> [options]
kce() {
  if [[ -z "$1" ]]; then
    local pod=$(_selected_pod)
    [[ -n "$pod" ]] && kubectl exec -it "$pod" -- /bin/sh -n default
  else
    kubectl exec "$@"
  fi
}

# ex. kcl | kcl -f <pod-name> [options]
kcl() {
  if [[ -z "$1" ]]; then
    local pod=$(_selected_pod)
    [[ -n "$pod" ]] && kubectl logs "$pod" -n default
  else
    kubectl logs "$@"
  fi
}

# ex. kcdb | kcdb -it <pod-name> [options]
kcdb() {
  if [[ -z "$1" ]]; then
    local pod=$(_selected_pod)
    local container=$(_selected_container "$pod")
    [[ -n "$pod" && -n "$container" ]] && kubectl debug -it "$pod" --image curlimages/curl --target="$container" -- sh
  else
    kubectl debug "$@"
  fi
}

# ex. kcds | kcds <resource-name> [options]
kcds() {
  if [[ -z "$1" ]]; then
    local resource=$(_selected_resource)
    [[ -n "$resource" ]] && kubectl describe "$resource" -n default
  else
    kubectl describe "$@"
  fi
}

# Private functions

_selected_resource() {
  local resource=$(kubectl api-resources --no-headers | fzf --prompt="Resource: " | awk '{print $1}')
  [[ -n "$resource" ]] && echo "Resource: $resource\n-----" >&2 && echo "$resource"
}

_selected_pod() {
  local pod=$(kubectl get pods --no-headers | fzf --prompt="Pod: " | awk '{print $1}')
  [[ -n "$pod" ]] && echo "Pod: $pod\n-----" >&2 && echo "$pod"
}

_selected_container() {
  local container=$(kubectl get pods "$1" --no-headers -o jsonpath='{.spec.containers[*].name}' | tr ' ' '\n' | fzf --prompt="Container: ")
  [[ -n "$container" ]] && echo "Container: $container\n-----" >&2 && echo "$container"
}

_selected_manifest() {
  local manifest=$(find "$MANIFESTS_DIR" -type f \( -name '*.yaml' -o -name '*.yml' \) | fzf --prompt="Manifest: ")
  [[ -n "$manifest" ]] && echo "Manifest: $manifest\n-----" >&2 && echo "$manifest"
}

