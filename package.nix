{
  buildNpmPackage,
  npmDepsHash,
  nodejs,
  lib,
  stdenv,
  playwright-driver,
  browserName ? "chrome",
}:
let
  browserProgram =
    if browserName == "chrome" && !stdenv.targetPlatform.isLinux then "Chromium" else browserName;

  browsers =
    if stdenv.targetPlatform.isLinux then
      playwright-driver.browsers.override {
        withFirefox = false;
        withWebkit = false;
        withFfmpeg = false;
        # fontconfig_file = { fontDirectories = []; };
      }
    else
      playwright-driver.browsers;

  versionSpec = (lib.importJSON ./package.json).dependencies."@playwright/cli";

  versionMatch = builtins.match "\\^([0-9]+(\\.[0-9]+)+)" versionSpec;

  version = if versionMatch == null then "unknown" else builtins.elemAt versionMatch 0;
in
buildNpmPackage {
  pname = "playwright-cli";
  src = lib.cleanSource ./.;
  inherit version npmDepsHash;

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = [ "--ignore-scripts" ];

  dontNpmBuild = true;

  postInstall = ''
    bindir="$out/lib/node_modules/nix-playwright-cli/node_modules/.bin"

    browser_executable="$(find -L '${browsers}' -name ${browserProgram} -type f)"

    makeWrapper $(realpath "$bindir/playwright-cli") $out/bin/playwright-cli \
      --chdir "$bindir" \
      --set PLAYWRIGHT_MCP_BROWSER "${browserName}" \
      --set PLAYWRIGHT_MCP_EXECUTABLE_PATH "''${browser_executable}"
  '';

  meta = {
    description = "CLI for common Playwright actions. Record and generate Playwright code, inspect selectors and take screenshots.";
    homepage = "https://github.com/microsoft/playwright-cli";
    license = lib.licenses.asl20;
    inherit (nodejs.meta) platforms;
  };
}
