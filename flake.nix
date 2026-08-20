{
    description = "inushell";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, flake-utils }:
        flake-utils.lib.eachDefaultSystem (system:
        let
            pkgs = nixpkgs.legacyPackages.${system};
        in
        {
            devShells.default = pkgs.mkShell {
                buildInputs = with pkgs; [
                    pkg-config
                    cmake
                    ninja
                    clang

                    qt6.qtbase
                    qt6.qtdeclarative

                    wayland
                    wayland-scanner
                    wayland-protocols
                    dbus

                    pipewire
                    libpulseaudio
                    ffmpeg
                ];

                shellHook = ''
                    export QT_MULTIMEDIA_BACKEND="ffmpeg"
                    export QT_PLUGIN_PATH="${pkgs.lib.makeSearchPath "lib/qt-6/plugins" (with pkgs; [
                        qt6.qtbase
                        qt6.qtdeclarative
                    ])}"
                    export QML_IMPORT_PATH="${pkgs.lib.makeSearchPath "lib/qt-6/qml" (with pkgs; [
                        qt6.qtdeclarative
                    ])}"
                    export QML2_IMPORT_PATH="$QML_IMPORT_PATH"
                    export QML_DISABLE_DISK_CACHE=1

                    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath (with pkgs; [
                        pipewire
                        libpulseaudio
                        ffmpeg
                        libxkbcommon
                    ])}:$LD_LIBRARY_PATH"
                '';

                configurePhase = ''
                    cmake -B build -G "Ninja"
                '';

                buildPhase = ''
                    cmake --build build
                '';
            };
        }
    );
}
