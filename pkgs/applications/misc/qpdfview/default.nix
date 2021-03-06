{stdenv, fetchurl, qmake, qtbase, qtsvg, pkgconfig, poppler_qt5, djvulibre, libspectre, cups
, file, ghostscript
}:
let
  s = # Generated upstream information
  rec {
    baseName="qpdfview";
    version = "0.4.16";
    name="${baseName}-${version}";
    url="https://launchpad.net/qpdfview/trunk/${version}/+download/qpdfview-${version}.tar.gz";
    sha256 = "0zysjhr58nnmx7ba01q3zvgidkgcqxjdj4ld3gx5fc7wzvl1dm7s";
  };
  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [
    qtbase qtsvg poppler_qt5 djvulibre libspectre cups file ghostscript
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit nativeBuildInputs buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };

  # TODO: revert this once placeholder is supported
  preConfigure = ''
    qmakeFlags="$qmakeFlags *.pro TARGET_INSTALL_PATH=$out/bin PLUGIN_INSTALL_PATH=$out/lib/qpdfview DATA_INSTALL_PATH=$out/share/qpdfview MANUAL_INSTALL_PATH=$out/share/man/man1 ICON_INSTALL_PATH=$out/share/icons/hicolor/scalable/apps LAUNCHER_INSTALL_PATH=$out/share/applications APPDATA_INSTALL_PATH=$out/share/appdata"
  '';

  meta = {
    inherit (s) version;
    description = "A tabbed document viewer";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://launchpad.net/qpdfview;
    updateWalker = true;
  };
}
