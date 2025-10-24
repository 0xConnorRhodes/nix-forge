{ config, pkgs, inputs, ... }:
let
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions.${pkgs.system};
  marketplace-extensions = nix-vscode-extensions.vscode-marketplace;
in
{
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      yzhang.markdown-all-in-one # markdown bullets
    ] ++

    (with marketplace-extensions; [
      satokaz.vscode-markdown-header-coloring
      imaikosuke.vscode-wiki-links
      #arr.marksman # slower than wikilinks, allows for file preview
      #davidanson.vscode-markdownlint
      #esbenp.prettier-vscode
    ]);

    userSettings = {
      "[markdown]" = {
        editor = {
          bracketPairColorization.enabled = false;
          lightbulb.enabled = "off";
          matchBrackets = false;
          guides = {
            bracketPairs = false;
            bracketPairsHorizontal = false;
          };
        };
      };

      # Vim key bindings for markdown
      vim.normalModeKeyBindingsNonRecursive = [
        { before = ["<Space>" "v" "p"];
          commands = ["markdown.showPreviewToSide"];
          when = "editorLangId == markdown"; }
      ];

      github.copilot.enable.markdown = false;

      # Set markdown link text
      tokenColorCustomizations = {
        textMateRules = [
          # text of link title
          { scope = "string.other.link.title.markdown";
            settings = { foreground = "#C5E478"; };
          }
          # { scope = "punctuation.definition.string.begin.markdown, punctuation.definition.string.end.markdown";
          #   settings = { foreground = "#C5E478"; };
          # }
          # text of parens and brackets in links
          { scope = "punctuation.definition.metadata.markdown";
            settings = { foreground = "#ffffff"; };
          }
          # text of url
          { scope = "markup.underline.link.markdown";
            settings = { foreground = "#888888"; };
          }
        ];
      };

      # EXTENSION SETTINGS

      # satokaz.vscode-markdown-header-coloring
      markdown-header-coloring = {
        backgroundColor = false;
        userDefinedHeaderColor = {
          enabled = true;

          Header_1 = { color = "#78DCE8"; };
          Header_2 = { color = "#82AAFF"; };
          Header_3 = { color = "#C792EA"; };
          Header_4 = { color = "#FFCB6B"; };
          Header_5 = { color = "#FF5370"; };
          Header_6 = { color = "#C3E88D"; };
        };
      };

      # yzhang.markdown-all-in-one
      markdown.extension = {
        math.enabled = false;
      };

      # imaikosuke.vscode-wiki-links
      vscodeWikiLinks.workspaceFilenameConvention = "relativePaths";
    };
  };
}
