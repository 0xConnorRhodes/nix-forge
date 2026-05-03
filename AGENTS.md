# nix-forge
- After you make a change, run `scripts/rebuild` to rebuild the system with the new change. Debug any errors you encounter in the build process.
- when editing secrets, edit `secrets.json` directly. It is encrypted with git-crypt.
- Never ssh into one of the machines defined in the config. Always make changes and rebuild locally

