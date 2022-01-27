import QtQuick

Image {
    id: root
    width: 64
    height: 64
    fillMode: Image.PreserveAspectFit
    source: "qrc:images/player.png"

    property string objectType: "player"
    property real movementSpeed: 1
    property bool canShoot: true

    signal shootLaser()

    function update(input, board){
        let vec = input.pollVector()

        let newX = Math.max(0, Math.min(root.x + vec.x * (movementSpeed / 100 * board.x), board.x - root.width))
        let newY = Math.max(0, Math.min(root.y + vec.y * (movementSpeed / 100 * board.y), board.y - root.width))

        root.x = newX
        root.y = newY

        if (input.spacebarDown)
        {
            if (canShoot){
                shootLaser()
                canShoot = false
            }
        }
        else {
            canShoot = true
        }
    }
}
