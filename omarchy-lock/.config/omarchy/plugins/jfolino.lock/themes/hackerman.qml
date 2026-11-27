// hackerman: digital rain behind a glowing clock.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property bool animated: true
  readonly property real colW: v.lock.unit * 1.4
  readonly property string glyphs: "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉ0123456789ABCDEF<>/\\|=+*"

  function column() {
    var s = "", n = 14 + Math.floor(Math.random() * 26)
    for (var i = 0; i < n; i++) s += glyphs.charAt(Math.floor(Math.random() * glyphs.length)) + (i < n - 1 ? "\n" : "")
    return s
  }

  Repeater {
    model: Math.ceil(v.width / v.colW)
    Txt {
      id: col
      required property int index
      readonly property real speed: 60 + Math.random() * 220
      readonly property real phase: Math.random() * 5000
      x: index * v.colW
      y: ((v.lock.t * speed + phase) % (v.height + implicitHeight)) - implicitHeight
      size: v.lock.unit
      lineHeight: 1.05
      color: v.lock.accent
      opacity: 0.08 + (index * 7919 % 23) / 23 * 0.28
      text: v.column()
    }
  }

  // Keep the rain off the clock.
  Rectangle {
    anchors.centerIn: clock
    width: clock.implicitWidth + v.lock.unit * 6
    height: clock.implicitHeight + tag.implicitHeight + v.lock.unit * 3
    radius: v.lock.unit
    color: v.lock.bg
    opacity: 0.88
  }

  Clock {
    id: clock
    lock: v.lock
    format: "HH:mm:ss"
    color: v.lock.accent
    font.bold: true
    gap: Math.round(v.lock.height / 12)
    layer.enabled: v.lock.effects
    layer.effect: Glow { glowColor: v.lock.accent }
  }
  Txt {
    id: tag
    anchors { top: clock.bottom; horizontalCenter: clock.horizontalCenter }
    size: v.lock.unit
    color: v.lock.fg
    opacity: 0.8
    font.letterSpacing: size * 0.4
    text: "ROOT@" + v.lock.hostName.toUpperCase() + " :: LOCKED"
  }

  Status {
    lock: v.lock
    font.letterSpacing: size * 0.25
    idleText: "> awaiting handshake" + (v.lock.cursorOn ? "_" : " ")
    busyText: "> decrypting" + (v.lock.cursorOn ? "..." : "   ")
    deniedText: "> INTRUSION LOGGED"
  }
}
