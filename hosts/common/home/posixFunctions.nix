''
nf() {
  ls -At1 . | sed '/\.DS_Store/d' | sed '/\.git/d' | sed -n '1p'
}

lnf() {
  ls -At1 . | sed '/\.DS_Store/d' | sed '/\.git/d' | sed -n '2p'
}

# https://github.com/gokcehan/lf/blob/master/etc/lfcd.sh
lfcd() {
    # `command` is needed in case `lfcd` is aliased to `lf`
    cd "$(command lf -print-last-dir "$@")"
}

mcd() {
  mkdir -p "$1" && cd "$1";
}

g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status --short
  fi
}

pyvenv() {
    venv_path="$PWD/.venv"
    activate_script="$venv_path/bin/activate"

    if [ -f "$activate_script" ]; then
        . "$activate_script"
    else
        echo "Creating new virtual environment at $venv_path"
            python3 -m venv "$venv_path"
        . "$activate_script"
    fi
}
''
