import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import AlgWidgets 1.0
import AlgWidgets.Style 1.0

import "js/kelvin_to_RGB.js"
as KelvinRGB
import "js/kelvin_util.js"
as Util

Item {
    id: mainView
    objectName: "Kelvin Color"

    ListModel {
        id: kelvinPresets
        ListElement { key: "Slider"; value: 2700 }
        ListElement { key: "Bulb: Soft white"; value: 2700 }
        ListElement { key: "Bulb: Bright White"; value: 3000 }
        ListElement { key: "Bulb: Cool White"; value: 5000 }
        ListElement { key: "Bulb: Flash"; value: 5500 }
        ListElement { key: "Bulb: Daylight / Neutral"; value: 6500 }
        ListElement { key: "Natural: Match Flame"; value: 1700 }
        ListElement { key: "Natural: Candle"; value: 1850 }
        ListElement { key: "Natural: Sunrise, Sunset"; value: 2000 }
        ListElement { key: "Natural: Moonlight"; value: 4100 }
        ListElement { key: "Natural: Horizon Daylight"; value: 5000 }
        ListElement { key: "Natural: Avg Noon Sunlight"; value: 5300 }
        ListElement { key: "Natural: Overcast Daylight"; value: 6500 }
        ListElement { key: "Natural: Open Shade"; value: 7500 }
        ListElement { key: "Natural: Dark Shade"; value: 9000 }
        ListElement { key: "Natural: Clear Sky Min"; value: 12000 }
        ListElement { key: "Natural: Clear Sky Max"; value: 27000 }
    }

    QtObject {
        id: internal
        property int defaultTemp: kelvinPresets.get(0).value
        property var kelvinColor: Qt.rgba(0,0,0,1)
        property string rgbColor_Hex: ""
    }

    Rectangle {
        id: background
        anchors.fill: parent
        anchors.margins: 3
        color: '#323232'

    } // EO Background

    AlgScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.margins: 8

        ColumnLayout {
            id: mainLayout
            Layout.minimumWidth: scrollView.viewportWidth
            Layout.maximumWidth: scrollView.viewportWidth
            spacing: 8

            GridLayout {
                id: gridControls
                anchors.fill: parent
                rows: 2
                columns: 3

                property int toggleMaxWidth: 40 // Toggle button maximum size

                Rectangle {
                    id: swatch_KelvinColor
                    Layout.rowSpan: 2
                    Layout.fillHeight: true
                    Layout.preferredWidth: swatch_KelvinColor.height

                    color: internal.kelvinColor
                }

                AlgToggleButton {
                    id: toggle_Limit
                    text: "Limit"
                    toggled: true
                    Layout.maximumWidth: gridControls.toggleMaxWidth
                    onClicked: ui_set_kelvin_limit()
                }

                AlgSlider {
                    id: slider_Kelvin
                    Layout.fillWidth: true
                    text: "Temperature (K)"
                    minValue: 1000
                    maxValue: 15000
                    precision: 0
                    stepSize: 1
                    value: internal.defaultTemp
                    onValueChanged: ui_slider_change()
                }

                AlgToggleButton {
                    id: toggle_sRGB
                    text: "sRGB"
                    toggled: true
                    Layout.maximumWidth: gridControls.toggleMaxWidth
                    onClicked: update_internals()
                }

                AlgComboBox {
                    id: comboBox_Presets
                    Layout.fillWidth: true
                    model: kelvinPresets
                    textRole: "key"
                    onCurrentIndexChanged: ui_apply_preset()
                }
            } // EO Grid Controls
        } // EO Column MainLayout

        AlgGroupWidget {
            id: infoGroup
            text: "Color Info"

            GridLayout {
                id: infoGrid
                columns: 7
                rowSpacing: 2
                columnSpacing: 8

                AlgLabel {
                    text: "Hex:"
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignLeft
                }

                AlgLabel {
                    text: "R:"
                    horizontalAlignment: Text.AlignRight
                }
                AlgTextEdit {
                    Layout.fillWidth: true
                    text: Util.to_255(internal.kelvinColor.r)
                }

                AlgLabel {
                    text: "G:"
                    horizontalAlignment: Text.AlignRight
                }
                AlgTextEdit {
                    Layout.fillWidth: true
                    text: Util.to_255(internal.kelvinColor.g)
                }

                AlgLabel {
                    text: "B:"
                    horizontalAlignment: Text.AlignRight
                }
                AlgTextEdit {
                    Layout.fillWidth: true
                    text: Util.to_255(internal.kelvinColor.b)
                }

                AlgTextEdit {
                    Layout.preferredWidth: infoGrid.width / 5
                    text: internal.rgbColor_Hex
                    readOnly: true
                }

                AlgLabel {
                    text: "R:"
                    horizontalAlignment: Text.AlignRight
                }
                AlgTextEdit {
                    Layout.fillWidth: true
                    text: internal.kelvinColor.r.toFixed(3)
                }

                AlgLabel {
                    text: "G:"
                    horizontalAlignment: Text.AlignRight
                }
                AlgTextEdit {
                    Layout.fillWidth: true
                    text: internal.kelvinColor.g.toFixed(3)
                }

                AlgLabel {
                    text: "B:"
                    horizontalAlignment: Text.AlignRight
                }
                AlgTextEdit {
                    Layout.fillWidth: true
                    text: internal.kelvinColor.b.toFixed(3)
                }
            }
        } // EO Info Group Widget
    } // EO Scroll

    function ui_set_kelvin_limit() {
        if (toggle_Limit.toggled === true) {
            slider_Kelvin.maxValue = 15000;
        } else {
            slider_Kelvin.maxValue = 40000;
        }
    }

    function ui_slider_change() {
        if (slider_Kelvin.isEdited === true) {
            // change combobox and set model data
            comboBox_Presets.currentIndex = 0;
            kelvinPresets.setProperty(0, "value", Math.floor(slider_Kelvin.value));
        }
        update_internals();
    }

    function ui_apply_preset() {
        var selection = comboBox_Presets.currentIndex;
        var value = kelvinPresets.get(selection).value;
        slider_Kelvin.value = value; // set slider
    }

    function __set_color(rgb) {
        return Qt.rgba(rgb[0], rgb[1], rgb[2], 1);
    }

    function update_internals() {
        var converted = KelvinRGB.kelvin_to_RGB(Math.floor(slider_Kelvin.value)); // kelvin to srgb 255

        internal.kelvinColor = __set_color(Util.normalizeColor(converted)); // normalized color in srgb

        if (toggle_sRGB.toggled === false) {
            internal.kelvinColor = AlgHelpers.color.sRGBColorToLinear(internal.kelvinColor);
        };

        internal.rgbColor_Hex = Util.rgbToHex(Util.to_rgb255([internal.kelvinColor.r, internal.kelvinColor.g, internal.kelvinColor.b]));
    }
} // EO Main View