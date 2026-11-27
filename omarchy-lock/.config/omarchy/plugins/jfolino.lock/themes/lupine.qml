// lupine: flower spires rising from both bottom corners.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock

  Canvas {
    anchors.fill: parent
    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)
      var hues = [v.lock.accent, v.lock.pal("magenta", v.lock.accent), v.lock.pal("blue", v.lock.accent)]
      var stem = v.lock.pal("green", v.lock.muted).toString()
      var seed = 3
      function rnd() { seed = (seed * 16807) % 2147483647; return seed / 2147483647 }
      function spire(x, h, c) {
        var base = height + 4, top = base - h
        ctx.globalAlpha = 0.5; ctx.strokeStyle = stem; ctx.lineWidth = 3
        ctx.beginPath(); ctx.moveTo(x, base); ctx.quadraticCurveTo(x + 8, base - h * 0.5, x, top); ctx.stroke()
        // Palmate leaves at the foot.
        for (var l = -3; l <= 3; l++) {
          var a = -Math.PI / 2 + l * 0.35
          ctx.beginPath(); ctx.moveTo(x, base - h * 0.12)
          ctx.lineTo(x + Math.cos(a) * h * 0.14, base - h * 0.12 + Math.sin(a) * h * 0.1); ctx.stroke()
        }
        ctx.fillStyle = c.toString()
        var bloom = h * 0.55
        for (var y = 0; y < bloom; y += 9) {
          var spread = (1 - y / bloom) * h * 0.06 + 3
          var r = 2 + (1 - y / bloom) * 4
          for (var s = -1; s <= 1; s += 2) {
            ctx.globalAlpha = 0.35 + 0.5 * (y / bloom)
            ctx.beginPath(); ctx.arc(x + s * spread * (0.6 + rnd() * 0.4), top + h * 0.45 - y - h * 0.0, r, 0, Math.PI * 2); ctx.fill()
          }
        }
      }
      for (var i = 0; i < 6; i++) {
        spire(width * (0.03 + i * 0.035) + rnd() * 20, height * (0.25 + rnd() * 0.25), hues[i % 3])
        spire(width * (0.97 - i * 0.035) - rnd() * 20, height * (0.25 + rnd() * 0.25), hues[(i + 1) % 3])
      }
    }
    Component.onCompleted: requestPaint()
  }

  Clock {
    id: clock
    lock: v.lock
    font.bold: true
  }
  Txt {
    anchors { top: clock.bottom; horizontalCenter: clock.horizontalCenter }
    size: v.lock.unit * 1.1
    color: v.lock.accent
    text: Qt.formatDate(v.lock.now, "dddd d MMMM").toLowerCase()
  }

  Status {
    lock: v.lock
    idleColor: v.lock.muted
    idleText: ""
    busyText: "…"
    deniedText: "try again"
  }
}
