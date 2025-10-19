{ config, pkgs, ... }:
let
  codeDir = "${config.home.homeDirectory}/code";
  scriptsDir = "${codeDir}/scripts";
in
{
  programs.vscode.profiles.default.userTasks = {
    version = "2.0.0";
    tasks = [
      {
        label = "Open Daily Note";
        type = "shell";
        command = "uv";
        args = [ "run" "--script" "${scriptsDir}/pkm/open-daily-note" ];
        group = "pkm";
        presentation = {
          echo = false;
          reveal = "silent";
          focus = false;
          panel = "shared";
          showReuseMessage = false;
          clear = true;
        };
        problemMatcher = [];
        runOptions = {
          runOn = "default";
        };
      }
      {
        label = "Build FP Note";
        type = "shell";
        command = "uv";
        args = [ "run" "--script" "${scriptsDir}/pkm/build-fp-note" ];
        group = "pkm";
        presentation = {
          echo = false;
          reveal = "silent";
          focus = false;
          panel = "shared";
          showReuseMessage = false;
          clear = true;
        };
        problemMatcher = [];
        runOptions = {
          runOn = "default";
        };
      }
      {
        label = "Prune Drafts";
        type = "shell";
        command = "uv";
        args = [ "run" "--script" "${scriptsDir}/pkm/prune-drafts" ];
        group = "pkm";
        presentation = {
          echo = false;
          reveal = "silent";
          focus = false;
          panel = "shared";
          showReuseMessage = false;
          clear = true;
        };
        problemMatcher = [];
        runOptions = {
          runOn = "default";
        };
      }
    ];
  };
}
