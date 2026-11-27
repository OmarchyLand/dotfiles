// rose-pine: petals drifting down past a quiet clock.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property var petalColors: [v.lock.pal("red"), v.lock.pal("magenta"), v.lock.pal("yellow")]

  Repeater {
    model: 22
    Rectangle {
      id: p
      required property int index
      readonly property real sway: 40 + Math.random() * 90
      readonly property real x0: Math.random() * v.width
      width: v.lock.unit * (1.3 + Math.random() * 1.0); height: width * 0.6
      radius: height / 2
      color: v.petalColors[index % v.petalColors.length]
      opacity: 0.35
      property real fall: 0
      x: x0 + Math.sin(fall * Math.PI * 4 + index) * sway
      y: -40 + fall * (v.height + 80)
      rotation: fall * 720 + index * 40
      NumberAnimation on fall {
        running: v.visible; loops: Animation.Infinite
        from: Math.random(); to: 1; duration: 16000 + Math.random() * 12000
        onFinished: p.fall = 0
      }
    }
  }

  Clock {
    id: clock
    lock: v.lock
    font.weight: Font.Light
    font.letterSpacing: size * 0.04
    format: "h:mm"
  }
  Txt {
    anchors { top: clock.bottom; horizontalCenter: clock.horizontalCenter }
    size: v.lock.unit * 1.2
    color: v.lock.accent
    font.italic: true
    text: Qt.formatDate(v.lock.now, "dddd, d MMMM").toLowerCase()
  }

  Status {
    lock: v.lock
    font.italic: true
    idleColor: v.lock.muted
    idleText: ""
    busyText: "a moment…"
    deniedText: "not quite"
  }
}
