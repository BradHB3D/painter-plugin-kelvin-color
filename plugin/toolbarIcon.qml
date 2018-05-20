import AlgWidgets.Style 1.0
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Button {
    id: toolbarIcon

    property string icon_file: "img/toolbar_icon.png";
    property string icon_hover: "img/toolbar_icon_hover.png";

    antialiasing: true
    width: 32
    height: 32
    tooltip: "Brad's Kelvin Color Plugin is Loaded"

    style: ButtonStyle {
        background: Rectangle {
            implicitWidth: toolbarIcon.width
            implicitHeight: toolbarIcon.height
            color: toolbarIcon.hovered ?
                "#262626" : "transparent"
        }
    }

    Image {
        anchors.fill: parent
        anchors.margins: 7
        source: toolbarIcon.hovered && !toolbarIcon.loading ? icon_hover : icon_file
        fillMode: Image.PreserveAspectFit
        sourceSize.width: toolbarIcon.width
        sourceSize.height: toolbarIcon.height
        mipmap: true
        opacity: toolbarIcon.loading ? 0.5 : 1
    }
}