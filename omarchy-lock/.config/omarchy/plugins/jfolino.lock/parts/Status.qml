// One line under the password field reporting auth state. Overlays set the
// three strings (and colours) to speak in their theme's voice.
import QtQuick

Txt {
  required property Item lock
  property string idleText: ""
  property string busyText: "…"
  property string deniedText: "try again"
  property color idleColor: lock.accent
  property color deniedColor: lock.urgent

  anchors.top: parent.verticalCenter
  anchors.topMargin: lock.fieldBelow + Math.round(lock.unit * 1.4)
  anchors.horizontalCenter: parent.horizontalCenter
  size: lock.unit
  color: lock.denied ? deniedColor : idleColor
  text: lock.denied ? deniedText : lock.busy ? busyText : idleText
}
