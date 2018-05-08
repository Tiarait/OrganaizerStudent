import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

// Диалог подробного описания задания
Dialog {
    title: modelTask.get(tableView.currentRow).tasktitle + ""
    standardButtons: StandardButton.Ok
    function defval() {
        doneTask.checked = modelTask.get(tableView.currentRow).taskstatus === "Done" ? true : false
    }
    onAccepted: {
        database.updateTask(modelTask.get(tableView.currentRow).id, doneTask.checked ? "Done" : "In process")
        modelTask.updateModel(Qt.formatDate(calendar.selectedDate, "yyyyMMdd"))
        if(calendar.style === newCalendarStyle) calendar.style = calendarstyle
        else calendar.style = newCalendarStyle
    }
    ColumnLayout {
        width: parent ? parent.width : 100

        CheckBox {
            id: doneTask
            Layout.fillWidth: true
            text: qsTr("Done")
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: qsTr("Start:")
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
            Label {
                Layout.alignment: Qt.AlignRight
                text: database.decodeDate(modelTask.get(tableView.currentRow).startdate)
                wrapMode: Text.WordWrap
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: qsTr("Deadline: ")
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
            Label {
                text: "<b>"+modelTask.get(tableView.currentRow).endtime+"</b> "
                wrapMode: Text.WordWrap
            }
            Label {
                text: " <b>"+database.decodeDate(modelTask.get(tableView.currentRow).enddate)+"</b>"
                wrapMode: Text.WordWrap
            }
        }
        Label {
            text: modelTask.get(tableView.currentRow).taskdesc + ""
            Layout.fillWidth: true
            Layout.fillHeight: true
            y: 100
            wrapMode: Text.WordWrap
        }
    }
}
