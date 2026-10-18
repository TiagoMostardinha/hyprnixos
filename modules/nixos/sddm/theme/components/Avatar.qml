import QtQuick

// Round avatar with a thin light outline. Drawn with Canvas (no shaders), so it
// also works if the greeter ever falls back to software rendering.
Item {
    id: root

    property url source
    property url fallback

    // What is actually drawn: `source`, or `fallback` if that fails to load.
    property url shown: source
    onSourceChanged: shown = source

    // Probe image: gives the natural size and tells us if the file is usable.
    Image {
        id: probe
        visible: false
        source: root.shown
        onStatusChanged: {
            if (status === Image.Error && root.shown !== root.fallback)
                root.shown = root.fallback
            else if (status === Image.Ready)
                canvas.loadImage(root.shown)
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        onWidthChanged: requestPaint()
        onImageLoaded: requestPaint()
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            var w = width, h = height
            if (probe.status === Image.Ready && isImageLoaded(root.shown)) {
                ctx.save()
                ctx.beginPath()
                ctx.arc(w / 2, h / 2, w / 2, 0, 2 * Math.PI)
                ctx.clip()
                // Crop-to-fill: the source photo is not square.
                var s = Math.max(w / probe.implicitWidth, h / probe.implicitHeight)
                var dw = probe.implicitWidth * s, dh = probe.implicitHeight * s
                ctx.drawImage(root.shown, (w - dw) / 2, (h - dh) / 2, dw, dh)
                ctx.restore()
            }
            ctx.beginPath()
            ctx.arc(w / 2, h / 2, w / 2 - 0.5, 0, 2 * Math.PI)
            ctx.lineWidth = 1
            ctx.strokeStyle = "rgba(255, 255, 255, 0.2)"
            ctx.stroke()
        }
    }
}
