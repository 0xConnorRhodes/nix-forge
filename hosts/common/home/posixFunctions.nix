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
    local venv_name="''${1:-.venv}"
    venv_path="$PWD/$venv_name"
    activate_script="$venv_path/bin/activate"

    if [ -f "$activate_script" ]; then
        . "$activate_script"
    else
        echo "Creating new virtual environment at $venv_path"
            python3 -m venv "$venv_path"
        . "$activate_script"
    fi
}

mkrepo() {
  local repo_name target_dir

  # Combine all arguments with hyphens
  repo_name=$(printf '%s' "$1")
  shift
  for arg in "$@"; do
    repo_name="$repo_name-$arg"
  done

  case "$repo_name" in
    ./*)
      target_dir="$repo_name"
      ;;
    *)
      target_dir="$HOME/code/$repo_name"
      ;;
  esac

  mkdir -- "$target_dir" || return 1

  cd -- "$target_dir" || return 1

  gh repo create --private "$repo_name"
}
''
