{
  description = "netty flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        javaToolOptions = (pkgs.lib.join " " [
          "--add-exports=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED"
          "--add-exports=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED"
          "--add-exports=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED"
          "--add-exports=jdk.compiler/com.sun.tools.javac.main=ALL-UNNAMED"
          "--add-exports=jdk.compiler/com.sun.tools.javac.model=ALL-UNNAMED"
          "--add-exports=jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED"
          "--add-exports=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED"
          "--add-exports=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED"
          "--add-opens=jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED"
        ]);
        javacArgs = (pkgs.lib.join " " [
          "--processor-path ../checker-framework/checker/build/libs/checker-3.49.5-eisop1-SNAPSHOT.jar:../handles-checker/build/libs/handles-checker.jar"
          "-cp ../checker-framework/checker/dist/checker-qual.jar:../handles-checker/build/libs/handles-checker.jar"
          "-processor org.checkerframework.checker.handles.HandleChecker"
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.bashInteractive
            pkgs.autoconf
            pkgs.automake
            pkgs.libtool
            pkgs.gnumake
            pkgs.cmake
            pkgs.ninja
            pkgs.cargo
            pkgs.gnutar
            pkgs.gcc
            pkgs.git
            pkgs.jdk25
            pkgs.libaio
            pkgs.openssl
            pkgs.apr
            pkgs.lksctp-tools
          ];
          hardeningDisable = [ "all" ];
          JAVA_TOOL_OPTIONS = javaToolOptions;
          JDK_JAVAC_OPTIONS = javacArgs;
        };
      }
    );
}
