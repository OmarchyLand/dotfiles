// kanagawa: layered ink waves, a red seal and the date in kanji.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property color sea: v.lock.pal("blue", v.lock.accent)
  readonly property color foam: v.lock.fg
  readonly property color seal: v.lock.pal("red", v.lock.urgent)

  function kanji(n) {
    var d = "〇一二三四五六七八九"
    if (n < 10) return d.charAt(n)
    var t = Math.floor(n / 10), o = n % 10
    return (t > 1 ? d.charAt(t) : "") + "十" + (o ? d.charAt(o) : "")
  }

  Canvas {
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    height: v.height * 0.34
    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)
      for (var k = 0; k < 6; k++) {
        var base = height * (0.25 + k * 0.13)
        var amp = height * (0.16 - k * 0.018)
        var len = width / (2.2 + k * 0.6)
        ctx.beginPath()
        ctx.moveTo(0, height)
        for (var x = 0; x <= width; x += 6) {
          var p = (x + k * 137) / len * Math.PI * 2
          // Sharpened crests: waves that curl rather than roll.
          var y = base - amp * Math.pow((Math.sin(p) + 1) / 2, 3.2)
          ctx.lineTo(x, y)
        }
        ctx.lineTo(width, height)
        ctx.closePath()
        ctx.globalAlpha = 1
        ctx.fillStyle = v.lock.bg.toString()
        ctx.fill()
        ctx.globalAlpha = 0.25 + k * 0.1
        ctx.strokeStyle = (k % 2 ? v.sea : v.foam).toString()
        ctx.lineWidth = 2
        ctx.stroke()
      }
    }
    Component.onCompleted: requestPaint()
  }

  // Vertical date, right edge.
  Txt {
    id: vdate
    anchors { right: parent.right; rightMargin: v.width * 0.07; top: parent.top; topMargin: v.height * 0.1 }
    size: v.lock.unit * 1.8
    lineHeight: 1.1
    opacity: 0.8
    text: (v.kanji(v.lock.now.getMonth() + 1) + "月" + v.kanji(v.lock.now.getDate()) + "日").split("").join("\n")
  }

  // Hanko.
  Rectangle {
    anchors { horizontalCenter: vdate.horizontalCenter; top: vdate.bottom; topMargin: v.lock.unit }
    width: v.lock.unit * 3.4; height: width
    radius: width * 0.12
    color: v.seal
    Txt {
      anchors.centerIn: parent
      text: "鍵"
      size: parent.width * 0.62
      color: v.lock.bg
    }
  }

  Clock {
    lock: v.lock
    font.letterSpacing: size * 0.12
    opacity: 0.92
  }

  Status {
    lock: v.lock
    opacity: 0.8
    idleText: ""
    busyText: "…"
    deniedText: "もう一度  ·  once more"
  }
}
