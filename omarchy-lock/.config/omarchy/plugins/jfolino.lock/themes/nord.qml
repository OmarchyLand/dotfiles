// nord: slow aurora over snow-capped peaks.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property var bands: [v.lock.pal("green"), v.lock.pal("cyan"), v.lock.pal("magenta")]
  property real phase: 0

  // ~10 fps is plenty for something this slow.
  Timer {
    interval: 100; repeat: true; running: v.visible
    onTriggered: { v.phase += 0.02; aurora.requestPaint() }
  }

  Canvas {
    id: aurora
    anchors { left: parent.left; right: parent.right; top: parent.top }
    height: v.height * 0.5
    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)
      for (var b = 0; b < v.bands.length; b++) {
        var c = v.bands[b]
        var base = height * (0.28 + b * 0.12)
        for (var x = 0; x < width; x += 8) {
          var y = base + Math.sin(x / 260 + v.phase * (1 + b * 0.3) + b) * height * 0.08
                       + Math.sin(x / 90 - v.phase * 1.7) * height * 0.02
          var h = height * (0.18 + 0.1 * Math.sin(x / 140 + v.phase + b * 2))
          var g = ctx.createLinearGradient(0, y - h, 0, y)
          var rgb = Math.round(c.r * 255) + "," + Math.round(c.g * 255) + "," + Math.round(c.b * 255)
          g.addColorStop(0, "rgba(" + rgb + ",0)")
          g.addColorStop(1, "rgba(" + rgb + ",0.22)")
          ctx.fillStyle = g
          ctx.fillRect(x, y - h, 8, h)
        }
      }
    }
  }

  Canvas {
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    height: v.height * 0.3
    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)
      var peaks = [[0, 0.55], [0.12, 0.2], [0.22, 0.5], [0.34, 0.08], [0.47, 0.45], [0.58, 0.25],
                   [0.7, 0.55], [0.82, 0.12], [0.93, 0.4], [1, 0.3]]
      ctx.beginPath(); ctx.moveTo(0, height)
      for (var i = 0; i < peaks.length; i++) ctx.lineTo(peaks[i][0] * width, peaks[i][1] * height)
      ctx.lineTo(width, height); ctx.closePath()
      ctx.fillStyle = v.lock.pal("blue", v.lock.accent).toString()
      ctx.globalAlpha = 0.14
      ctx.fill()
      // Snow on the higher peaks.
      ctx.fillStyle = v.lock.fg.toString()
      ctx.globalAlpha = 0.35
      for (var k = 1; k < peaks.length - 1; k++) {
        var p = peaks[k]; if (p[1] > 0.3) continue
        var px = p[0] * width, py = p[1] * height, s = height * 0.12
        var l = peaks[k - 1], r = peaks[k + 1]
        var ls = (l[1] - p[1]) * height / ((p[0] - l[0]) * width)
        var rs = (r[1] - p[1]) * height / ((r[0] - p[0]) * width)
        ctx.beginPath(); ctx.moveTo(px, py); ctx.lineTo(px - s / ls, py + s); ctx.lineTo(px, py + s * 0.7)
        ctx.lineTo(px + s / rs, py + s); ctx.closePath(); ctx.fill()
      }
    }
    Component.onCompleted: requestPaint()
  }

  Clock {
    id: clock
    lock: v.lock
    font.weight: Font.Light
    font.letterSpacing: size * 0.08
  }
  Txt {
    anchors { top: clock.bottom; horizontalCenter: clock.horizontalCenter }
    size: v.lock.unit * 1.1
    color: v.lock.accent
    font.letterSpacing: size * 0.5
    text: Qt.formatDate(v.lock.now, "dddd d MMMM").toUpperCase()
  }

  Status {
    lock: v.lock
    idleColor: v.lock.muted
    idleText: "❄"
    busyText: "thawing…"
    deniedText: "frozen out · try again"
  }
}
