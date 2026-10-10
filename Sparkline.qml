import QtQuick
import qs.Commons

// Minimal line graph.
Canvas {
  id: root

  property var values: []
  property real maxValue: 100
  property bool autoScale: false
  readonly property real effectiveMax: {
    if (!autoScale) return maxValue
    var m = maxValue
    for (var i = 0; i < values.length; i++) if (values[i] > m) m = values[i]
    return m
  }
  property color lineColor: Color.accent

  implicitHeight: 28

  onValuesChanged: requestPaint()
  onLineColorChanged: requestPaint()
  onWidthChanged: requestPaint()

  onPaint: {
    var ctx = getContext("2d")
    ctx.reset()
    var n = values.length
    if (n < 2 || width <= 0) return
    var step = width / Math.max(1, n - 1)
    ctx.lineWidth = 1.5
    ctx.strokeStyle = lineColor
    ctx.beginPath()
    for (var i = 0; i < n; i++) {
      var y = height - Math.max(0, Math.min(1, values[i] / effectiveMax)) * (height - 2) - 1
      if (i === 0) ctx.moveTo(0, y)
      else ctx.lineTo(i * step, y)
    }
    ctx.stroke()
  }
}
