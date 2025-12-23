{ config, lib, ... }:

{
  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 58139;
    environment = {
      DEFAULT_PROMPT_SUGGESTIONS = builtins.toJSON [
        {
          title = [
            "_"
            "_"
          ];
          content = "Write a python function that prints Hello World.";
        }
        {
          title = [
            "_"
            "_"
          ];
          content = "Write a humerous limerick about frogs.";
        }
      ];
    };
  };
}
