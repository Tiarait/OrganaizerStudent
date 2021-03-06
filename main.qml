import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 640
    height: 400
    minimumWidth: 640
    minimumHeight: 400
    color: "#f4f4f4"
    property alias row: row
    title: qsTr("OrganizeStudent " + Qt.formatDateTime(new Date(), "dd-MM-yyyy"))


    Flow {
        id: row
        anchors.fill: parent
        clip: false
        anchors.margins: 20
        spacing: 10
        layoutDirection: Qt.LeftToRight

        // Слой с Календарем
        Calendar {
            id: calendar
            // Язык в календаре
            locale: Qt.locale("en_US")
            width: (parent.width / 2) - 10
            height: (parent.height / 2) - 10
            frameVisible: true
            weekNumbersVisible: true
            focus: true
            style: calendarstyle
        }

        // Стиль Item'ов в календаре
        Component {
            id: calendarStyleItem
            Item {
                property string curDate: Qt.formatDateTime(new Date(), "yyyyMMdd")
                Rectangle {
                    anchors.fill: parent
                    color: if(styleData.date !== undefined && styleData.selected){
                               modelSchedule.updateModel(calendar.selectedDate.getDay())
                               modelTask.updateModel(Qt.formatDate(calendar.selectedDate, "yyyyMMdd"))
                               'blue'
                           }else if(styleData.date !== undefined &&
                                    Qt.formatDate(styleData.date, "yyyyMMdd") == curDate) "lightsteelblue"
                           else "transparent"
                    anchors.margins: styleData.selected ? -1 : 0
                    Image {
                        visible: (database.searchTask(Qt.formatDate(styleData.date, "yyyyMMdd")) &&
                                         Qt.formatDate(styleData.date, "yyyyMMdd") >= curDate)
                        anchors.margins: -1
                        width: 12
                        height: width
                        source: "qrc:/images/eventindicator.png"
                    }
                }

                Label {
                    text: styleData.date.getDate()
                    anchors.centerIn: parent
                    color: {
                        var color = '#dddddd';
                        if (styleData.valid) {
                            color = styleData.visibleMonth ? '#444' : '#bbb';
                            if (styleData.selected) color = 'white';
                        }
                        color;
                    }
                }
            }
        }
        // Стандартный стиль календаря
        Component {
            id: calendarstyle
            CalendarStyle {
                dayDelegate: calendarStyleItem
            }
        }
        // Новый стиль календаря (нужно для обновления крайних сроков)
        Component {
            id: newCalendarStyle
            CalendarStyle {
                dayDelegate: calendarStyleItem
            }
        }


        // Слой с Расписание
        Rectangle {
            width: (parent.width / 2) - 10
            height: (parent.height / 2) - 10
            border.color: Qt.darker(color, 1.2)
            Text {
                id: scheduleLabel
                width: parent.width - scheduleButton.width - 20
                y: 5
                color: "#535151"
                font.pixelSize: 15
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Schedule")
            }
            Button {
                id: scheduleButton
                width: 20
                height: width
                anchors.top: parent.top
                anchors.topMargin: (scheduleLabel.height / 2) - 5
                anchors.right: parent.right
                anchors.rightMargin: 10
                style: ButtonStyle {
                        background: Rectangle {
                            border.width: control.activeFocus ? 2 : 1
                            border.color: control.pressed ? "blue" : "transparent"
                            color: "lightsteelblue"
                        }
                        label: Text {
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                                font.pointSize: 10
                                color: "white"
                                text: "+"
                        }
                }
                // Вызываем диалог для записи в базу данных
                onClicked: {
                    dialogAddShcedule.defval()
                    dialogAddShcedule.open()
                }
            }
            TableView {
                id: tableSchedule
                horizontalScrollBarPolicy: 1
                anchors.topMargin: scheduleLabel.height + 10
                anchors.fill: parent
                model: modelSchedule
                onWidthChanged:scheduleTitle.width = Math.max(100, tableView.width - scheduleStart.width + 10)

                TableViewColumn {
                    id: scheduleStart
                    role: "schedulstart"
                    title: qsTr("Strt")
                    width: 60
                }
                TableViewColumn {
                    id: scheduleEND
                    role: "schedulend"
                    title: qsTr("End")
                    width: 50
                }
                TableViewColumn {
                    id: scheduleTitle
                    role: "schedultitle"
                    title: qsTr("Title")
                }
                // Настройка строки в TableView для перехавата левого клика мыши
                rowDelegate: Rectangle {
                    height: 20
                    color: styleData.selected ? 'lightsteelblue' : 'white';
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton | Qt.LeftButton
                        onClicked: {
                            tableSchedule.selection.clear()
                            tableSchedule.selection.select(styleData.row)
                            tableSchedule.currentRow = styleData.row ? styleData.row : 0
                            tableSchedule.focus = true

                            switch(mouse.button) {
                            case Qt.RightButton:
                                contextSheduleMenu.popup()
                                break
                            default:
                                break
                            }
                        }
                        onDoubleClicked: {
                            dialogScheduleView.open()
                        }
                    }
                }
            }
        }

        // Слой с Задачами
        Rectangle {
            id: rectangle
            width: parent.width - 10
            height: parent.height / 2
            border.color: Qt.darker(color, 1.2)

            Text {
                id: taskLabel
                width: parent.width - taskButton.width - 20
                height: eventDay.height
                anchors.margins: 4
                color: "#535151"
                font.pixelSize: 15
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Task")
            }
            // Вызываем диалог для записи в базу данных
            Button {
                id: taskButton
                width: eventDay.height
                height: width
                anchors.top: parent.top
                anchors.right: parent.right
                style: ButtonStyle {
                        background: Rectangle {
                            border.width: control.activeFocus ? 2 : 1
                            border.color: control.pressed ? "blue" : "transparent"
                            color: "lightsteelblue"
                        }
                        label: Text {
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.bold: true
                                font.pointSize: 40
                                color: "white"
                                text: "+"
                        }
                }
                onClicked: {
                    dialogAddTask.defval()
                    dialogAddTask.open()
                }
            }
            // Слой с выводом выбраной датой
            Rectangle {
                id: rectangle1
                width: calendar.width + 5
                height: eventDay.height
                color: "lightsteelblue"
                Row {
                    id: eventDate
                    anchors.left: parent.left
                    anchors.leftMargin: calendar.width / 3 - 50
                    anchors.right: parent.right
                    anchors.rightMargin: calendar.width / 3
                    spacing: 10

                    Label {
                        id: eventDay
                        text: calendar.selectedDate.getDate()
                        font.pointSize: 35
                    }

                    Column {
                        height: eventDay.height

                        Label {
                            readonly property var options: { weekday: "long" }
                            text: Qt.locale("en_US").standaloneDayName(calendar.selectedDate.getDay(), Locale.LongFormat)
                            font.pointSize: 18
                        }
                        Label {
                            text: Qt.locale("en_US").standaloneMonthName(calendar.selectedDate.getMonth())
                                  + calendar.selectedDate.toLocaleDateString(Qt.locale("en_US"), " yyyy")
                            font.pointSize: 12
                        }
                    }
                }
            }

            TableView {
                id: tableView
                horizontalScrollBarPolicy: 1
                anchors.topMargin: eventDay.height + 4
                anchors.fill: parent
                model: modelTask
                onWidthChanged:tasktitle.width = Math.max(100, tableView.width - endTime.width -
                                                          taskstatus.width - endDate.width + 20)

                TableViewColumn {
                    id: endDate
                    role: "enddate"
                    title: qsTr("Extreme term")
                    width: 90
                    delegate: Text {
                        x: 10
                        y: 3
                        text: database.decodeDate(styleData.value)
                        color: styleData.selected ? 'white' : 'black'
                    }
                }
                TableViewColumn {
                    id: endTime
                    role: "endtime"
                    title: qsTr("Time")
                    width: 50
                }
                TableViewColumn {
                    id: tasktitle
                    role: "tasktitle"
                    title: qsTr("Brief description")
                }
                TableViewColumn {
                    id: taskstatus
                    role: "taskstatus"
                    title: qsTr("Status")
                }


                // Настройка строки в TableView для перехавата левого клика мыши
                rowDelegate: Rectangle {
                    height: 20
                    color: styleData.selected ? 'lightsteelblue' : 'white';
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton | Qt.LeftButton
                        onClicked: {
                            tableView.selection.clear()
                            tableView.selection.select(styleData.row)
                            tableView.currentRow = styleData.row ? styleData.row : 0
                            tableView.focus = true
                            switch(mouse.button) {
                            case Qt.RightButton:
                                contextTaskMenu.popup() // Вызываем контексткное меню
                                break
                            default:
                                break
                            }
                        }
                        onDoubleClicked: {
                            dialogTaskView.defval()
                            dialogTaskView.open()
                        }
                    }
                }
            }
        }
        // Контекстно меню предлагает удаление строки из базы данных
        Menu {
            id: contextTaskMenu
            MenuItem {
                text: qsTr("Detail")
                onTriggered: {
                    /* Вызываем диалоговое окно,
                     * которое покажедетальную информацию о задании
                     * */
                    dialogTaskView.defval()
                    dialogTaskView.open()
                }
            }
            MenuItem {
                text: qsTr("Remove")
                onTriggered: {
                    dialogTaskDelete.open()
                }
            }
        }
        Menu {
            id: contextSheduleMenu
            MenuItem {
                text: qsTr("Remove")
                onTriggered: {
                    dialogSchedueDelete.open()
                }
            }
        }
        /*
           Определяем диалоговые окна
        */
        DialogTaskDelete {
            id: dialogTaskDelete
        }
        DialogSchedueDelete {
            id: dialogSchedueDelete
        }
        DialogTaskView {
            id: dialogTaskView
        }
        DialogScheduleView {
            id: dialogScheduleView
        }
        DialogTaskAdd {
            id: dialogAddTask
        }
        DialogShceduleAdd {
            id: dialogAddShcedule
        }
    }
}
