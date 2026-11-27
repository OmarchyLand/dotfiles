// catppuccin-latte: a sleeping cat, a steaming cup, a pastel date pill.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock

  Clock {
    id: clock
    lock: v.lock
    font.bold: true
    gap: Math.round(v.height / 9)
  }

  Rectangle {
    anchors { top: clock.bottom; topMargin: v.lock.unit * 0.4; horizontalCenter: clock.horizontalCenter }
    width: date.implicitWidth + v.lock.unit * 2.4
    height: date.implicitHeight + v.lock.unit * 0.9
    radius: height / 2
    color: v.lock.accent
    Txt {
      id: date
      anchors.centerIn: parent
      size: v.lock.unit
      color: v.lock.bg
      font.bold: true
      text: Qt.formatDate(v.lock.now, "ddd d MMM").toLowerCase()
    }
  }

  // Cat napping on the clock.
  Txt {
    id: cat
    anchors { bottom: clock.top; bottomMargin: -v.lock.unit * 0.6; left: clock.left }
    size: Math.round(v.lock.unit * 2.2)
    lineHeight: 1.0
    color: v.lock.pal("magenta", v.lock.accent)
    text: "  /\\_/\\\n ( -.- )____\n  (  u  u  )~"
  }
  Repeater {
    model: 3
    Txt {
      required property int index
      x: cat.x + cat.width + index * v.lock.unit * 0.9
      y: cat.y - index * v.lock.unit * 1.0
      text: "z"
      size: v.lock.unit * (1 + index * 0.35)
      color: v.lock.pal("blue", v.lock.accent)
      SequentialAnimation on opacity {
        running: v.visible; loops: Animation.Infinite
        PauseAnimation { duration: index * 500 }
        NumberAnimation { from: 0; to: 0.9; duration: 700 }
        NumberAnimation { from: 0.9; to: 0; duration: 1300 }
        PauseAnimation { duration: (2 - index) * 500 }
      }
    }
  }

  // Cup with rising steam.
  Txt {
    id: cup
    anchors { bottom: clock.top; bottomMargin: v.lock.unit * 0.2; right: clock.right }
    text: ""
    size: v.lock.unit * 4
    color: v.lock.pal("brown", v.lock.pal("yellow"))
  }
  Repeater {
    model: 3
    Txt {
      required property int index
      text: "~"
      size: v.lock.unit * 1.3
      color: v.lock.muted
      x: cup.x + cup.width * 0.15 + index * v.lock.unit * 0.55
      rotation: 90
      SequentialAnimation on y {
        running: v.visible; loops: Animation.Infinite
        PauseAnimation { duration: index * 400 }
        NumberAnimation { from: cup.y; to: cup.y - v.lock.unit * 3; duration: 1800 }
      }
      SequentialAnimation on opacity {
        running: v.visible; loops: Animation.Infinite
        PauseAnimation { duration: index * 400 }
        NumberAnimation { from: 0.8; to: 0; duration: 1800 }
      }
    }
  }

  Status {
    lock: v.lock
    idleColor: v.lock.muted
    idleText: ""
    busyText: "stretching…"
    deniedText: "mrrp? try again"
  }
}
