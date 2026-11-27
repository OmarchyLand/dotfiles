// ethereal: soft blurred orbs drifting behind a weightless clock.
import QtQuick
import QtQuick.Effects
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property var hues: [v.lock.accent, v.lock.pal("magenta", v.lock.accent), v.lock.pal("cyan", v.lock.accent),
                               v.lock.pal("yellow", v.lock.fg), v.lock.pal("blue", v.lock.accent)]

  Item {
    id: orbs
    anchors.fill: parent
    layer.enabled: v.lock.effects
    layer.effect: MultiEffect { blurEnabled: true; blur: 1.0; blurMax: 64; autoPaddingEnabled: false }
    Repeater {
      model: 6
      Rectangle {
        id: orb
        required property int index
        readonly property real cx: v.width * (0.15 + Math.random() * 0.7)
        readonly property real cy: v.height * (0.15 + Math.random() * 0.7)
        width: v.height * (0.18 + Math.random() * 0.22); height: width; radius: width / 2
        color: v.hues[index % v.hues.length]
        opacity: v.lock.effects ? 0.28 : 0.12
        property real drift: Math.random() * Math.PI * 2
        x: cx + Math.cos(drift) * v.width * 0.06 - width / 2
        y: cy + Math.sin(drift * 1.3) * v.height * 0.05 - height / 2
        NumberAnimation on drift {
          running: v.visible; loops: Animation.Infinite
          from: orb.drift; to: orb.drift + Math.PI * 2; duration: 40000 + Math.random() * 30000
        }
      }
    }
  }

  Clock {
    id: clock
    lock: v.lock
    font.weight: Font.ExtraLight
    font.letterSpacing: size * 0.18
  }
  Txt {
    anchors { top: clock.bottom; horizontalCenter: clock.horizontalCenter }
    size: v.lock.unit * 1.1
    opacity: 0.7
    font.letterSpacing: size * 0.6
    text: Qt.formatDate(v.lock.now, "dddd").toLowerCase()
  }

  Status {
    lock: v.lock
    idleColor: v.lock.fg
    opacity: 0.6
    font.letterSpacing: size * 0.4
    idleText: "breathe"
    busyText: "drifting…"
    deniedText: "not this time"
  }
}
