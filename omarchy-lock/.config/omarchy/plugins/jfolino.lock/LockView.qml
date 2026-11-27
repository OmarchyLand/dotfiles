// Per-theme lock screen.
//
// Service.qml here is a symlink to Omarchy's own lock service, so PAM,
// fingerprint and session-lock handling stay Omarchy's and update with it.
// That service instantiates `LockView` from this directory, which is this
// file: it embeds Omarchy's real LockView (password field, wallpaper) and
// loads a decoration overlay for the active theme behind it (Omarchy's
// opaque backdrop is made transparent, so the field floats on the overlay):
//
//   themes/<theme-name>.qml   if it exists
//   themes/default.qml        otherwise (the movie-terminal look)
//
// The theme name comes from ~/.local/state/omarchy/current/theme.name and is
// watched, so `omarchy theme set` swaps the overlay live. Overlays get this
// item as `lock` and read the clock, auth state and palette from it. They are
// decoration only: Omarchy's view sits on top and takes all input. Should
// Omarchy's view ever change shape, the overlay just ends up hidden behind
// its backdrop; unlocking keeps working.
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Commons as Commons
import "file:///usr/share/omarchy/shell/plugins/lock" as Upstream

Item {
  id: root

  // Same interface Service.qml drives on Omarchy's LockView.
  property string backgroundPath: ""
  property string videoPosterPath: ""
  property int backgroundVersion: 0
  property bool fingerprintConfigured: false
  property bool fingerprintUnavailable: false
  property bool authenticatingPassword: false
  property string failureMessage: ""
  property int failedAttempts: 0
  property bool inputEnabled: true
  property bool loadBackground: true
  property string passwordText: ""

  signal submitPassword(string password)
  signal passwordTextEdited(string password)
  signal clearFailureRequested()
  signal wakeRequested()

  function forcePasswordFocus() { base.forcePasswordFocus() }
  function clearPassword() { base.clearPassword() }

  // Set to force an overlay regardless of the active theme (used for previews).
  property string themeOverride: ""

  readonly property string stateDir: Quickshell.env("HOME") + "/.local/state/omarchy/current"
  readonly property string themeName: themeOverride.length > 0
    ? themeOverride
    : (themeFile.text() || "").trim()

  // ── What overlays read ────────────────────────────────────────────────
  readonly property color accent: Commons.Color.accent
  readonly property color fg: Commons.Color.foreground
  readonly property color bg: Commons.Color.background
  readonly property color muted: Commons.Color.muted
  readonly property bool light: (bg.r + bg.g + bg.b) / 3 > 0.5
  readonly property color urgent: Commons.Color.lock.textError
  readonly property string mono: Style.font.family
  readonly property string userName: Quickshell.env("USER") || "user"
  readonly property string hostName: (hostFile.text() || "localhost").trim()
  readonly property bool denied: failureMessage.length > 0
  readonly property bool busy: authenticatingPassword
  // Half the 67px field Omarchy centres on screen, plus the fingerprint notice.
  readonly property int fieldHalf: 34
  readonly property int fieldBelow: fieldHalf + (fingerprintUnavailable ? 50 : 0)
  // Base text size that scales with the screen.
  readonly property int unit: Math.max(12, Math.round(height / 72))

  property date now: new Date()
  property bool cursorOn: true
  // Seconds since the lock appeared, for overlays that animate on a clock.
  property real t: 0

  // Every `key = "#rrggbb"` from the theme's colors.toml (red, cyan, color4…),
  // as colours.
  property var colors: ({})
  function pal(name, fallback) {
    var v = colors[name]
    return v ? v : (fallback === undefined ? fg : fallback)
  }

  // Glow/blur layers need the GPU; LOCK_NO_EFFECTS=1 turns them off for
  // offscreen previews.
  readonly property bool effects: Quickshell.env("LOCK_NO_EFFECTS") !== "1"

  FileView { id: hostFile; path: "/etc/hostname" }
  FileView {
    id: themeFile
    path: root.stateDir + "/theme.name"
    watchChanges: true
    onFileChanged: reload()
  }
  FileView {
    id: colorsFile
    path: root.stateDir + "/theme/colors.toml"
    watchChanges: true
    onFileChanged: reload()
    onLoaded: root.parsePalette(text())
  }

  function parsePalette(src) {
    var out = {}
    var lines = String(src || "").split("\n")
    for (var i = 0; i < lines.length; i++) {
      var m = lines[i].match(/^\s*([A-Za-z0-9_]+)\s*=\s*"(#[0-9A-Fa-f]{6,8})"/)
      if (m) out[m[1]] = Qt.lighter(m[2], 1.0)
    }
    colors = out
  }

  Timer {
    interval: 1000; repeat: true; triggeredOnStart: true
    running: root.visible
    onTriggered: root.now = new Date()
  }
  Timer {
    interval: 530; repeat: true
    running: root.visible
    onTriggered: root.cursorOn = !root.cursorOn
  }
  Timer {
    interval: 33; repeat: true
    running: root.visible && overlay.item !== null && overlay.item.animated === true
    onTriggered: root.t += 0.033
  }

  Rectangle {
    anchors.fill: parent
    color: root.bg
  }

  Loader {
    id: overlay
    anchors.fill: parent
    enabled: false

    readonly property url dir: Qt.resolvedUrl("themes/")
    property string loadedName: ""

    function load() {
      var name = root.themeName.length > 0 ? root.themeName : "default"
      if (name === loadedName) return
      loadedName = name
      setSource(dir + name + ".qml", { lock: root })
    }

    // No overlay for this theme: fall back to the default one.
    onStatusChanged: {
      if (status === Loader.Error && loadedName !== "default") {
        loadedName = "default"
        setSource(dir + "default.qml", { lock: root })
      }
    }

    Component.onCompleted: load()
    Connections {
      target: root
      function onThemeNameChanged() { overlay.load() }
    }
  }

  Upstream.LockView {
    id: base
    anchors.fill: parent
    backgroundPath: root.backgroundPath
    videoPosterPath: root.videoPosterPath
    backgroundVersion: root.backgroundVersion
    fingerprintConfigured: root.fingerprintConfigured
    fingerprintUnavailable: root.fingerprintUnavailable
    authenticatingPassword: root.authenticatingPassword
    failureMessage: root.failureMessage
    failedAttempts: root.failedAttempts
    inputEnabled: root.inputEnabled
    // No wallpaper: the overlay is the backdrop.
    loadBackground: false
    passwordText: root.passwordText
    onSubmitPassword: function(password) { root.submitPassword(password) }
    onPasswordTextEdited: function(password) { root.passwordTextEdited(password) }
    onClearFailureRequested: root.clearFailureRequested()
    onWakeRequested: root.wakeRequested()

    // Omarchy paints an opaque background Rectangle first; clear it so the
    // overlay below shows around the field.
    Component.onCompleted: {
      for (var i = 0; i < children.length; i++) {
        if (children[i].color !== undefined) { children[i].color = "transparent"; break }
      }
    }
  }
}
