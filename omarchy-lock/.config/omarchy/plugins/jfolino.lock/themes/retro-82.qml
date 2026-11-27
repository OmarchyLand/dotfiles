// retro-82: synthwave sun over a neon grid floor.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property color sunTop: v.lock.pal("yellow", v.lock.accent)
  readonly property color sunBottom: v.lock.pal("magenta", v.lock.pal("red"))
  readonly property color grid: v.lock.pal("magenta", v.lock.accent)
  readonly property real horizon: height * 0.66

  // Sun with the classic cut-out bands.
  Canvas {
    id: sun
    readonly property real r: v.height * 0.24
    width: r * 2; height: r * 2
    x: (v.width - width) / 2
    y: v.horizon - r * 1.8
    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)
      var g = ctx.createLinearGradient(0, 0, 0, height)
      g.addColorStop(0, v.sunTop.toString())
      g.addColorStop(1, v.sunBottom.toString())
      ctx.fillStyle = g
      ctx.beginPath(); ctx.arc(r, r, r, 0, Math.PI * 2); ctx.fill()
      ctx.globalCompositeOperation = "destination-out"
      for (var i = 0; i < 7; i++) {
        var y = r * 1.05 + i * i * r * 0.025 + i * r * 0.1
        ctx.fillRect(0, y, width, 3 + i * 2.2)
      }
    }
    opacity: 0.55
    Component.onCompleted: requestPaint()
  }

  // Perspective grid.
  Canvas {
    id: floor
    y: v.horizon
    width: v.width; height: v.height - v.horizon
    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)
      ctx.strokeStyle = v.grid.toString()
      ctx.lineWidth = 1.5
      var cx = width / 2
      for (var i = -24; i <= 24; i++) {
        ctx.globalAlpha = 0.5
        ctx.beginPath(); ctx.moveTo(cx + i * 6, 0); ctx.lineTo(cx + i * width / 10, height); ctx.stroke()
      }
      for (var k = 1; k < 14; k++) {
        var y = height * Math.pow(k / 13, 2.2)
        ctx.globalAlpha = 0.15 + 0.6 * k / 13
        ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(width, y); ctx.stroke()
      }
      ctx.globalAlpha = 1
      ctx.lineWidth = 2
      ctx.beginPath(); ctx.moveTo(0, 0.5); ctx.lineTo(width, 0.5); ctx.stroke()
    }
    Component.onCompleted: requestPaint()
  }

  Clock {
    id: clock
    lock: v.lock
    color: v.lock.accent
    font.bold: true
    font.italic: true
    font.letterSpacing: size * 0.06
    layer.enabled: v.lock.effects
    layer.effect: Glow { glowColor: v.grid }
  }
  Txt {
    anchors { bottom: clock.top; horizontalCenter: clock.horizontalCenter }
    size: v.lock.unit * 1.2
    color: v.grid
    font.letterSpacing: size * 0.6
    text: Qt.formatDate(v.lock.now, "ddd · dd · MM · yy").toUpperCase()
  }

  Status {
    lock: v.lock
    size: Math.round(v.lock.unit * 1.2)
    font.bold: true
    font.letterSpacing: size * 0.3
    idleColor: v.sunTop
    opacity: v.lock.denied || v.lock.cursorOn ? 1 : 0.35
    idleText: "INSERT PASSWORD TO CONTINUE"
    busyText: "LOADING..."
    deniedText: "GAME OVER · TRY AGAIN"
  }
}
