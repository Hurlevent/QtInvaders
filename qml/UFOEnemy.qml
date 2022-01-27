import QtQuick

Image {
    id: root

    property int row: -1
    property int hitPoints: 3

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
}
