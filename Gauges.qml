import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4

Item {
    Rectangle {
        id: rectangle
        color : "#000000"
        CircularGauge {
            id: speed_gauge
            anchors.top: parent.top
            anchors.topMargin: 63
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -335
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: -280
            clip: false
            stepSize: 0
            maximumValue: 160

        }
        CircularGauge {
            id: oil_gauge
            anchors.right: parent.right
            anchors.rightMargin: -633
            anchors.left: parent.left
            anchors.leftMargin: 361
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -335
            anchors.top: parent.top
            anchors.topMargin: 63
            maximumValue: 150
            clip: false

        }

        StatusIndicator {
            id: statusIndicator
            x: 480
            y: 289
            active: true
        }
    }


}
