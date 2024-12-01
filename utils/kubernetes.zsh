# Kubernetes utilities

source <(kubectl completion zsh)
alias kc='kubectl'

kcls() {
  kubectl get nodes,services,deployments,replicasets,pods
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
  [[ -n "$pod" ]] && kubectl exec -it "$pod" -- /bin/ash
}

kcl() {
  local pod=$(_selected_pod)
  [[ -n "$pod" ]] && kubectl logs -f "$pod"
}

kcp() {
  local pod=$(_selected_pod)
  [[ -n "$pod" ]] && kubectl describe pod "$pod"
}

kcn() {
  local node=$(_selected_node)
  [[ -n "$node" ]] && kubectl describe node "$node"
}

kcnips() {
  kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}: {.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}'
}

# Private functions

_selected_pod() {
  kubectl get pods | fzf | awk '{print $1}'
}

_selected_node() {
  kubectl get nodes | fzf | awk '{print $1}'
}

_selected_manifest() {
  find . -type f \( -name '*.yaml' -o -name '*.yml' \) | fzf | awk '{print $1}'
}

