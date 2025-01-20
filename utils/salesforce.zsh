# ===================================
# Salesforce utilities
# ===================================

soql() {
  local query="$1" org="$2"
  [[ "$#" -eq 0 ]] && echo "Usage: soql <query> <org> [all|(json|csv)]" && return 1
  shift 2
  local extra_opts=("$@")
  if [[ $query == *"*"* ]]; then
    local obj=$(echo $query | sed -n 's/.*from \([a-zA-Z0-9_]*\).*/\1/p')
    local all_columns=$(sf sobject describe -s $obj -o $org | jq -r '.fields[].name' | tr '\n' ',' | sed 's/,$//')
    query=$(echo "$query" | sed "s/\*/$all_columns/")
  fi
  echo "----- \nSOQL: $query\n-----"
  sf data query -q $query \
    $([[ "${extra_opts[*]}" == *'all'* ]] && echo '--all-rows') \
    $([[ "${extra_opts[*]}" == *'json'* ]] && echo '--json' || [[ "${extra_opts[*]}" == *'csv'* ]] && echo '-r csv') \
    -o $org
}

sfpref() {
  local org="$1"
  [[ "$#" -eq 0 ]] && echo "Usage: sfpref <org>" && return 1
  sf data query -q 'SELECT QualifiedApiName, Label, KeyPrefix FROM EntityDefinition' -o $org
}

sfmeta() {
  local obj="$1" org="$2"
  [[ "$#" -eq 0 ]] && echo "Usage: sfmeta <obj> <org>" && return 1
  sf sobject describe -s $obj -o $org
}

sfcol() {
  local obj="$1" org="$2"
  [[ "$#" -eq 0 ]] && echo "Usage: sfcol <obj> <org>" && return 1
  sf sobject describe -s $obj -o $org |\
    jq -r '.fields[] | [.label, .name] | @sh' |\
    awk 'BEGIN {print "fields=("} {print "  (" $0 ")"} END {print ")"}'
}

sfacc() {
  local userid="$1" recordid="$2" org="$3"
  [[ "$#" -eq 0 ]] && echo "Usage: sfacc <userid> <recordid> <org>" && return 1
  sf data query -q "SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId = '$userid' AND RecordId = '$recordid'" -o $org
}

