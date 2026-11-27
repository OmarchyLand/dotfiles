// ristretto: a cup steaming above the clock.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  property real phase: 0

  Timer {
    interval: 50; repeat: true; running: v.visible
    onTriggered: { v.phase += 0.05; steam.requestPaint() }
  }

  Txt {
    id: cup
    anchors { horizontalCenter: parent.horizontalCenter; bottom: clock.top; bottomMargin: v.lock.unit * 0.5 }
    text: ""
    size: v.lock.unit * 4.5
    color: v.lock.accent
  }
  Canvas {
    id: steam
    width: cup.width * 1.4; height: v.lock.unit * 7
    anchors { horizontalCenter: cup.horizontalCenter; horizontalCenterOffset: -cup.width * 0.1; bottom: cup.top }
    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)
      ctx.strokeStyle = v.lock.fg.toString()
      ctx.lineWidth = 2.5
      ctx.lineCap = "round"
      for (var s = 0; s < 3; s++) {
        var bx = width * (0.3 + s * 0.2)
        ctx.beginPath()
        for (var y = height; y > 0; y -= 3) {
          var k = 1 - y / height
          var x = bx + Math.sin(y / 11 + v.phase * 2 + s * 2) * (3 + k * 9)
          ctx.globalAlpha = 0.5 * (y / height)
          if (y === height) ctx.moveTo(x, y); else ctx.lineTo(x, y)
        }
        ctx.globalAlpha = 0.35
        ctx.stroke()
      }
    }
  }

  Clock {
    id: clock
    lock: v.lock
    color: v.lock.accent
    font.bold: true
    gap: Math.round(v.height / 16)
  }

  Txt {
    anchors { right: parent.right; bottom: parent.bottom; margins: v.height * 0.06 }
    size: v.lock.unit * 1.1
    opacity: 0.6
    text: Qt.formatDate(v.lock.now, "dddd d MMMM").toLowerCase()
  }

  Status {
    lock: v.lock
    idleColor: v.lock.muted
    idleText: ""
    busyText: "extracting…"
    deniedText: "bitter · try again"
  }
}
