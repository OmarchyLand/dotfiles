// miasma: fog banks rolling across a murky clock.
import QtQuick
import QtQuick.Effects
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property var tones: [v.lock.accent, v.lock.pal("green", v.lock.accent), v.lock.pal("yellow", v.lock.muted), v.lock.muted]

  Item {
    anchors.fill: parent
    layer.enabled: v.lock.effects
    layer.effect: MultiEffect { blurEnabled: true; blur: 1.0; blurMax: 48; autoPaddingEnabled: false }
    Repeater {
      model: 8
      Rectangle {
        id: bank
        required property int index
        readonly property real speed: (index % 2 ? 1 : -1) * (8 + Math.random() * 14)
        readonly property real x0: Math.random() * v.width
        width: v.width * (0.6 + Math.random() * 0.6)
        height: v.height * (0.06 + Math.random() * 0.08)
        radius: height / 2
        y: v.height * (0.08 + index * 0.115)
        color: v.tones[index % v.tones.length]
        opacity: v.lock.effects ? 0.22 : 0.08
        property real off: 0
        x: ((x0 + off) % (v.width + width) + (v.width + width)) % (v.width + width) - width
        NumberAnimation on off {
          running: v.visible; loops: Animation.Infinite
          from: 0; to: bank.speed * 600; duration: 600000
        }
      }
    }
  }

  Clock {
    id: clock
    lock: v.lock
    color: v.lock.fg
    font.letterSpacing: size * 0.08
    layer.enabled: v.lock.effects
    layer.effect: Glow { glowColor: v.lock.accent; strength: 0.6 }
  }
  Txt {
    anchors { top: clock.bottom; horizontalCenter: clock.horizontalCenter }
    size: v.lock.unit * 1.1
    color: v.lock.accent
    font.italic: true
    text: Qt.formatDate(v.lock.now, "dddd, d MMMM").toLowerCase()
  }

  Status {
    lock: v.lock
    idleColor: v.lock.muted
    font.italic: true
    idleText: ""
    busyText: "wading…"
    deniedText: "the bog refuses · try again"
  }
}
