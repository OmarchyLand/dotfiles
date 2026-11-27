// tokyo-night: neon skyline and a flickering vertical sign.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property color neon: v.lock.pal("magenta", v.lock.accent)
  readonly property color glass: v.lock.pal("yellow", v.lock.fg)

  Canvas {
    id: city
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    height: v.height * 0.32
    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)
      var seed = 7
      function rnd() { seed = (seed * 16807) % 2147483647; return seed / 2147483647 }
      for (var layer = 0; layer < 2; layer++) {
        var x = 0
        while (x < width) {
          var w = 40 + rnd() * 90
          var h = height * (layer ? 0.25 + rnd() * 0.55 : 0.45 + rnd() * 0.55)
          ctx.globalAlpha = 1
          ctx.fillStyle = layer ? "#0b0d16" : "#06070c"
          ctx.fillRect(x, height - h, w - 4, h)
          ctx.fillStyle = v.glass.toString()
          for (var wy = height - h + 10; wy < height - 8; wy += 14)
            for (var wx = x + 6; wx < x + w - 12; wx += 11)
              if (rnd() < 0.18) { ctx.globalAlpha = 0.15 + rnd() * 0.45; ctx.fillRect(wx, wy, 4, 6) }
          x += w
        }
      }
    }
    Component.onCompleted: requestPaint()
  }

  Column {
    id: sign
    anchors { right: parent.right; rightMargin: v.width * 0.08; top: parent.top; topMargin: v.height * 0.12 }
    spacing: 0
    opacity: flicker.value
    property real dummy: 0
    Repeater {
      model: ["東", "京", "夜"]
      Txt {
        required property string modelData
        text: modelData
        size: v.lock.unit * 4
        color: v.neon
        layer.enabled: v.lock.effects
        layer.effect: Glow { glowColor: v.neon }
      }
    }
    QtObject { id: flicker; property real value: 1 }
    SequentialAnimation {
      running: v.visible; loops: Animation.Infinite
      PauseAnimation { duration: 4200 }
      PropertyAction { target: flicker; property: "value"; value: 0.25 }
      PauseAnimation { duration: 70 }
      PropertyAction { target: flicker; property: "value"; value: 1 }
      PauseAnimation { duration: 120 }
      PropertyAction { target: flicker; property: "value"; value: 0.4 }
      PauseAnimation { duration: 50 }
      PropertyAction { target: flicker; property: "value"; value: 1 }
    }
  }

  Clock {
    id: clock
    lock: v.lock
    color: v.lock.accent
    font.letterSpacing: size * 0.05
    layer.enabled: v.lock.effects
    layer.effect: Glow { glowColor: v.lock.accent; strength: 0.7 }
  }
  Txt {
    anchors { top: clock.bottom; horizontalCenter: clock.horizontalCenter }
    size: v.lock.unit * 1.1
    color: v.neon
    font.letterSpacing: size * 0.3
    text: "日月火水木金土".charAt(v.lock.now.getDay()) + "曜日  ·  " + Qt.formatDate(v.lock.now, "MM.dd")
  }

  Status {
    lock: v.lock
    opacity: 0.8
    idleText: ""
    busyText: "checking…"
    deniedText: "wrong key"
  }
}
