// matte-black: Swiss minimal. Huge clock bottom-left, one orange bar.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property real margin: v.height * 0.07

  Rectangle {
    id: bar
    x: v.margin; y: clock.y + clock.height * 0.18
    width: Math.max(8, v.lock.unit * 0.8); height: clock.height * 0.64
    color: v.lock.accent
  }
  Txt {
    id: clock
    anchors { left: bar.right; leftMargin: v.lock.unit * 1.5; bottom: parent.bottom; bottomMargin: v.margin * 0.6 }
    size: Math.round(v.height * 0.26)
    font.weight: Font.Light
    lineHeight: 0.9
    text: Qt.formatTime(v.lock.now, "HH:mm")
  }
  Txt {
    anchors { left: clock.left; bottom: clock.top; bottomMargin: -v.lock.unit }
    size: v.lock.unit * 1.2
    opacity: 0.6
    font.letterSpacing: size * 0.4
    text: Qt.formatDate(v.lock.now, "dddd  d.MM.yyyy").toUpperCase()
  }
  Txt {
    anchors { right: parent.right; top: parent.top; margins: v.margin }
    size: v.lock.unit
    color: v.lock.accent
    font.letterSpacing: size * 0.4
    text: "LOCKED"
  }

  Status {
    lock: v.lock
    idleColor: v.lock.muted
    idleText: ""
    busyText: "—"
    deniedText: "incorrect"
  }
}
