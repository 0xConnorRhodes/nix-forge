{ inputs, config, pkgs, secrets, ... }:

{
  home.file.".config/btca/btca.config.jsonc".text = builtins.toJSON {
    dataDirectory = ".btca";
    model = secrets.btca.model;
    provider = secrets.btca.provider;
    providerTimeoutMs = 300000;
    resources = [
      {
        type = "git";
        name = "better-context";
        url = "https://github.com/davis7dotsh/better-context";
        branch = "main";
        # searchPath = "apps/svelte.dev";
        # specialNotes = "Focus on the content directory for docs";
      }
    ];
  };
}
