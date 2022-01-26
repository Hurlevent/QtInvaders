import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtInvaders

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Qt Invaders")

    property real lastCurrentTime: 0
    property int currentViewIdx: 0;
    property variant views: [gameView]

    Timer {
        id: gameTimer
        onTriggered: function(){
            let currentTime = new Date().getTime()
            let delta = currentTime - lastCurrentTime

            views[currentViewIdx].tick(delta)
        }
        Component.onCompleted: function () {
            lastCurrentTime = new Date().getTime()
        }
    }

    Rectangle {
        anchors.fill: parent

        GameView {
            id: gameView
            anchors.fill: parent
            visible: true
        }
    }
}
