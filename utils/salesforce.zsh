# Salesforce utilities

# soql(query: string, org: string, ...extra_opts: ("all" | ("json" | "csv"))[]): void
soql() {
  local query=$1 org=$2
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
  read 'org?Org: '
  sf data query -q 'SELECT QualifiedApiName, Label, KeyPrefix FROM EntityDefinition' -o $org
}

sfmeta() {
  read 'obj?Object: '; read 'org?Org: '
  sf sobject describe -s $obj -o $org
}

sfcol() {
  read 'obj?Object: '; read 'org?Org: '
  sf sobject describe -s $obj -o $org | jq -r '.fields[] | [.label, .name] | @sh' | awk 'BEGIN {print "fields=("} {print "  (" $0 ")"} END {print ")"}'
}

sfacc() {
  read 'userid?UserId: '; read 'recordid?RecordId: '; read 'org?Org: '
  sf data query -q "SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId = '$userid' AND RecordId = '$recordid'" -o $org
}

