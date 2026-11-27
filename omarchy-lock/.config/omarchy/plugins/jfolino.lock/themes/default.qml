// Fallback for themes without their own overlay: movie-terminal lock.
// Glowing HH:mm:ss, prompt-style header, [ ACCESS DENIED ] status, scanlines.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock

  component Term: Txt {
    size: v.lock.unit
    color: v.lock.accent
  }

  // CRT scanlines.
  Canvas {
    anchors.fill: parent
    opacity: 0.07
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)
      ctx.fillStyle = "#000000"
      for (var y = 0; y < height; y += 3) ctx.fillRect(0, y, width, 1)
    }
  }

  Column {
    anchors { left: parent.left; top: parent.top; margins: Math.round(v.lock.height / 24) }
    spacing: 4
    Term { text: "> " + v.lock.userName + "@" + v.lock.hostName + " :: secure terminal" }
    Term { text: "> session locked"; opacity: 0.75 }
    Term { text: "> authorization required " + (v.lock.cursorOn ? "█" : " "); opacity: 0.75 }
  }

  Clock {
    id: clock
    lock: v.lock
    format: "HH:mm:ss"
    color: v.lock.accent
    font.bold: true
    font.letterSpacing: size * 0.04
    gap: Math.round(v.lock.height / 18) + date.implicitHeight
    layer.enabled: v.lock.effects
    layer.effect: Glow { glowColor: v.lock.accent }
  }
  Term {
    id: date
    anchors { top: clock.bottom; horizontalCenter: parent.horizontalCenter }
    text: Qt.formatDate(v.lock.now, "ddd dd MMM yyyy").toUpperCase() + "  //  NODE " + v.lock.hostName.toUpperCase()
    color: v.lock.fg
    opacity: 0.7
    font.letterSpacing: size * 0.3
  }

  Status {
    lock: v.lock
    font.letterSpacing: size * 0.35
    font.bold: v.lock.denied
    opacity: v.lock.denied ? 1 : 0.8
    idleText: "[ AWAITING CREDENTIALS ]"
    busyText: "[ VERIFYING" + (v.lock.cursorOn ? " ... ]" : "     ]")
    deniedText: "[ ACCESS DENIED ]"
  }

  Term {
    anchors { left: parent.left; bottom: parent.bottom; margins: Math.round(v.lock.height / 24) }
    opacity: 0.45
    text: "UPLINK SECURE  ·  " + Qt.formatDateTime(v.lock.now, "yyyy-MM-dd'T'HH:mm:ss")
      + "  ·  0x" + (v.lock.now.getTime() >>> 0).toString(16).toUpperCase()
  }
}
