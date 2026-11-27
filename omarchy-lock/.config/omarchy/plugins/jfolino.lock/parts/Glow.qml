// Soft coloured halo for `layer.effect: Glow { glowColor: ... }`.
import QtQuick
import QtQuick.Effects

MultiEffect {
  property color glowColor: "white"
  property real strength: 0.85
  shadowEnabled: true
  shadowColor: glowColor
  shadowBlur: 1.0
  shadowOpacity: strength
  shadowHorizontalOffset: 0
  shadowVerticalOffset: 0
  autoPaddingEnabled: true
}
