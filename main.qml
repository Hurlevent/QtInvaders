import QtQuick
import QtQuick.Window
import QtInvaders

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Qt Invaders")

    GameBoard {
        anchors.fill: parent

    }
}
