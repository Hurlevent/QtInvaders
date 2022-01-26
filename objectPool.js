var gameObjects = []

function spawnObject(qml, parent, args, callback) {
    let component = Qt.createComponent(qml)
    if (!component) {
        console.warn("failed to create a QML component")
        return;
    }

    let object = component.createObject(parent)

    gameObjects.add(object)

    if(callback)
        callback(object)
}
