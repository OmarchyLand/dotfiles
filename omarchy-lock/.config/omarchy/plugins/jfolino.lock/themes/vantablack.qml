// vantablack: almost nothing. A tiny clock in the corner, one breathing dot.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock

  Txt {
    anchors { right: parent.right; top: parent.top; margins: v.height * 0.04 }
    size: v.lock.unit
    color: v.lock.muted
    text: Qt.formatTime(v.lock.now, "HH:mm")
  }

  Rectangle {
    anchors { horizontalCenter: parent.horizontalCenter; top: parent.verticalCenter
              topMargin: v.lock.fieldBelow + v.lock.unit * 2 }
    width: 5; height: 5; radius: 2.5
    color: v.lock.denied ? v.lock.urgent : v.lock.accent
    SequentialAnimation on opacity {
      running: v.visible; loops: Animation.Infinite
      NumberAnimation { to: 0.1; duration: 3000; easing.type: Easing.InOutSine }
      NumberAnimation { to: 0.8; duration: 3000; easing.type: Easing.InOutSine }
    }
  }
}
