import QtQuick 2.2
import Painter 1.0

PainterPlugin {
    
    tickIntervalMS: -1 // -1 mean disabled (default value)
    jsonServerPort: -1 // -1 mean disabled (default value)

    Component.onCompleted: {

        var button_KelvinColor = alg.ui.addWidgetToPluginToolBar("plugin/toolbarIcon.qml"); // toolbar icon
        var dock_KelvinColor = alg.ui.addDockWidget("plugin/dock.qml") // dock widget
    }
}