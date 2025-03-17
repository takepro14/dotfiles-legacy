abc() {
  contest=$1
  pj_root=~/ghq/github.com/takepro14/atcoder
  contest_dir=abc${contest}

  cd ${pj_root}

  if [[ ! -d "${contest_dir}" ]]; then
    acc new ${contest_dir}
  else
    acc add
  fi

  open https://atcoder.jp/contests/abc${contest}/tasks/abc${contest}_a

  nvim abc${CONTEST}/${PROBLEM}.cpp
}
