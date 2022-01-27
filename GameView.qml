import QtQuick
import QtQuick.Layouts

Rectangle {
    id: statusbar

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

}
