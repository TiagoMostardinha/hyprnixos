import QtQuick
import "../theme"

// Round avatar with a thin light outline, cropped to fill. Drawn with Canvas
// (no shaders). Shows only the outline if the image is missing.
Item {
    id: root

    required property url source

    Image {
        id: probe

        visible: false
        source: root.source
        onStatusChanged: {
            if (status === Image.Ready)
                canvas.loadImage(root.source);
            canvas.requestPaint();
        }
    }

    Canvas {
        id: canvas

        anchors.fill: parent
        onWidthChanged: requestPaint()
        onImageLoaded: requestPaint()
        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            const w = width, h = height;
            if (probe.status === Image.Ready && isImageLoaded(root.source)) {
                ctx.save();
                ctx.beginPath();
                ctx.arc(w / 2, h / 2, w / 2, 0, 2 * Math.PI);
                ctx.clip();
                const s = Math.max(w / probe.implicitWidth, h / probe.implicitHeight);
                const dw = probe.implicitWidth * s, dh = probe.implicitHeight * s;
                ctx.drawImage(root.source, (w - dw) / 2, (h - dh) / 2, dw, dh);
                ctx.restore();
            }
            ctx.beginPath();
            ctx.arc(w / 2, h / 2, w / 2 - 0.5, 0, 2 * Math.PI);
            ctx.lineWidth = 1;
            ctx.strokeStyle = Theme.login.outline;
            ctx.stroke();
        }
    }
}
