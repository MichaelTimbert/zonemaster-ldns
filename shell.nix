with (import <nixpkgs> {});
let
   MIMEBase32 = pkgs.perl538Packages.buildPerlPackage {
    pname = "MIME-Base32";
    version = "1.303";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/MIME-Base32-1.303.tar.gz";
      hash = "sha256-qyH6mRMOM6Cv9s21lvZH5eVl0gfWNLou8Gvb71BCTpk=";
    };
    meta = {
      homepage = "https://metacpan.org/release/MIME-Base32";
      description = "Base32 encoder and decoder";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

ZonemasterLDNS = pkgs.perl538Packages.buildPerlPackage {
    pname = "Zonemaster-LDNS";
    version = "3.2.0";
    src = ./.;
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include -I${pkgs.libidn2}.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -L${lib.getLib pkgs.libidn2}/lib -lcrypto -lidn2";

    makeMakerFlags = [ "--prefix-openssl=${pkgs.openssl.dev}" ];

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = with pkgs.perl538Packages; [ DevelChecklib ModuleInstall ModuleInstallXSUtil TestFatal TestDifferences pkgs.ldns pkgs.libidn2 pkgs.openssl MIMEBase32];
    meta = {
      description = "Perl wrapper for the ldns DNS library";
      license = with lib.licenses; [ bsd3 ];
    };
  };

in
mkShell {
  
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include -I${pkgs.libidn2}.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -L${lib.getLib pkgs.libidn2}/lib -lcrypto -lidn2";

    makeMakerFlags = [ "--prefix-openssl=${pkgs.openssl.dev}" ];
	# perl Makefile.PL --prefix-openssl=/nix/store/i4zk1906f863gjp39vhsjl1imkwyp4qs-openssl-3.3.2-dev
buildInputs = [
	#ZonemasterLDNS
	perl538
	perl538Packages.ModuleInstall
	perl538Packages.DevelChecklib
	perl538Packages.ModuleInstallXSUtil
	perl538Packages.TestDifferences
	perl538Packages.TestFatal
	perl538Packages.TestNoWarnings
	MIMEBase32
	openssl
	libidn2
	git
	libtool
	autoconf
	automake
	];
}
