{
  lib,
  stdenv,
  pkgs,

  # Build Tools
  pkg-config,
  cmake,
  ninja,
  gcc,
  makeWrapper,

  # Shared
  qt6,

  # Shell
  quickshell,
  fish,
  bash,
  hyprland,

  # Options
  debug ? false
}:let 
  version = "0.0.0";
  cmakeBuildType = if debug then "Debug" else "RelWithDebInfo";
  cmakeVersionFlags = [
    (lib.cmakeFeature "VERSION" version)
  ];

  runtimeDeps = [ fish bash hyprland ];

  plugin = stdenv.mkDerivation {
    inherit version cmakeBuildType;
    name = "inu-shell-qml-plugin${lib.optionalString debug "-debug"}";
    src = lib.fileset.toSource {
      root = ./.;
      fileset = lib.fileset.union ./CMakeLists.txt ./extension;
    };

    nativeBuildInputs = [ pkg-config cmake ninja gcc ];
    buildInputs = [ qt6.qtbase qt6.qtdeclarative ];

    dontWrapQtApps = true;
    cmakeFlags = [
      (lib.cmakeFeature "ENABLE_MODULES" "plugin")
      (lib.cmakeFeature "INSTALL_QMLDIR" qt6.qtbase.qtQmlPrefix)
    ] ++ cmakeVersionFlags;
  };
in stdenv.mkDerivation {
  inherit version cmakeBuildType;
  pname = "inu-shell${lib.optionalString debug "-debug"}";

  src = ./.;

  nativeBuildInputs = [ cmake ninja gcc makeWrapper qt6.wrapQtAppsHook ];
  buildInputs = [ quickshell plugin qt6.qtbase ];
  propagatedBuildInputs = runtimeDeps;

  dontStrip = debug;
  cmakeFlags = [
    (lib.cmakeFeature "ENABLE_MODULES" "shell")
    (lib.cmakeFeature "INSTALL_QSCONFDIR" "${placeholder "out"}/share/inu-shell")
  ] ++ cmakeVersionFlags;

  postInstall = ''
    makeWrapper ${quickshell}/bin/qs $out/bin/inu-shell \
      --prefix PATH : "${lib.makeBinPath runtimeDeps}" \
      --add-flags "-p $out/share/inu-shell"
  '';

  passthru = {
    inherit plugin;
  };
}