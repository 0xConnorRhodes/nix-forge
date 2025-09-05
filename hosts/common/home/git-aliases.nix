# Git shell aliases for use in shell configurations
{
  gs = "git status";
  ga = "git add \${1:-.}";
  gp = "git push";
  gu = "git pull";
  gl = "git log";
  gb = "git branch";
  gi = "git init";
  gcl = "git clone";
  gc = "git commit";
  gco = "git checkout";
  gd = "git diff --quiet && git diff --cached || git diff";
  gmm = "git add . && git commit -m 'u' && git rebase --continue && git push";
}
