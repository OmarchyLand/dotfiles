// oled-low-glare: minimum emitted light. Small dim clock, no glow, and the
// whole group shifts a few pixels every minute so nothing burns in.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  property real dx: 0
  property real dy: 0

  Timer {
    interval: 60000; repeat: true; running: v.visible
    onTriggered: { v.dx = Math.round((Math.random() - 0.5) * 16); v.dy = Math.round((Math.random() - 0.5) * 10) }
  }

  Item {
    anchors.fill: parent
    anchors.leftMargin: v.dx; anchors.topMargin: v.dy
    anchors.rightMargin: -v.dx; anchors.bottomMargin: -v.dy

    Clock {
      id: clock
      lock: v.lock
      size: Math.round(v.height * 0.075)
      color: v.lock.fg
      opacity: 0.7
      gap: Math.round(v.height / 16)
      font.weight: Font.Light
    }
    Txt {
      anchors { top: clock.bottom; horizontalCenter: clock.horizontalCenter }
      size: v.lock.unit
      color: v.lock.muted
      text: Qt.formatDate(v.lock.now, "ddd d MMM").toLowerCase()
    }
    Status {
      lock: v.lock
      idleColor: v.lock.muted
      deniedColor: v.lock.accent
      idleText: ""
      busyText: "…"
      deniedText: "incorrect"
    }
  }
}
