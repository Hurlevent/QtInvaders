import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Qt Invaders")

    property int score: 0

    Input {
        id: input
    }

    Timer {
        id: gameTimer
        interval: 16
        repeat: true
        running: true
        onTriggered: function(){
            player.update(input, gameboard.size)
        }
    }

    Rectangle {
        id: statusbar
        height: 32
        width: parent.width
        Row {
            Text {
                text: qsTr("Score: " + score)
            }
        }
    }

    Image {
        id: gameboard
        anchors {
            top: statusbar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        focus: true
        fillMode: Image.PreserveAspectCrop
        source: "qrc:nebula/stars.png"

        readonly property vector2d size: Qt.vector2d(gameboard.width, gameboard.height)

        Keys.onPressed: function (event) { input.handlePress(event) }
        Keys.onReleased: function (event) { input.handleRelease(event) }

        Player {
            id: player
            visible: true
        }
    }
}
