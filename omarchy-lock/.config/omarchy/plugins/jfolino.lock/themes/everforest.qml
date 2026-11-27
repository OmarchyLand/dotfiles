// everforest: a pine ridge and drifting fireflies.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property color pine: v.lock.pal("green", v.lock.accent)
  readonly property color fly: v.lock.pal("yellow", v.lock.accent)

  Canvas {
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    height: v.height * 0.36
    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)
      var seed = 11
      function rnd() { seed = (seed * 16807) % 2147483647; return seed / 2147483647 }
      for (var row = 0; row < 3; row++) {
        ctx.fillStyle = v.pine.toString()
        ctx.globalAlpha = 0.06 + row * 0.05
        var x = -20
        while (x < width + 40) {
          var h = height * (0.35 + rnd() * 0.4) * (0.6 + row * 0.2)
          var w = h * 0.38, base = height - row * height * 0.05
          for (var t = 0; t < 4; t++) {
            var top = base - h + t * h * 0.18, bw = w * (0.45 + t * 0.2)
            ctx.beginPath(); ctx.moveTo(x, top); ctx.lineTo(x - bw / 2, top + h * 0.4); ctx.lineTo(x + bw / 2, top + h * 0.4)
            ctx.closePath(); ctx.fill()
          }
          ctx.fillRect(x - w * 0.04, base - h * 0.15, w * 0.08, h * 0.15)
          x += w * (0.5 + rnd() * 0.5)
        }
      }
    }
    Component.onCompleted: requestPaint()
  }

  Repeater {
    model: 26
    Rectangle {
      id: ff
      required property int index
      width: Math.max(3, v.lock.unit * 0.3); height: width; radius: width / 2
      color: v.fly
      x: Math.random() * v.width
      y: v.height * (0.45 + Math.random() * 0.5)
      layer.enabled: v.lock.effects
      layer.effect: Glow { glowColor: v.fly }
      SequentialAnimation on opacity {
        running: v.visible; loops: Animation.Infinite
        PauseAnimation { duration: Math.random() * 3000 }
        NumberAnimation { to: 0.9; duration: 900 + Math.random() * 900; easing.type: Easing.InOutSine }
        NumberAnimation { to: 0.05; duration: 1400 + Math.random() * 1200; easing.type: Easing.InOutSine }
      }
      NumberAnimation on x {
        running: v.visible; loops: Animation.Infinite
        from: ff.x; to: ff.x + (Math.random() - 0.5) * 300; duration: 9000 + Math.random() * 6000
        easing.type: Easing.InOutSine
      }
    }
  }

  Clock {
    id: clock
    lock: v.lock
    font.letterSpacing: size * 0.05
  }
  Txt {
    anchors { top: clock.bottom; horizontalCenter: clock.horizontalCenter }
    size: v.lock.unit * 1.1
    color: v.lock.accent
    text: Qt.formatDate(v.lock.now, "dddd · d MMMM").toLowerCase()
  }

  Status {
    lock: v.lock
    idleColor: v.lock.muted
    idleText: ""
    busyText: "listening…"
    deniedText: "lost in the woods · try again"
  }
}
