import QtQuick

Image {
    id: root
    width: 64
    height: 64
    fillMode: Image.PreserveAspectFit
    source: "qrc:Spaceship_01_BLUE.png"

    property real movementSpeed: 20

    function update(input, board){
        let vec = input.pollVector()

        let newX = Math.max(0, Math.min(root.x + vec.x * movementSpeed, board.width - root.width))
        let newY = Math.max(0, Math.min(root.y + vec.y * movementSpeed, board.height - root.width))

        root.x = newX
        root.y = newY
    }
}
