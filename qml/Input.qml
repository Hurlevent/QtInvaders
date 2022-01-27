import QtQuick

QtObject {
    id: data
    property bool moveLeft: false
    property bool moveRight: false
    property bool moveForward: false
    property bool moveBackward: false
    property bool spacebarDown: false

    function handlePress(keyPressEvent)
    {
        switch(keyPressEvent.key) {
        case Qt.Key_Left:
            data.moveLeft = true
            data.moveRight = false
            break;
        case Qt.Key_Right:
            data.moveRight = true
            data.moveLeft = false
            break;
        case Qt.Key_Up:
            data.moveForward = true
            data.moveBackward = false
            break;
        case Qt.Key_Down:
            data.moveBackward = true
            data.moveForward = false
            break;
        case Qt.Key_Space:
            data.spacebarDown = true
        }
    }

    function handleRelease(keyReleaseEvent)
    {
        switch(keyReleaseEvent.key) {
        case Qt.Key_Left:
            data.moveLeft = false
            break;
        case Qt.Key_Right:
            data.moveRight = false
            break;
        case Qt.Key_Up:
            data.moveForward = false
            break;
        case Qt.Key_Down:
            data.moveBackward = false
            break;
        case Qt.Key_Space:
            data.spacebarDown = false
        }
    }

    function pollVector(){
        let x = 0
        let y = 0

        if (moveLeft){
            x -= 1
        }
        if (moveRight){
            x += 1
        }
        if (moveBackward){
            y += 1
        }
        if (moveForward){
            y -= 1
        }

        if (x === 0 && y === 0)
            return Qt.vector2d(0,0)

        let length = Math.sqrt(x*x + y*y)

        return Qt.vector2d(x / length, y / length)
    }

    function clearAll(){
        data.moveLeft = false
        data.moveRight = false
        data.moveForward = false
        data.moveBackward = false
        data.spacebarDown = false
    }
}
