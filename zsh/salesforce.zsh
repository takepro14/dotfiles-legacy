# Salesforce functions

soql() {
  local query=$1 org=${2:-prod}
  sf data query --query $query --target-org $org
}

sfprefix() {
  local org=${1:-prod}
  sf data query --query "SELECT QualifiedApiName, Label, KeyPrefix FROM EntityDefinition" --target-org $org
}

sfcol() {
  local obj=$1 org=${2:-prod}
  sf force:schema:sobject:describe --target-org $org -s $obj | jq -r '.fields[] | [.label, .name] | @sh' | awk 'BEGIN {print "fields_array=("} {print "  (" $0 ")"} END {print ")"}'
}

sfmeta() {
  local obj=$1 org=${2:-prod}
  sf force:schema:sobject:describe -s $obj -o $org
}


