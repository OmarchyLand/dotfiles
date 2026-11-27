// Plain text in the theme's font and foreground colour.
import QtQuick
import qs.Commons
import qs.Commons as Commons

Text {
  property int size: 18
  textFormat: Text.PlainText
  font.family: Style.font.family
  font.pixelSize: size
  color: Commons.Color.foreground
}
