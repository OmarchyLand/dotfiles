// starship: drifting starfield, an orbit ring and HUD telemetry.
import QtQuick
import "../parts"

Item {
  id: v
  required property Item lock
  readonly property bool animated: true

  Repeater {
    model: 160
    Rectangle {
      required property int index
      readonly property real depth: 0.2 + Math.random() * 0.8
      readonly property real x0: Math.random() * v.width
      width: depth > 0.85 ? 3 : depth > 0.5 ? 2 : 1; height: width
      radius: width / 2
      color: v.lock.fg
      opacity: 0.2 + depth * 0.6
      x: ((x0 - v.lock.t * depth * 14) % v.width + v.width) % v.width
      y: Math.random() * v.height
    }
  }

  // Orbit ring around the clock with a satellite.
  Item {
    id: orbit
    anchors.centerIn: clock
    width: clock.implicitWidth * 1.5; height: width * 0.32
    Rectangle {
      anchors.fill: parent
      radius: height / 2
      color: "transparent"
      border.color: v.lock.accent; border.width: 1
      opacity: 0.45
    }
    Rectangle {
      readonly property real a: v.lock.t * 0.6
      width: 8; height: 8; radius: 4
      color: v.lock.accent
      x: orbit.width / 2 + Math.cos(a) * orbit.width / 2 - 4
      y: orbit.height / 2 + Math.sin(a) * orbit.height / 2 - 4
      layer.enabled: v.lock.effects
      layer.effect: Glow { glowColor: v.lock.accent }
    }
  }

  Clock {
    id: clock
    lock: v.lock
    format: "HH:mm:ss"
    font.bold: true
    size: Math.round(v.height * 0.11)
    font.letterSpacing: size * 0.06
  }

  // Corner brackets.
  Repeater {
    model: 4
    Item {
      required property int index
      readonly property real m: v.height * 0.05
      readonly property real s: v.lock.unit * 2.5
      width: s; height: s
      x: index % 2 ? v.width - m - s : m
      y: index < 2 ? m : v.height - m - s
      Rectangle { width: parent.s; height: 2; color: v.lock.accent; y: index < 2 ? 0 : parent.s - 2 }
      Rectangle { width: 2; height: parent.s; color: v.lock.accent; x: index % 2 ? parent.s - 2 : 0 }
    }
  }

  component Hud: Txt {
    size: v.lock.unit
    color: v.lock.accent
    font.letterSpacing: size * 0.25
  }
  Hud {
    x: v.height * 0.05 + v.lock.unit * 3.5; y: v.height * 0.05 + v.lock.unit * 0.3
    text: "VESSEL " + v.lock.hostName.toUpperCase() + "  ·  CREW " + v.lock.userName.toUpperCase()
  }
  Hud {
    anchors { right: parent.right; rightMargin: v.height * 0.05 + v.lock.unit * 3.5 }
    y: v.height * 0.05 + v.lock.unit * 0.3
    text: "T+ " + Qt.formatDateTime(v.lock.now, "yyyy.MM.dd")
  }
  Hud {
    x: v.height * 0.05 + v.lock.unit * 3.5
    anchors { bottom: parent.bottom; bottomMargin: v.height * 0.05 + v.lock.unit * 0.3 }
    opacity: 0.7
    text: "ORBIT STABLE  ·  LIFE SUPPORT NOMINAL  ·  HATCH SEALED"
  }

  Status {
    lock: v.lock
    font.letterSpacing: size * 0.3
    idleText: "AWAITING CLEARANCE"
    busyText: "VERIFYING CLEARANCE" + (v.lock.cursorOn ? " ▪" : "  ")
    deniedText: "CLEARANCE DENIED"
  }
}
