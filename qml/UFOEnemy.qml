import QtQuick

Image {
    id: root

    property int row: -1
    property int hitPoints: 3

    property int laserCooldown: 120

    fillMode: Image.PreserveAspectFit
    source: "qrc:images/UFO.png"

    function hit(callbackOnDeath) {
        hitPoints--
        if (hitPoints <= 0){
            callbackOnDeath()
            // TODO: Play animation

            root.destroy()
        }
    }

    function tryShoot(){
        if (row !== 0)
            return false

        laserCooldown = Math.max(0, laserCooldown - 1)

        if (laserCooldown === 0) {
            laserCooldown = Math.max(60, Math.floor(Math.random() * 180))

            return true
        }

        return false
    }
}
