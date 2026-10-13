import QtQuick
import "."

Item {
    id: root
    required property int index
    required property ConfigAdapter configs
    required property ColorsAdapter colors
    required property string fileName
    required property string filePath
    required property string cashePath
    required property int selectedIndex

    property bool active: index === selectedIndex

    signal clicked(index: int)

    Behavior on width {
        NumberAnimation {
            duration: 50
            easing.type: Easing.OutCubic
        }
    }

    Text {
        id: alt
        text: "Loading..."
        color: root.colors.border_color
        anchors.verticalCenter: parent.verticalCenter
        leftPadding: parent.height * (-1 * root.configs.x_factor) / (root.configs.x_factor < 0 ? 2 : 1)
        font.pixelSize: 16
        font.bold: true
        transform: Shear {
            xFactor: root.configs.x_factor
        }
    }

    Image {
        id: img
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        verticalAlignment: Image.AlignTop

        asynchronous: true
        cache: false
        smooth: true

        source: "file://" + root.cashePath

        sourceSize.width: width
        sourceSize.height: height

        transform: Shear {
            xFactor: root.configs.x_factor
        }

        Timer {
            id: retryTimer
            interval: 1000
            repeat: false
            onTriggered: {
                let s = img.source;
                img.source = "";
                img.source = s;
            }
        }

        onStatusChanged: {
            if (status === Image.Error) {
                alt.text = "Caching...";
                retryTimer.start();
            }
        }
    }

    Rectangle {
        id: border
        z: 10
        visible: parent.active

        anchors.fill: this.parent

        color: "transparent"

        border.width: 3
        border.color: root.colors.border_color

        transform: Shear {
            xFactor: root.configs.x_factor
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clicked(root.index);
        }
    }
}
