import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

// Диалог добавления рассписания
Dialog {
     height: 300
     title: qsTr("Add to schedule")
     standardButtons: StandardButton.Apply | StandardButton.Cancel

     function defval() {
         titleShcedule.text = ""
         descriptionShcedule.text = ""
         startShcedule.text = "00:00"
         endShcedule.text = "00:00"
     }
     onApply: {
         if(startShcedule.text < endShcedule.text) {
             database.inserIntoTable("shcedule", startShcedule.text, endShcedule.text, calendar.selectedDate.getDay(),
                                     titleShcedule.text, descriptionShcedule.text, "")
             modelSchedule.updateModel(calendar.selectedDate.getDay())
             dialogAddShcedule.close()
         } else {
             endShcedule.textColor = 'red'
         }
     }

     ColumnLayout {
         width: parent ? parent.width : 100
         TextField {
             Layout.fillWidth: true
             id: titleShcedule
             property string placeholderText: qsTr("Name of the subject")
             font.pixelSize: 12
             Text {
                 x: 5
                 y : 5
                 text: titleShcedule.placeholderText
                 color: "#aaa"
                 visible: !titleShcedule.text
             }
         }
         RowLayout {
             Layout.alignment: Qt.AlignHCenter
             Label {
                 text: qsTr("Start : ")
                 Layout.fillWidth: true
             }
             TextField{
                 id: startShcedule
                 text : "00:00"
                 inputMask: "99:99"
                 inputMethodHints: Qt.ImhDigitsOnly
                 validator: RegExpValidator { regExp: /^([0-1]?[0-9]|2[0-3]):([0-5][0-9])$ / }
                 Layout.fillWidth: true
             }
         }
         RowLayout {
             Layout.alignment: Qt.AlignHCenter
             Label {
                 text: qsTr("End : ")
                 Layout.fillWidth: true
             }
             TextField{
                 id: endShcedule
                 text : "00:00"
                 inputMask: "99:99"
                 inputMethodHints: Qt.ImhDigitsOnly
                 validator: RegExpValidator { regExp: /^([0-1]?[0-9]|2[0-3]):([0-5][0-9])$ / }
                 Layout.fillWidth: true
             }
         }
         TextArea {
             id: descriptionShcedule
             Layout.fillWidth: true
             Layout.fillHeight: true
             wrapMode: Text.WrapAnywhere
             property string placeholderText: qsTr("Additional field")
             font.pixelSize: 12
             Text {
                 y: 10
                 x: 10
                 text: descriptionShcedule.placeholderText
                 color: "#aaa"
                 visible: !descriptionShcedule.text
             }
         }
     }
}
