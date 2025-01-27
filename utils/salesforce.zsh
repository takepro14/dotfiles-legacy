# ===================================
# Salesforce utilities
# ===================================

soql() {
  [[ "$#" -eq 0 ]] && echo "Usage: soql <query> <org> [all|(json|csv)]" && return 1
  local query="$1" org="$2"
  shift 2
  local extra_opts=("$@")
  [[ $query == *"*"* ]] && query=$(echo "$query" | sed 's/\*/FIELDS(ALL)/')
  echo "-----\nSOQL: $query\n-----"
  sf data query -q $query \
    $([[ "${extra_opts[*]}" == *'all'* ]] && echo '--all-rows') \
    $([[ "${extra_opts[*]}" == *'json'* ]] && echo '--json' || [[ "${extra_opts[*]}" == *'csv'* ]] && echo '-r csv') \
    -o $org
}

sfpref() {
  [[ "$#" -eq 0 ]] && echo "Usage: sfpref <org>" && return 1
  local org="$1"
  sf data query -q 'SELECT QualifiedApiName, Label, KeyPrefix FROM EntityDefinition' -o $org
}

sfmeta() {
  [[ "$#" -eq 0 ]] && echo "Usage: sfmeta <obj> <org>" && return 1
  local obj="$1" org="$2"
  sf sobject describe -s $obj -o $org
}

sfcol() {
  [[ "$#" -eq 0 ]] && echo "Usage: sfcol <obj> <org>" && return 1
  local obj="$1" org="$2"
  sf sobject describe -s $obj -o $org |\
    jq -r '.fields[] | [.label, .name] | @sh' |\
    awk 'BEGIN {print "fields=("} {print "  (" $0 ")"} END {print ")"}'
}

sfacc() {
  [[ "$#" -eq 0 ]] && echo "Usage: sfacc <userid> <recordid> <org>" && return 1
  local userid="$1" recordid="$2" org="$3"
  sf data query -q "SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId = '$userid' AND RecordId = '$recordid'" -o $org
}

