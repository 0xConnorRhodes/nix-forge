{ inputs, config, pkgs, secrets, ... }:

{
  home.file.".config/btca/btca.config.jsonc".text = builtins.toJSON {
    dataDirectory = ".btca";
    model = secrets.btca.model;
    provider = secrets.btca.provider;
    providerTimeoutMs = 300000;
    resources = [
      # {
      #   name = "better-context";
      #   type = "git";
      #   url = "https://github.com/davis7dotsh/better-context";
      #   branch = "main";
      #   # searchPath = "apps/svelte.dev";
      #   # searchPaths = ["path/one" "path/two"];
      #   # specialNotes = "Focus on the content directory for docs";
      # }
      {
        name = "better-context";
        type = "git";
        url = "https://github.com/davis7dotsh/better-context";
        branch = "main";
      }
      {
        name = "pyvikunja";
        type = "local";
        path = "${config.home.homeDirectory}/code/vikunja-dev";
        searchPath = "module/vikunja";
      }
    ];
  };
}
