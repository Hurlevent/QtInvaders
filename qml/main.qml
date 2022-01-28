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
    property int playerHitpoints: 3
    property variant playerProjectiles: []
    property variant enemyProjectiles: []
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

        for (let i = 0; i < enemies.length; i++){
            enemies[i].destroy()
        }
        enemies = []

        for (let i = 0; i < enemyProjectiles.length; i++){
            enemyProjectiles[i].destroy()
        }
        enemyProjectiles = []

        for (let i = 0; i < playerProjectiles.length; i++) {
            playerProjectiles[i].destroy()
        }
        playerProjectiles = []

        input.clearAll()

        score = 0
        playerHitpoints = 3

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
                enemyObj.row = numberOfEnemyRows - (row + 1)
                if (enemyObj !== null)
                    enemies.push(enemyObj)
                else
                    console.log("failed to create enemies")
            }
        }
        sounds.playLevelStartSound()
        musicTimer.interval = musicTimer.defaultInterval
        musicTimer.start()
    }

    function takePlayerDamage(){
        if (player.invincibilityCounter == 0) {
            playerHitpoints--;
            sounds.playRandomHit()
            player.invincibilityCounter = 60
            if(playerHitpoints <= 0) {
                musicTimer.stop()
                sounds.playRandomGameover()
                console.log("Game over!")
                gameStarted = !gameStarted
                menuTextThingy.focus = true
                menuTextThingy.text = qsTr("Game Over!")
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
        id: musicTimer
        readonly property int defaultInterval: 2250
        interval: defaultInterval
        repeat: true
        onTriggered: function(){
            interval = interval > 1000 ? 1000 : Math.max(interval - 20, 180)
            sounds.playMusicFurther()
        }
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
                    continue;
                }
                else {
                    // check collision with enemies

                    let collision = false
                    const projRect = Qt.rect(proj.x, proj.y, proj.width, proj.height)
                    for (let enemyIt = 0; enemyIt < enemies.length; enemyIt++) {
                        let enemy = enemies[enemyIt]
                        if (intersecting(projRect, Qt.rect(enemy.x, enemy.y, enemy.width, enemy.height))) {
                            enemy.hit(function(){ enemies.splice(enemyIt, 1); sounds.playRandomExplosion(); score += 25 })
                            playerProjectiles.splice(i, 1)
                            proj.destroy()
                            sounds.playRandomHit()
                            collision = true
                        }
                    }
                    if (!collision) {
                        proj.y = newY
                        i++
                    }
                }
            }

            // enemy projectile movement
            i = 0
            while (i < enemyProjectiles.length) {
                let proj = enemyProjectiles[i]

                const newY = proj.y + proj.speed / 100 * gameboard.size.y
                if (newY >= gameboard.height) {
                    enemyProjectiles.splice(i, 1)
                    proj.destroy()
                    continue
                } else {
                    let collision = false

                    const projRect = Qt.rect(proj.x, proj.y, proj.width, proj.height)
                    if (intersecting(projRect, playerRect)) {
                        takePlayerDamage()
                        enemyProjectiles.splice(i, 1)
                        proj.destroy()
                        collision = true
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
                    return furthestNextPos >= 0
                }
                return true
            }

            let movementLength = enemySpeed * gameboard.width

            if (canMove(movementLength)) {
                for(let enemyIt = 0; enemyIt < enemies.length; enemyIt++){
                    let enemy = enemies[enemyIt]
                    enemy.x = enemy.x + movementLength

                    // check if they collide with player

                    let playerRect = Qt.rect(player.x, player.y, player.width, player.height)
                    let enemyRect = Qt.rect(enemy.x, enemy.y, enemy.width, enemy.height)
                    if (intersecting(player, enemyRect)) {
                        takePlayerDamage()
                    }

                    // shoot?
                    if (enemy.tryShoot()){
                        let projObj = spawn("EnemyProjectile.qml", {x: enemy.x + (enemy.width / 2), y: enemy.y + enemy.height})
                        if (projObj !== null) {
                            sounds.playRandomShoot()
                            enemyProjectiles.push(projObj)
                        }
                    }
                }
            } else {
                // Move downwards
                enemySpeed = -enemySpeed
                for(let enemyIt = 0; enemyIt < enemies.length; enemyIt++){
                    let enemy = enemies[enemyIt]
                    enemy.y += Math.abs(movementLength)
                }
            }

            if (enemies.length == 0) {
                musicTimer.stop()
                sounds.playLevelEndSound()
                console.log("Victory!")
                gameStarted = !gameStarted
                menuTextThingy.focus = true
                menuTextThingy.text = qsTr("Victory!")
            }

            player.invincibilityCounter = Math.max(0, player.invincibilityCounter - 1)
        }
    }

    Rectangle {
        id: statusbar
        height: scoreText.height
        width: parent.width

        Text {
            anchors.left: statusbar.left
            id: scoreText
            text: qsTr("Score: " + score)
            font.pointSize: 32
        }

        Row {
            anchors.right: statusbar.right
            spacing: 30
            Repeater {
                model: Math.max(0, Math.min(playerHitpoints, 3))
                delegate: Image {
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:images/heart.svg"
                    height: statusbar.height
                }
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

    Column {
        anchors.centerIn: gameboard

        Label {
            id: menuTextThingy
            focus: true
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Welcome to Qt Invaders!")
            visible: !gameStarted
            color: "#FFFFFF"
            font.pointSize: 36
            Keys.onPressed: function(event) { if(event.key === Qt.Key_Return){ restartGame() }}
        }

        spacing: 32

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Press <Return> to start")
            visible: !gameStarted
            color: "#FFFFFF"
            font.pointSize: 36
        }
    }
}
