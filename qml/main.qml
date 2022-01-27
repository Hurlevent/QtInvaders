import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Qt Invaders")

    property int score: 0
    property variant playerProjectiles: []
    property variant enemies: []

    function spawn(compStr,xPos,yPos)
    {
        let component = Qt.createComponent(compStr);
        let object = component.createObject(gameboard, {x: xPos, y: yPos})

        if(object) {
            return object
        }
        else {
            console.warn("failed to spawn: " + compStr)
            return null
        }
    }

    Input {
        id: input
    }

    Timer {
        id: gameTimer
        interval: 16
        repeat: true
        running: true
        onTriggered: function(){
            // update player pos
            player.update(input, gameboard.size)

            let i = 0;
            while (i < playerProjectiles.length) {
                let proj = playerProjectiles[i]
                let newY = proj.y - proj.speed / 100 * gameboard.size.y
                if (newY < 0) {
                    playerProjectiles.splice(i, 1)
                    proj.destroy()
                } else {
                    proj.y = newY
                    i++
                }
            }
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
        source: "qrc:/images/stars.png"

        readonly property vector2d size: Qt.vector2d(gameboard.width, gameboard.height)

        Keys.onPressed: function (event) { input.handlePress(event) }
        Keys.onReleased: function (event) { input.handleRelease(event) }

        Player {
            id: player
            visible: true

            // TODO: fix this (which doesn't work, I shouldn't use Component.onComplete)
            Component.onCompleted: function(){
                let newX = ((gameboard.width - player.width) / 2)
                let newY = gameboard.height - player.height
                player.x = newX
                player.y = newY
                console.log("x: " + newX + " y: " + newY)
            }

            onShootLaser: function() {
                let obj = spawn("PlayerProjectile.qml", player.x + (player.width / 2), player.y - player.height)
                playerProjectiles.push(obj)
            }
        }
    }
}
