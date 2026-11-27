// white: a newspaper front page. Serif, rules, a dateline.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property real w: Math.min(v.width * 0.6, v.height * 1.1)

  component Rule: Rectangle {
    width: v.w; height: 1
    anchors.horizontalCenter: parent.horizontalCenter
    color: v.lock.fg
  }

  Rule { id: r1; y: clock.y - v.lock.unit * 3.2; height: 3 }
  Rule { y: r1.y + 6 }
  Txt {
    anchors { bottom: r1.top; bottomMargin: v.lock.unit * 0.6; horizontalCenter: parent.horizontalCenter }
    font.family: "serif"
    size: v.lock.unit * 1.1
    font.letterSpacing: size * 0.3
    text: Qt.formatDate(v.lock.now, "dddd, MMMM d, yyyy").toUpperCase() + "   ·   LOCKED EDITION"
  }

  Clock {
    id: clock
    lock: v.lock
    font.family: "serif"
    font.bold: true
    gap: Math.round(v.height / 9)
  }

  Rule { id: r2; y: clock.y + clock.height + v.lock.unit * 0.4 }
  Txt {
    anchors { top: r2.bottom; topMargin: v.lock.unit * 0.5; horizontalCenter: parent.horizontalCenter }
    font.family: "serif"
    font.italic: true
    size: v.lock.unit * 1.1
    opacity: 0.7
    text: "Workstation " + v.lock.hostName + " closed to the public; owner expected back shortly."
  }

  Status {
    lock: v.lock
    font.family: "serif"
    font.italic: true
    idleColor: v.lock.fg
    idleText: ""
    busyText: "Going to press…"
    deniedText: "Correction: that was not the password."
  }
}
