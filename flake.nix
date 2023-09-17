# ============================================================================ #
#
#
#
# ---------------------------------------------------------------------------- #

{

# ---------------------------------------------------------------------------- #

  description = "A Bison/Flex C++ example";


# ---------------------------------------------------------------------------- #

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";


# ---------------------------------------------------------------------------- #

  outputs = { nixpkgs, ... }: let

# ---------------------------------------------------------------------------- #

    eachDefaultSystemMap = fn: let
      defaultSystems = [
        "x86_64-linux"  "aarch64-linux"  "i686-linux"
        "x86_64-darwin" "aarch64-darwin"
      ];
      proc = system: { name = system; value = fn system; };
    in builtins.listToAttrs ( map proc defaultSystems );


# ---------------------------------------------------------------------------- #

    inherit (nixpkgs) lib;


# ---------------------------------------------------------------------------- #

    # Aggregate dependency overlays here.

    # If you only need `nixpkgs.legacyPackages', use this
    overlays.deps = final: prev: {};


# ---------------------------------------------------------------------------- #

    # Define our overlay
  
    overlays.calc-cpp = final: prev: {
      ## calc-cpp = final.callPackage ./default.nix {};
    };

    
    # Make our default overlay as `deps + calc-cpp'.
    overlays.default = lib.composeExtensions overlays.deps overlays.calc-cpp;


# ---------------------------------------------------------------------------- #

  in {

    inherit lib overlays;

    # Installable Packages for Flake CLI.
    packages = eachDefaultSystemMap ( system: let
      pkgsFor = nixpkgs.legacyPackages.${system}.extend overlays.default;
    in {
      ##inherit (pkgsFor) calc-cpp;
      ##default = pkgsFor.calc-cpp;
    } );


    devShells = eachDefaultSystemMap ( system: let
      pkgsFor        = nixpkgs.legacyPackages.${system}.extend overlays.default;
      calc-cpp-shell = pkgsFor.mkShell {
        name     = "calc-cpp-shell";
        packages = [
          pkgsFor.bison
          pkgsFor.flex
        ];
        shellHook = ''
          shopt -s autocd;

          alias gs='git status';
          alias ga='git add';
          alias gc='git commit -am';
          alias gl='git pull';
          alias gp='git push';
        '';
      };
    in {
      inherit calc-cpp-shell;
      default = calc-cpp-shell;
    } );


  };  # End `outputs'


# ---------------------------------------------------------------------------- #

}


# ---------------------------------------------------------------------------- #
#
#
#
# ============================================================================ #
