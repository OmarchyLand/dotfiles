// gruvbox: 70s racing stripes running through the password field.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property var stripes: [v.lock.pal("red"), v.lock.pal("orange", v.lock.pal("red")),
                                  v.lock.pal("yellow"), v.lock.pal("green")]
  readonly property real band: v.lock.unit * 1.1

  Column {
    anchors.verticalCenter: parent.verticalCenter
    width: parent.width
    spacing: v.band * 0.35
    Repeater {
      model: v.stripes.length
      Rectangle {
        required property int index
        width: parent.width; height: v.band
        color: v.stripes[index]
        opacity: 0.75
      }
    }
  }

  Clock {
    id: clock
    lock: v.lock
    font.bold: true
    color: v.lock.pal("yellow", v.lock.fg)
    gap: Math.round(v.height / 10)
  }
  Txt {
    anchors { top: clock.bottom; horizontalCenter: clock.horizontalCenter }
    size: v.lock.unit * 1.2
    color: v.lock.pal("orange", v.lock.accent)
    font.bold: true
    font.letterSpacing: size * 0.35
    text: Qt.formatDate(v.lock.now, "ddd dd MMM").toUpperCase()
  }

  Status {
    lock: v.lock
    anchors.topMargin: v.lock.fieldBelow + v.band * 3.4
    size: Math.round(v.lock.unit * 1.1)
    font.bold: true
    idleColor: v.lock.fg
    idleText: "far out — locked"
    busyText: "hang loose…"
    deniedText: "bummer, try again"
  }
}
