// jade-horse: the clock set in a carved jade disc.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock

  Item {
    id: disc
    anchors.centerIn: clock
    width: clock.implicitWidth * 1.35; height: width

    Rectangle {
      anchors.fill: parent
      radius: width / 2
      color: "transparent"
      border.color: v.lock.accent
      border.width: width * 0.16
      opacity: 0.16
    }
    Rectangle {
      anchors.centerIn: parent
      width: parent.width * 0.68; height: width; radius: width / 2
      color: "transparent"
      border.color: v.lock.accent; border.width: 1
      opacity: 0.5
    }
    // Carved bead ring.
    Repeater {
      model: 36
      Rectangle {
        required property int index
        readonly property real a: index / 36 * Math.PI * 2
        readonly property real r: disc.width * 0.42
        width: 5; height: 5; radius: 2.5
        color: v.lock.accent
        opacity: 0.55
        x: disc.width / 2 + Math.cos(a) * r - 2.5
        y: disc.height / 2 + Math.sin(a) * r - 2.5
      }
    }
    // Slow turn, barely noticeable.
    RotationAnimation on rotation {
      running: v.visible; loops: Animation.Infinite
      from: 0; to: 360; duration: 240000
    }
  }

  Clock {
    id: clock
    lock: v.lock
    size: Math.round(v.height * 0.1)
    gap: Math.round(v.height * 0.13)
    font.letterSpacing: size * 0.06
  }

  Txt {
    anchors { left: parent.left; bottom: parent.bottom; margins: v.height * 0.06 }
    size: v.lock.unit * 3
    color: v.lock.accent
    opacity: 0.6
    text: "馬"
  }
  Txt {
    anchors { right: parent.right; bottom: parent.bottom; margins: v.height * 0.06 }
    size: v.lock.unit * 1.1
    opacity: 0.6
    font.letterSpacing: size * 0.3
    text: Qt.formatDate(v.lock.now, "yyyy · MM · dd")
  }

  Status {
    lock: v.lock
    anchors.topMargin: v.lock.fieldBelow + disc.height * 0.2
    idleText: ""
    busyText: "…"
    deniedText: "the horse balks · try again"
  }
}
