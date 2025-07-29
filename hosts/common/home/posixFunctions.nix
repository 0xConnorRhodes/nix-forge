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
''
