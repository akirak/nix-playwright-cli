# A Nix Flake for Playwright CLI

This repository provides a Nix-wrapped version of the [Playwright CLI](https://github.com/microsoft/playwright-cli)
(`playwright-cli`). The browser executable is set to the Chromium build from Nixpkgs.

The Nix flake also provides a `firefox` package that uses the Firefox build from
Nixpkgs instead.

> [!NOTE]
> There is an [open PR for this package in Nixpkgs](https://github.com/NixOS/nixpkgs/pull/490230).

## Usage

Run the Chromium variant:

``` shell
nix run github:akirak/nix-playwright-mcp
```

Run the Firefox variant:

``` shell
nix run github:akirak/nix-playwright-mcp#firefox
```

Show the available commands:

``` shell
nix run github:akirak/nix-playwright-mcp -- --help
```

## See Also

- [nix-playwright-mcp](https://github.com/akirak/nix-playwright-mcp), now deprecated
