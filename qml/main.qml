import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 1000
    height: 1000
    visible: true
    title: qsTr("Qt Invaders")

    readonly property int enemyPerRow: 5
    readonly property int numberOfEnemyRows: 3
    readonly property real enemyMargin: 0.2
    readonly property real enemySpacing: 0.01


    property bool gameStarted: false
    property int score: 0
    property variant playerProjectiles: []
    property variant enemies: []
    property real enemySpeed: 0.01

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

    function restartGame(){
        // clean up

        for(let i = 0; i < enemies.length; i++){
            let enemy = enemies[i]
            enemies.splice(i, 1)
            enemy.destroy()
        }

        // TODO

        // initialize
        player.x = (gameboard.width - player.width) / 2
        player.y = gameboard.height - player.height

        gameStarted = true

        let boardWithoutMargin = (1 - enemyMargin) * gameboard.width
        let totalSpacing = ((enemySpacing * boardWithoutMargin) * (enemyPerRow - 1))
        let enemyWidth = (boardWithoutMargin - totalSpacing) / enemyPerRow

        for (let row = 0; row < numberOfEnemyRows; row++) {
            for (let column = 0; column < enemyPerRow; column++){
                let posX = ((enemyMargin / 2) * gameboard.width) + column * (enemyWidth + (enemySpacing * gameboard.width / 2))
                let posY = ((enemyMargin / 2) * gameboard.height) + row * (enemyWidth + (enemySpacing * gameboard.height / 2))
                let enemyObj = spawn("UFOEnemy.qml", {x: posX, y: posY})
                enemyObj.width = enemyWidth
                enemyObj.height = enemyWidth
                enemyObj.row = row
                if (enemyObj !== null)
                    enemies.push(enemyObj)
                else
                    console.log("failed to create enemies")
            }
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
        running: gameStarted
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

                    let collision = false
                    let projRect = Qt.rect(proj.x, proj.y, proj.width, proj.height)
                    for (let enemyIt = 0; enemyIt < enemies.length; enemyIt++) {
                        let enemy = enemies[enemyIt]
                        if (intersecting(projRect, Qt.rect(enemy.x, enemy.y, enemy.width, enemy.height))) {
                            enemy.hit(function(){ enemies.splice(enemyIt, 1); sounds.playRandomExplosion() })
                            playerProjectiles.splice(i, 1)
                            proj.destroy()
                            collision = true
                        }
                    }
                    if (!collision) {
                        proj.y = newY
                        i++
                    }
                }
            }

            // update enemy movement

            var canMove = function(distance){
                let furthestNextPos = gameboard.width / 2
                for(let enemyIt = 0; enemyIt < enemies.length; enemyIt++){
                    let enemy = enemies[enemyIt]
                    let nextPos = enemy.x + distance
                    if (distance > 0){
                        furthestNextPos = Math.max(furthestNextPos, nextPos + enemy.width)
                    } else if (distance < 0){
                        furthestNextPos = Math.min(furthestNextPos, nextPos)
                    }
                }

                if (distance > 0){
                    return furthestNextPos < gameboard.width
                } else if (distance < 0){
                    return furthestNextPos >= gameboard.width
                }
                return true
            }

            let movementLength = enemySpeed * gameboard.width

            console.log("movementLen: " + movementLength)

            if (canMove(movementLength)) {
                for(let enemyIt = 0; enemyIt < enemies.length; enemyIt++){
                    let enemy = enemies[enemyIt]
                    //let movementLength = enemy.width + (enemySpacing * gameboard.width / 2)

                    enemy.x = enemy.x + movementLength
                }
            } else {
                enemySpeed = -enemySpeed
                //console.log("enemySpeed now: " + enemySpeed)
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
        focus: gameStarted
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/images/stars.png"

        readonly property vector2d size: Qt.vector2d(gameboard.width, gameboard.height)

        Keys.onPressed: function (event) { input.handlePress(event) }
        Keys.onReleased: function (event) { input.handleRelease(event) }

        Player {
            id: player
            visible: gameStarted

            onShootLaser: function() {
                let obj = spawn("PlayerProjectile.qml", {x: player.x + (player.width / 2), y: player.y})
                sounds.playRandomShoot()
                if (obj !== null)
                    playerProjectiles.push(obj)
            }
        }
    }

    Button {
        visible: !gameStarted
        text: qsTr("Start game")
        anchors.centerIn: gameboard
        focus: true

        onClicked: restartGame()
    }
}
