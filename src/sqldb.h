#ifndef SQLDB_H
#define SQLDB_H

#include <QObject>
#include <QSql>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlDatabase>
#include <QFile>
#include <QDate>
#include <QDebug>

/* Директивы имен таблицы, полей таблицы и базы данных */
#define DATABASE_HOSTNAME   "OrganaizDataBase"
#define DATABASE_NAME       "OrganaizerStudent.db"

// Первая колонка содержит Autoincrement ID
#define TABLE_TASK                  "TaskTable"           // Название таблицы
#define TABLE_TASK_START_DATE       "StartDate"           // Вторая колонка
#define TABLE_TASK_DEADLINE_TIME    "DeadlineTime"        // Третья колонка
#define TABLE_TASK_DEADLINE_DATE    "DeadlineDate"        // ...
#define TABLE_TASK_TITLE            "TaskTitle"
#define TABLE_TASK_DESC             "TaskDescription"
#define TABLE_TASK_STATUS           "TaskStatus"
// Аналогично для таблици с расписанием
#define TABLE_SCHEDULE              "ScheduleTable"
#define TABLE_SCHEDULE_START_TIME   "ScheduleStart"
#define TABLE_SCHEDULE_END_TIME     "ScheduleEnd"
#define TABLE_SCHEDULE_WEEK         "ScheduleWeek"
#define TABLE_SCHEDULE_TITLE        "ScheduleTitle"
#define TABLE_SCHEDULE_DESC         "ScheduleDescription"

class SqlDB : public QObject {
    Q_OBJECT
public:
    explicit SqlDB(QObject *parent = 0);
    ~SqlDB();
    /* Методы для непосредственной работы с классом
     * Подключение к базе данных и вставка записей в таблицу
     * */
    void connectToDataBase();

private:
    // Сам объект базы данных, с которым будет производиться работа
    QSqlDatabase    db;

private:
    /* Внутренние методы для работы с базой данных
     * */
    bool openDataBase();        // Открытие базы данных
    bool restoreDataBase();     // Восстановление базы данных
    void closeDataBase();       // Закрытие базы данных
    bool createTable();         // Создание базы таблицы в базе данных
    QString encodeDate(const QString &s);  // Преобразуем дату в формат yyyyMMdd для бд

public slots:
    // Добавление записей в таблицу
    bool inserIntoTableTask(const QVariantList &data); // Для заданий
    bool inserIntoTableSchedule(const QVariantList &data); // Для расписания
    bool inserIntoTable(const QString &db, const QString &start, const QString &end,
                        const QString &date, const QString &title, const QString &desc, const QString &status);
    bool removeRecord(const QString &db, const QString &id); // Удаление записи из таблицы по её id
    bool searchTask(const QString &date); // Проверяем есть ли запись в базе по дате
    void updateTask(const QString &id, const QString &status); // Обновляем статус задачи
    QString decodeDate(const QString &s);  // Преобразуем дату в формат dd-MM-yyyy
};
#endif // SQLDB_H
