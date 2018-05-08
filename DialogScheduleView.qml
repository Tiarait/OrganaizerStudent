import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

// Диалог подробного описания строки рассписания
Dialog {
    title: modelSchedule.get(tableSchedule.currentRow).schedultitle + ""
    standardButtons: StandardButton.Ok

    ColumnLayout {
        width: parent ? parent.width : 100
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: qsTr("Start:")
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
            Label {
                Layout.alignment: Qt.AlignRight
                text: modelSchedule.get(tableSchedule.currentRow).schedulstart + ""
                wrapMode: Text.WordWrap
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: qsTr("End: ")
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
            Label {
                text: modelSchedule.get(tableSchedule.currentRow).schedulend + ""
                wrapMode: Text.WordWrap
            }
        }
        Label {
            text: modelSchedule.get(tableSchedule.currentRow).scheduldesc + ""
            Layout.fillWidth: true
            Layout.fillHeight: true
            y: 100
            wrapMode: Text.WordWrap
        }
    }
}
