{ config, pkgs, inputs, ... }:
let
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions.${pkgs.system};
  marketplace-extensions = nix-vscode-extensions.vscode-marketplace;

  # Markdown link color override variables
  link_text_color = "#C5E478";
  link_symbols_color = "#D7DBE0";
  link_url_color = "#637777";
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

      # Token color customizations for markdown links
      editor.tokenColorCustomizations = {
        textMateRules = [
          {
            scope = [
              "markup.underline.link.markdown"
              "markup.underline.link"
              "meta.link.inline.markdown markup.underline.link.markdown"
              "meta.link.inline.markdown markup.underline.link"
              "meta.paragraph.markdown markup.underline.link.markdown"
              "markup.list.unnumbered.markdown markup.underline.link.markdown"
              "text.html.markdown markup.underline.link.markdown"
            ];
            settings = {
              foreground = link_url_color;
            };
          }
          {
            scope = [
              "string.other.link.title.markdown"
              "meta.link.inline.markdown"
              "meta.paragraph.markdown"
              "markup.list.unnumbered.markdown"
              "text.html.markdown"
            ];
            settings = {
              foreground = link_text_color;
            };
          }
          {
            scope = [
              "punctuation.definition.link.title.begin.markdown"
              "punctuation.definition.link.title.end.markdown"
              "punctuation.definition.wiki-link"
              "punctuation.definition.metadata.markdown"
            ];
            settings = {
              foreground = link_symbols_color;
            };
          }
        ];
      };

      tokenColorCustomizations = {
        "markup.underline.link" = link_url_color;
        "markup.underline.link.markdown" = link_url_color;
        "string.other.link.title.markdown" = link_text_color;
        "meta.link.inline.markdown" = link_text_color;
        "meta.paragraph.markdown" = link_text_color;
        "markup.list.unnumbered.markdown" = link_text_color;
        "text.html.markdown" = link_text_color;
        "[Night Owl (No Italics)]" = {
          "markup.underline.link" = link_url_color;
          "markup.underline.link.markdown" = link_url_color;
          "string.other.link.title.markdown" = link_text_color;
          "meta.link.inline.markdown" = link_text_color;
          "meta.paragraph.markdown" = link_text_color;
          "markup.list.unnumbered.markdown" = link_text_color;
          "text.html.markdown" = link_text_color;
        };
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
