{ config, lib, pkgs, osConfig, secrets, ... }:
let
  shellAliases = import ./shellAliases.nix;
  myPaths = import ./pathDirs.nix { inherit pkgs; };

  # PowerShell aliases that need functions instead of simple aliases
  powerShellFunctions = {
    j = "__zoxide_z";
    ji = "__zoxide_zi";
    vm = "vimv";
    lfcd = "lfcd";
  };

  # Filter out problematic aliases that aren't needed in powershell
  filteredAliases = lib.filterAttrs (name: value:
    # Skip aliases that are replaced by functions
    !(lib.hasAttr name powerShellFunctions) &&
    # Skip aliases that don't make sense in PowerShell
    !(lib.elem name [
      "ssl"
      "sl"
      "gc"
      "gi"
      "gl"
      "gp"
      "gu"
    ])
  ) shellAliases.myAliases;

  # Convert simple aliases to PowerShell format
  mkPowerShellAliases = aliases:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: command:
        # Use Set-Alias for simple commands, function for complex ones
        if lib.hasInfix "&&" command || lib.hasInfix "|" command then
          "function ${name} { ${command} }"
        else
          "Set-Alias -Name '${name}' -Value '${command}'"
      ) aliases
    );

  # PowerShell-specific aliases that override POSIX ones
  powerShellSpecificAliases = {
    cat = "bat --style=plain";  # Keep bat, not Get-Content
    # Add other PowerShell-specific overrides as needed
  };

  finalAliases = filteredAliases // powerShellSpecificAliases;

in
{
  home.file.".config/powershell/Microsoft.PowerShell_profile.ps1" = {
    text = ''
      # Initialize zoxide if available
      if (Get-Command zoxide -ErrorAction SilentlyContinue) {
          Invoke-Expression (& { (zoxide init powershell) -join "`n" })
      }

      # Shell aliases from shellAliases.nix
      ${mkPowerShellAliases finalAliases}

      # Custom functions for complex aliases
      function j {
          if (Get-Command z -ErrorAction SilentlyContinue) {
              z $args
          } else {
              Write-Host "zoxide not available"
          }
      }

      function ji {
          if (Get-Command zi -ErrorAction SilentlyContinue) {
              zi $args
          } else {
              Write-Host "zoxide interactive not available"
          }
      }

      function lfcd {
          $tmp = [System.IO.Path]::GetTempFileName()
          & lf "-last-dir-path=$tmp" $args
          if (Test-Path $tmp) {
              $dir = Get-Content $tmp -Raw
              Remove-Item $tmp
              if ($dir -and (Test-Path $dir.Trim()) -and $dir.Trim() -ne (Get-Location).Path) {
                  Set-Location $dir.Trim()
              }
          }
      }

      function reb {
          & "$env:HOME/code/nix-forge/scripts/rebuild" $args
      }

      # Additional PowerShell-specific configuration
      # Set PowerShell to use UTF-8 encoding
      [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
      [Console]::InputEncoding = [System.Text.Encoding]::UTF8
      $OutputEncoding = [System.Text.Encoding]::UTF8

      # Enable command prediction (PowerShell 7.2+)
      if ($PSVersionTable.PSVersion.Major -ge 7 -and $PSVersionTable.PSVersion.Minor -ge 2) {
          Set-PSReadLineOption -PredictionSource History
          Set-PSReadLineOption -PredictionViewStyle ListView
      }

      # Better error formatting
      $ErrorView = 'ConciseView'
    '';
  };
}
