import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

// Диалог подтверждения удаления строки задачи из базы данных
Dialog {
    title: qsTr("Delete a line")
    Label {
        text: qsTr("Confirm <b>delete</ b> \"" + modelTask.get (tableView.currentRow) .tasktitle
                   + "\" from tasks")
        Layout.columnSpan: 2
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
    }
    standardButtons: StandardButton.Ok | StandardButton.Cancel
    // При положительном ответе ...
    onAccepted: {
        database.removeRecord("task", modelTask.get(tableView.currentRow).id) // Удаляем строку
        modelTask.updateModel(Qt.formatDate(calendar.selectedDate, "yyyyMMdd"));  // Обновляем модель данных
        if(calendar.style === newCalendarStyle) calendar.style = calendarstyle
        else calendar.style = newCalendarStyle                                  //Обновляем календарь
    }
}
