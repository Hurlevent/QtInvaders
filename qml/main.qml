import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Window {
    width: 1000
    height: 1000
    visible: true
    title: qsTr("Qt Invaders")

    property int score: 0
    property variant playerProjectiles: []
    property variant enemies: []

    function intersecting(rect1, rect2) {
        return (rect1.x < rect2.x + rect2.width &&
            rect1.x + rect1.width > rect2.x &&
            rect1.y < rect2.y + rect2.height &&
            rect1.y + rect1.height > rect1.y)
    }

    function spawn(compStr, properties)
    {
        let component = Qt.createComponent(compStr);
        let object = component.createObject(gameboard, properties)

        if(object) {
            return object
        }
        else {
            console.warn("failed to spawn: " + compStr)
            return null
        }
    }

    SoundEffects {
        id: sounds
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

            let playerRect = Qt.rect(player.x, player.y, player.width, player.height)

            let i = 0;
            // PlayerProjectile logic
            while (i < playerProjectiles.length) {
                let proj = playerProjectiles[i]
                let newY = proj.y - proj.speed / 100 * gameboard.size.y
                if (newY < 0) {
                    playerProjectiles.splice(i, 1)
                    proj.destroy()
                }
                else {
                    // check collision with enemies

                    let projRect = Qt.rect(proj.x, proj.y, proj.width, proj.height)
                    for (let enemy in enemies) {
                        if (intersecting(projRect, Qt.rect(enemy.x, enemy.y, enemy.width, enemy.height))) {
                            playerProjectiles.splice(i, 1)
                            proj.destroy()
                            console.log("hit enemy: " + enemy)
                            enemy.destroy()
                        }
                    }

                    let collision = false

                    if (collision) {

                    } else {
                        proj.y = newY
                        i++
                    }
                }
            }

            // update enemy movement
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
                let obj = spawn("PlayerProjectile.qml", {x: player.x + (player.width / 2), y: player.y})
                sounds.playRandomShoot()
                if (obj !== null)
                    playerProjectiles.push(obj)
            }
        }
    }
}
