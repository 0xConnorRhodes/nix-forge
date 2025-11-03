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
        label = "Open Walk Note";
        type = "shell";
        command = "uv";
        args = [ "run" "--script" "${scriptsDir}/pkm/open-walk-note" ];
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
        label = "Update ZK";
        type = "shell";
        command = "uv";
        args = [ "run" "--script" "${scriptsDir}/pkm/update-zk" ];
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
        label = "Open Weekly Note";
        type = "shell";
        command = "uv";
        args = [ "run" "--script" "${scriptsDir}/pkm/open-weekly-note" ];
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
        label = "Open Cal Budget";
        type = "shell";
        command = "uv";
        args = [ "run" "--script" "${scriptsDir}/pkm/open-cal-budget" ];
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
        label = "Create New Draft";
        type = "shell";
        command = "uv";
        args = [ "run" "--script" "${scriptsDir}/pkm/create-new-draft" ];
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
        label = "Open Last Draft";
        type = "shell";
        command = "uv";
        args = [ "run" "--script" "${scriptsDir}/pkm/open-last-draft" ];
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
