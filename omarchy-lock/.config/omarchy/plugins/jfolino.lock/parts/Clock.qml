// The time, centred above the password field by default.
import QtQuick

Txt {
  required property Item lock
  property string format: "HH:mm"
  // Gap between the clock's bottom and the field's top.
  property int gap: Math.round(lock.height / 14)

  anchors.horizontalCenter: parent.horizontalCenter
  anchors.bottom: parent.verticalCenter
  anchors.bottomMargin: lock.fieldHalf + gap
  size: Math.round(Math.min(lock.height * 0.15, lock.width * 0.11))
  text: Qt.formatTime(lock.now, format)
}
