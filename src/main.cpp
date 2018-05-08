#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>

#include "sqldb.h"
#include "tasklistmodel.h"
#include "schedulelistmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Добавляем иконку
    app.setWindowIcon(QIcon("qrc:/images/icon.ico"));

    // Подключаемся к базе данных
    SqlDB database;
    database.connectToDataBase();

    // Объявляем и инициализируем модели данных
    TaskListModel *modelTask = new TaskListModel();
    ScheduleListModel *modelSchedule = new ScheduleListModel();

    // Обеспечиваем доступ к моделям и классам для работы с базой данных из QML
    engine.rootContext()->setContextProperty("modelTask", modelTask);
    engine.rootContext()->setContextProperty("modelSchedule", modelSchedule);
    engine.rootContext()->setContextProperty("database", &database);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
