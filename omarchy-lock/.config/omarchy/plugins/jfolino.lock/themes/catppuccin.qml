// catppuccin: pastel digits with a cat perched on the clock.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property var hues: [v.lock.pal("red"), v.lock.pal("yellow"), v.lock.pal("green"),
                               v.lock.pal("cyan"), v.lock.pal("blue"), v.lock.pal("magenta")]
  property bool blink: false

  Timer {
    interval: 3800; repeat: true; running: v.visible
    onTriggered: { v.blink = true; unblink.restart() }
  }
  Timer { id: unblink; interval: 160; onTriggered: v.blink = false }

  Row {
    id: clock
    anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.verticalCenter
              bottomMargin: v.lock.fieldHalf + v.height / 14 }
    readonly property string s: Qt.formatTime(v.lock.now, "HH:mm")
    Repeater {
      model: clock.s.length
      Txt {
        required property int index
        text: clock.s.charAt(index)
        size: Math.round(Math.min(v.height * 0.15, v.width * 0.11))
        font.bold: true
        color: v.hues[index % v.hues.length]
      }
    }
  }

  Txt {
    id: cat
    anchors { bottom: clock.top; bottomMargin: -v.lock.unit * 1.6; right: clock.right; rightMargin: v.lock.unit }
    size: Math.round(v.lock.unit * 2.6)
    lineHeight: 1.0
    color: v.lock.pal("magenta", v.lock.accent)
    text: " /\\_/\\\n( " + (v.blink ? "-.-" : "o.o") + " )\n > ^ <"
  }

  Txt {
    anchors { top: clock.bottom; horizontalCenter: clock.horizontalCenter }
    size: Math.round(v.lock.unit * 1.2)
    color: v.lock.pal("light_foreground", v.lock.fg)
    text: Qt.formatDate(v.lock.now, "dddd, d MMMM").toLowerCase()
  }

  // Paw prints wandering across the bottom.
  Repeater {
    model: 9
    Txt {
      required property int index
      x: v.width * 0.12 + index * v.width * 0.09
      y: v.height * 0.86 - (index % 2) * v.lock.unit * 2.2
      rotation: 70
      text: ""
      size: v.lock.unit * 1.6
      color: v.lock.accent
      opacity: 0.2 + index * 0.05
    }
  }

  Status {
    lock: v.lock
    idleColor: v.lock.muted
    idleText: "meow"
    busyText: "purr…"
    deniedText: "hiss! wrong password"
  }
}
