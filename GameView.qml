import QtQuick
import QtQuick.Layouts

import QtInvaders
import QtInvaders.Input

Rectangle {
    id: statusbar

    function tick(delta) {
        let newPlayerPosition = player.position + Input.pollVector() * player.movementSpeed * delta
        console.log(newPlayerPosition)
        console.log(player.width)
        console.log(player.height)
        console.log(player.implicitWidth)
        console.log(player.implicitHeight)
    }

    width: parent.width
    height: parent.height * 0.1
    RowLayout {
        id: statusLayout

//        Text {
//            text: qsTr("Score: " + game.score)
//        }


//        Row {
//            id: hitpointIndicator
//            //Layout.fillWidth: true
//            Repeater {
//                model: Math.min(game.hitPoints, 3)
//                delegate: Image {
//                    fillMode: Image.PreserveAspectFit
//                    source: "qrc:heart.svg"
//                    width: statusbar.width / hitpointIndicator
//                }
//            }
//        }

//        Row {
//            id: bombsIndicator
//            //Layout.fillWidth: true
//            Repeater {
//                model: Math.min(game.hitPoints, 4)
//                delegate: Image {
//                    fillMode: Image.PreserveAspectFit
//                    source: "qrc:Missile.svg"
//                    //width: statusbar.
//                }
//            }
//        }
    }

    Player {
        id: player
    }
}
