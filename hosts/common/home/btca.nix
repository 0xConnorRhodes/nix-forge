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
      {
        type = "git";
        name = "verkadaModule";
        url = "https://github.com/bepsoccer/verkadaModule";
        branch = "master";
      }
      {
        type = "git";
        name = "silverbullet";
        url = "https://github.com/silverbulletmd/silverbullet";
        branch = "main";
        specialNotes = "Prioritize searching inside the website/ directory. this is where the documentation lives. However, not everything in this project is documented, so you may search the source code outside of the website/ directory if you can't find an answer within that directory.";
      }
      {
        type = "git";
        name = "anthropic-sdk-python";
        url = "https://github.com/anthropics/anthropic-sdk-python";
        branch = "main";
      }
    ];
  };
}
