{ stdenv, fetchFromGitHub, makeWrapper
, python, git, gnupg, less, cacert
}:

stdenv.mkDerivation rec {
  name = "git-repo-${version}";
  version = "1.12.37";

  src = fetchFromGitHub {
    owner = "android";
    repo = "tools_repo";
    rev = "v${version}";
    sha256 = "0qp7jqhblv7xblfgpcq4n18dyjdv8shz7r60c3vnjxx2fngkj2jd";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python ];

  # TODO: Cleanup
  patchPhase = ''
    CA_PATH="$(echo '${cacert}/etc/ssl/certs/ca-bundle.crt' | sed 's/\//\\\//g')" # / -> \/
    sed -i -E 's/urlopen\(url\)/urlopen(url, cafile="'$CA_PATH'")/' repo
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp repo $out/bin/repo
  '';

  # Important runtime dependencies
  postFixup = ''
    wrapProgram $out/bin/repo --prefix PATH ":" \
      "${stdenv.lib.makeBinPath [ git gnupg less ]}"
  '';

  meta = with stdenv.lib; {
    description = "Android's repo management tool";
    longDescription = ''
      Repo is a Python script based on Git that helps manage many Git
      repositories, does the uploads to revision control systems, and automates
      parts of the development workflow. Repo is not meant to replace Git, only
      to make it easier to work with Git.
    '';
    homepage = https://android.googlesource.com/tools/repo;
    license = licenses.asl20;
    maintainers = [ maintainers.primeos ];
    platforms = platforms.unix;
  };
}
