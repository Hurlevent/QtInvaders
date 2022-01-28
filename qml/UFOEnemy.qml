import QtQuick

Item {
    id: root

    property int row: -1
    property int hitPoints: 3
    property int laserCooldown: 120

    Image {
        id: sprite
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "qrc:images/UFO.png"
    }

    function hit(callbackOnDeath) {
        root.hitPoints--
        if (root.hitPoints <= 0){
            callbackOnDeath()
            deathAnimation.start()
            sprite.visible = false
        }
    }

    function tryShoot(){
        if (root.row !== 0)
            return false

        root.laserCooldown = Math.max(0, root.laserCooldown - 1)

        if (root.laserCooldown === 0) {
            root.laserCooldown = Math.max(60, Math.floor(Math.random() * 180))

            return true
        }

        return false
    }

    AnimatedSprite {
        id: deathAnimation
        source: "qrc:/images/explosions.png"
        anchors.centerIn: parent
        frameWidth: 64
        frameHeight: 64
        frameCount: 16
        frameDuration: 50
        finishBehavior: AnimatedSprite.FinishAtFinalFrame
        running: false
        loops: 1
        visible: running
        onFinished: function () { deathAnimation.stop(); root.destroy() }
    }
}
