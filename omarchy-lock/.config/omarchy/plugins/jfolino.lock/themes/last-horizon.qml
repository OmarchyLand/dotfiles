// last-horizon: a sun half-sunk below a long horizon, with its reflection.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property real horizon: v.height * 0.8
  readonly property color sun: v.lock.accent

  Rectangle {
    id: line
    y: v.horizon; width: v.width; height: 1
    color: v.lock.fg; opacity: 0.35
  }

  // The visible half of the sun.
  Item {
    clip: true
    width: v.height * 0.4; height: width / 2
    anchors { horizontalCenter: parent.horizontalCenter; bottom: line.top }
    Rectangle {
      width: parent.width; height: width; radius: width / 2
      gradient: Gradient {
        GradientStop { position: 0; color: v.lock.pal("yellow", v.sun) }
        GradientStop { position: 0.5; color: v.lock.pal("red", v.sun) }
      }
      opacity: 0.55
    }
  }

  // Broken reflection.
  Repeater {
    model: 9
    Rectangle {
      required property int index
      readonly property real wobble: Math.sin(index * 2.1) * v.lock.unit
      width: v.height * 0.4 * (1 - index / 10) * (0.7 + 0.3 * Math.abs(Math.sin(index * 1.7)))
      height: 2
      x: (v.width - width) / 2 + wobble
      y: v.horizon + 10 + index * index * 2.4 + index * 6
      color: v.sun
      opacity: 0.4 * (1 - index / 9)
    }
  }

  Clock {
    id: clock
    lock: v.lock
    font.weight: Font.Light
    font.letterSpacing: size * 0.1
  }
  Txt {
    anchors { top: clock.bottom; horizontalCenter: clock.horizontalCenter }
    size: v.lock.unit * 1.1
    color: v.sun
    font.letterSpacing: size * 0.5
    text: Qt.formatDate(v.lock.now, "dddd").toUpperCase()
  }

  Status {
    lock: v.lock
    idleColor: v.lock.muted
    idleText: ""
    busyText: "…"
    deniedText: "not yet · try again"
  }
}
