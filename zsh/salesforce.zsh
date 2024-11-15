# Salesforce functions

soql() {
  local query=$1 org=$2
  if [[ $query == *"*"* ]]; then
    local obj=$(echo $query | sed -n 's/.*from \([a-zA-Z0-9_]*\).*/\1/p')
    local all_columns=$(sf sobject describe -s $obj -o $org | jq -r '.fields[].name' | tr '\n' ',' | sed 's/,$//')
    query=$(echo "$query" | sed "s/\*/$all_columns/")
  fi
  echo "----- \nSOQL: $query\n-----"
  sf data query -q $query -o $org
}

sfprefixes() {
  local org=$1
  sf data query -q 'SELECT QualifiedApiName, Label, KeyPrefix FROM EntityDefinition' -o $org
}

sfmeta() {
  local obj=$1 org=$2
  sf sobject describe -s $obj -o $org
}

sfcols() {
  local obj=$1 org=$2
  sf sobject describe -s $obj -o $org | jq -r '.fields[] | [.label, .name] | @sh' | awk 'BEGIN {print "fields=("} {print "  (" $0 ")"} END {print ")"}'
}

