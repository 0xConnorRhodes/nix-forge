{config, pkgs, ...}:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false; # don't print a newline at the start of each new prompt
      # format = "$directory$git_branch$git_status";
      username.disabled = true;

      hostname = {
        ssh_only = true;
        format = "@[$hostname](blue) ";
      };

      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };

      git_status = {
        deleted = "x";
      };

      shell = {
        disabled = false;
        format = "[$indicator]($style)";
        style = "white";
        bash_indicator = "\\$";
        zsh_indicator = "";
      };

      nix_shell = {
        format = "[$symbol]($style)";
        symbol = " ";
        style = "bright-blue";
      };

      cmd_duration = {
        min_time = 4000; # time in milliseconds
        format = "[$duration]($style) ";
      };

      python = {
        disabled = false;
        # show python only if inside a virtual env: `py (venv) >`
        format = "([py \\($virtualenv\\)]($style) )";
      };

      # disabled modules
      line_break.disabled = true; # make prompt a single line instead of two lines
      ruby.disabled = true;
      lua.disabled = true;
      nodejs.disabled = true;
      package.disabled = true;
      golang.disabled = true;
      bun.disabled = true;
    };
  };
}
