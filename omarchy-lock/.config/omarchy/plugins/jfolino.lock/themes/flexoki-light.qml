// flexoki-light: a page of ruled notebook paper.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property real line: Math.round(v.lock.unit * 2.2)

  Canvas {
    anchors.fill: parent
    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)
      ctx.strokeStyle = v.lock.pal("blue", v.lock.accent).toString()
      ctx.globalAlpha = 0.18
      ctx.lineWidth = 1
      for (var y = v.line * 3; y < height; y += v.line) {
        ctx.beginPath(); ctx.moveTo(0, y + 0.5); ctx.lineTo(width, y + 0.5); ctx.stroke()
      }
      ctx.strokeStyle = v.lock.pal("red", v.lock.urgent).toString()
      ctx.globalAlpha = 0.45
      var mx = Math.round(width * 0.09) + 0.5
      ctx.beginPath(); ctx.moveTo(mx, 0); ctx.lineTo(mx, height); ctx.stroke()
      // Punch holes.
      ctx.globalAlpha = 0.12
      ctx.fillStyle = v.lock.fg.toString()
      for (var k = 0; k < 3; k++) {
        ctx.beginPath(); ctx.arc(width * 0.035, height * (0.2 + k * 0.3), v.lock.unit * 0.9, 0, Math.PI * 2); ctx.fill()
      }
    }
    Component.onCompleted: requestPaint()
  }

  Txt {
    x: v.width * 0.09 + v.lock.unit
    y: v.line * 3 - implicitHeight - 2
    size: v.lock.unit * 1.2
    color: v.lock.accent
    text: Qt.formatDate(v.lock.now, "ddd d MMM yyyy")
  }

  Clock {
    lock: v.lock
    font.weight: Font.Light
  }

  Status {
    lock: v.lock
    idleColor: v.lock.muted
    idleText: ""
    busyText: "reading…"
    deniedText: "scribbled out · try again"
  }
}
