## Requirements

To use these dotfiles, first configure the VS Code Dotfiles settings for the Dev Containers extension.

```json
"dotfiles.repository": "TeraNovell/dotfiles",
"dotfiles.installCommand": "devcontainer/install.sh",
```

The install script requires the [Common Utilities feature](https://github.com/devcontainers/features/tree/main/src/common-utils) to be configured as a default feature in VS Code. It provides Git and CA certificates, which are required for VS Code to clone this repository. It also provides the non-root user required by Homebrew.

```json
"dev.containers.defaultFeatures": {
    "ghcr.io/devcontainers/features/common-utils:2": {
        "installZsh": false
    }
}
```
