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

mkr() {
  # mkrepo
  # mkr <name> (will create inside ~/code)
  # mkr . (will use current directory, will git init if not already done)
  # mkr ./<name> (will create in current directory)

  local repo_name target_dir gh_repo_name

  if [ $# -eq 0 ]; then
    printf "repo name: "
    read -r repo_name
    if [ -z "$repo_name" ]; then
      echo "No repository name provided"
      return 1
    fi
    # Normalize repo name: lowercase and replace spaces with hyphens
    repo_name=$(printf '%s' "$repo_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    set -- "$repo_name"
  fi

  if [ "$1" = "." ]; then
    target_dir="$PWD"

    gh_repo_name=$(basename "$PWD" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

    if [ ! -d ".git" ]; then
      git init
    fi

    # only add and commit if directory contains files beyond .git
    if [ -n "$(ls -A | grep -v '^\.git$')" ]; then
      git add .
      git commit -m "Initial commit"
    fi
  else
    # Combine all arguments with hyphens and normalize
    repo_name=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    shift
    for arg in "$@"; do
      arg=$(printf '%s' "$arg" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
      repo_name="$repo_name-$arg"
    done

    case "$repo_name" in
      ./*)
        target_dir="$repo_name"
        gh_repo_name=$(basename "$target_dir")
        ;;
      *)
        target_dir="$HOME/code/$repo_name"
        gh_repo_name="$repo_name"
        ;;
    esac

    mkdir -- "$target_dir" || return 1
    cd -- "$target_dir" || return 1
    git init
    git add . || true
    git commit -m "Initial commit" || true
  fi

  # Create GitHub repo and set remote origin for all cases
  gh repo create --private "$gh_repo_name"
  REMOTE_URL=$(gh repo view "$gh_repo_name" --json sshUrl -q .sshUrl)
  git remote add origin "$REMOTE_URL"
}

# git functions
g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status --short
  fi
}

ga() {
  if [[ $# -gt 0 ]]; then
    git add "$@"
  else
    git add .
  fi
}
''
