import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

// Диалог добавления задач
Dialog {
    height: 300
    title: qsTr("Add task")

    standardButtons: StandardButton.Ok | StandardButton.Cancel | StandardButton.Reset

    function defval() {
        titleTask.text = ""
        descriptionTask.text = ""
        timeTask.text = "00:00"
        //dateTask.text = Qt.formatDate("2000-01-01 01:01:01.000000001 +1000", "dd-MM-yyyy")
        dateTask.text = Qt.formatDate(calendar.selectedDate, "dd-MM-yyyy")
    }
    onAccepted: {
        database.inserIntoTable("task", Qt.formatDateTime(new Date(), "dd-MM-yyyy"),
                                timeTask.text, dateTask.text, titleTask.text, descriptionTask.text, qsTr("In process"))
        modelTask.updateModel(Qt.formatDate(calendar.selectedDate, "yyyyMMdd"))
        if(calendar.style === newCalendarStyle) calendar.style = calendarstyle
        else calendar.style = newCalendarStyle
    }
    onReset: {
        defval()
    }

    ColumnLayout {
        id: column
        width: parent ? parent.width : 100
        TextField {
            Layout.fillWidth: true
            id: titleTask
            property string placeholderText: qsTr("Brief description")
            font.pixelSize: 12
            Text {
                x: 5
                y : 5
                text: titleTask.placeholderText
                color: "#aaa"
                visible: !titleTask.text
            }
        }
        Label {
            text: qsTr("Time and date of the deadline.")
            Layout.columnSpan: 2
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            TextField{
                id:timeTask
                text : "00:00"
                inputMask: "99:99"
                inputMethodHints: Qt.ImhDigitsOnly
                validator: RegExpValidator { regExp: /^([0-1]?[0-9]|2[0-3]):([0-5][0-9])$ / }
                Layout.fillWidth: true
            }
            TextField{
                id:dateTask
                text: Qt.formatDate(calendar.selectedDate, "yyyyMMdd")
                inputMask: "99-99-9999"
                inputMethodHints: Qt.ImhDigitsOnly
                validator: RegExpValidator { regExp: /^([0-2]?[0-9]|3[0-1])-(0?[0-9]|1[0-2])-([2-9][0-9][0-9][0-9])$ / }
                Layout.fillWidth: true
            }
        }
        TextArea {
            id: descriptionTask
            Layout.fillWidth: true
            Layout.fillHeight: true
            wrapMode: Text.WrapAnywhere
            property string placeholderText: qsTr("Description")
            font.pixelSize: 12
            Text {
                y: 10
                x: 10
                text: descriptionTask.placeholderText
                color: "#aaa"
                visible: !descriptionTask.text
            }
        }
    }
}
