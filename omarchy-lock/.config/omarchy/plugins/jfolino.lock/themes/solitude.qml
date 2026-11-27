// solitude: one star, one line, lots of quiet.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock

  Rectangle {
    id: star
    x: v.width * 0.72; y: v.height * 0.2
    width: 4; height: 4; radius: 2
    color: v.lock.fg
    layer.enabled: v.lock.effects
    layer.effect: Glow { glowColor: v.lock.fg }
    SequentialAnimation on opacity {
      running: v.visible; loops: Animation.Infinite
      NumberAnimation { to: 0.25; duration: 2600; easing.type: Easing.InOutSine }
      NumberAnimation { to: 1; duration: 2600; easing.type: Easing.InOutSine }
    }
  }

  Rectangle {
    y: v.height * 0.8; width: v.width * 0.5; height: 1
    anchors.horizontalCenter: parent.horizontalCenter
    color: v.lock.accent; opacity: 0.4
  }

  Clock {
    lock: v.lock
    size: Math.round(v.height * 0.07)
    color: v.lock.fg
    opacity: 0.8
    font.weight: Font.Light
    font.letterSpacing: size * 0.3
  }

  Status {
    lock: v.lock
    idleColor: v.lock.muted
    idleText: ""
    busyText: "…"
    deniedText: "again"
  }
}
