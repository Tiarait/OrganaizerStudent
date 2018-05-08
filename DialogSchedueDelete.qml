import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

// Диалог подтверждения удаления строки расписания из базы данных
Dialog {
    title: qsTr("Delete a line")
    Label {
        text: qsTr("Confirm <b>deletion</ b> \"" + modelSchedule.get (tableSchedule.currentRow) .schedultitle
                   + "\" from the schedule")
        Layout.columnSpan: 2
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
    }
    standardButtons: StandardButton.Ok | StandardButton.Cancel
    onAccepted: {
        database.removeRecord("schedule", modelSchedule.get(tableSchedule.currentRow).id)
        modelSchedule.updateModel(calendar.selectedDate.getDay());
    }
}
