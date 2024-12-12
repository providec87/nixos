{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.iterm2 pkgs.teams pkgs.obsidian pkgs.neofetch pkgs.vim
        ];
      homebrew = {
    	enable = true;
	# onActivation.cleanup = "uninstall";

	taps = [];
	brews = [ "cowsay" ];
	casks = [ "firefox" "microsoft-teams" "deepl" "cryptomator" "anydesk" "visual-studio-code" ];
      };
	
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      nixpkgs.config.allowUnfree = true;
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;
      
      fonts.packages = [
    	pkgs.atkinson-hyperlegible
	pkgs.jetbrains-mono
        pkgs.carlito
      ];

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      
      security.pam.enableSudoTouchIdAuth = true;

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Ruslans-MacBook-Pro
    darwinConfigurations."Ruslans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
