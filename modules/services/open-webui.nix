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
            "Help me write"
            "a professional email"
          ];
          content = "Can you help me write a professional email for...";
        }
        {
          title = [
            "Explain"
            "complex concepts"
          ];
          content = "Explain this concept to me like I'm five...";
        }
      ];
    };
  };
}
