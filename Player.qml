import QtQuick

Image {
    id: root
    width: 64
    height: 64
    fillMode: Image.PreserveAspectFit
    source: "qrc:Spaceship_01_BLUE.png"

    property real movementSpeed: 20

    function update(input, area){
        let vec = input.pollVector()

        let newX = Math.max(0, Math.min(root.x + vec.x * movementSpeed, area.x))
        let newY = Math.max(0, Math.min(root.y + vec.y * movementSpeed, area.y))

        console.log("newX: " + newX + " newY: " + newY)

        root.x = newX
        root.y = newY
    }
}
