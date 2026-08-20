pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick



Singleton {
    id: root

    readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors

    readonly property HyprlandToplevel activeToplevel: Hyprland.activeToplevel?.wayland?.activated ? Hyprland.activeToplevel : null
    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
    property HyprlandWorkspace _activeSpecialWorkspace: null
    readonly property HyprlandWorkspace activeSpecialWorkspace: _activeSpecialWorkspace

    signal configReloaded

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    function monitorFor(screen: ShellScreen): HyprlandMonitor {
        return Hyprland.monitorFor(screen);
    }

    function monitorHasFullscreen(monitor: HyprlandMonitor, ignoreMainWhenSpecialActive: bool): bool {
        if (activeSpecialWorkspace && activeSpecialWorkspace.monitor === monitor) {
            if (activeSpecialWorkspace.hasFullscreen) return true
            else if (ignoreMainWhenSpecialActive) return false
        }

        const monitorWorkspaces = Hyprland.workspaces.values.filter(workspace => workspace.monitor === monitor)
        for (let index = 0; index < monitorWorkspaces.length; index++) {
            const monitorWorkspace = monitorWorkspaces[index]
            if (monitorWorkspace.hasFullscreen && monitorWorkspace.active) return true
        }

        return false
    }

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            if (event.name.endsWith("v2"))
                return;

            if (event.name === "configreloaded") {
                root.configReloaded()
            } else if (["workspace", "moveworkspace", "activespecial", "focusedmon"].includes(event.name)) {
                Hyprland.refreshWorkspaces()
                Hyprland.refreshMonitors()
            } else if (["openwindow", "closewindow", "movewindow"].includes(event.name)) {
                Hyprland.refreshToplevels()
                Hyprland.refreshWorkspaces()
            } else if (event.name.includes("mon")) {
                Hyprland.refreshMonitors()
            } else if (event.name.includes("workspace")) {
                Hyprland.refreshWorkspaces()
            } else if (event.name.includes("window") || event.name.includes("group") || ["pin", "fullscreen", "changefloatingmode", "minimize"].includes(event.name)) {
                Hyprland.refreshToplevels()
            }

            if (event.name.includes("activespecial")) {
                const activeSpecialWorkspaceName = event.data.split(",")[0]
                _activeSpecialWorkspace = Hyprland.workspaces.values.find(workspace => workspace.name === activeSpecialWorkspaceName) ?? null
            }
        }
    }
}