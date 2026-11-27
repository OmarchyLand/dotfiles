// lumon: retro corporate terminal over a field of drifting numbers.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property int cols: 32
  readonly property int rows: 16
  property var hot: []

  Timer {
    interval: 1600; repeat: true; running: v.visible; triggeredOnStart: true
    onTriggered: {
      var h = []
      for (var i = 0; i < 14; i++) h.push(Math.floor(Math.random() * v.cols * v.rows))
      v.hot = h
    }
  }

  Grid {
    anchors.centerIn: parent
    columns: v.cols
    readonly property real cell: Math.min(v.width / (v.cols + 2), v.height / (v.rows + 4))
    Repeater {
      model: v.cols * v.rows
      Item {
        required property int index
        width: parent.cell; height: parent.cell
        Txt {
          anchors.centerIn: parent
          readonly property bool hot: v.hot.indexOf(index) >= 0
          text: String(Math.floor(Math.random() * 10))
          size: v.lock.unit * 1.3
          color: v.lock.accent
          opacity: hot ? 0.55 : 0.09
          scale: hot ? 1.5 : 1
          Behavior on scale { NumberAnimation { duration: 700; easing.type: Easing.InOutSine } }
          Behavior on opacity { NumberAnimation { duration: 700 } }
        }
      }
    }
  }

  // Header and footer rules.
  component Bar: Rectangle {
    width: v.width * 0.92; height: 2
    anchors.horizontalCenter: parent.horizontalCenter
    color: v.lock.accent; opacity: 0.6
  }
  Bar { id: topRule; y: v.height * 0.075 }
  Txt {
    anchors { left: topRule.left; bottom: topRule.top; bottomMargin: 6 }
    size: v.lock.unit; color: v.lock.accent; font.letterSpacing: size * 0.25
    text: "WORKSTATION " + v.lock.hostName.toUpperCase()
  }
  Txt {
    anchors { right: topRule.right; bottom: topRule.top; bottomMargin: 6 }
    size: v.lock.unit; color: v.lock.accent; font.letterSpacing: size * 0.25
    text: "THIS TERMINAL IS LOCKED"
  }
  Bar { id: bottomRule; y: v.height * 0.925 }
  Txt {
    anchors { left: bottomRule.left; top: bottomRule.bottom; topMargin: 6 }
    size: v.lock.unit; color: v.lock.accent; font.letterSpacing: size * 0.25
    text: "AUTHORIZED PERSONNEL ONLY"
  }
  Txt {
    anchors { right: bottomRule.right; top: bottomRule.bottom; topMargin: 6 }
    size: v.lock.unit; color: v.lock.accent; font.letterSpacing: size * 0.25
    text: "THANK YOU FOR YOUR PATIENCE"
  }

  // Clock on a solid plate so the numbers don't run through it.
  Rectangle {
    anchors.centerIn: clock
    width: clock.implicitWidth + v.lock.unit * 4; height: clock.implicitHeight + v.lock.unit
    color: v.lock.bg
    border.color: v.lock.accent; border.width: 2
  }
  Clock {
    id: clock
    lock: v.lock
    color: v.lock.fg
    size: Math.round(v.height * 0.1)
    font.letterSpacing: size * 0.1
  }

  Status {
    lock: v.lock
    font.letterSpacing: size * 0.25
    idleText: ""
    busyText: "VERIFYING EMPLOYEE CREDENTIALS"
    deniedText: "CREDENTIALS NOT RECOGNIZED"
  }
}
