#include "sqldb.h"
#include "QCoreApplication"
SqlDB::SqlDB(QObject *parent) : QObject(parent){ }

SqlDB::~SqlDB(){ }

/* Методы для подключения к базе данных
 * */
void SqlDB::connectToDataBase() {
    QString path = qApp->applicationDirPath() + "/" + DATABASE_NAME;
    /* Перед подключением к базе данных производим проверку на её существование.
     * В зависимости от результата производим открытие базы данных или её создание
     * */
    if(!QFile(path).exists()){
        this->restoreDataBase();
    } else {
        this->openDataBase();
    }
}

/* Методы восстановления базы данных
 * */
bool SqlDB::restoreDataBase() {
    // Если база данных открылась ...
    if(this->openDataBase()){
        // Производим восстановление базы данных
        return (this->createTable()) ? true : false;
    } else {
        qDebug() << "Не удалось восстановить базу данных";
        return false;
    }
    return false;
}

/* Метод для открытия базы данных
 * */
bool SqlDB::openDataBase() {
    /* База данных открывается по заданному пути
     * и имени базы данных, если она существует
     * */
    QString path = qApp->applicationDirPath() + "/" + DATABASE_NAME;
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setHostName(DATABASE_HOSTNAME);
    db.setDatabaseName(path);
    if(db.open()){
        return true;
    } else {
        return false;
    }
}

/* Методы закрытия базы данных
 * */
void SqlDB::closeDataBase() {
    db.close();
}

/* Метод для создания таблицы в базе данных
 * */
bool SqlDB::createTable() {
    /* В данном случае используется формирование сырого SQL-запроса
     * с последующим его выполнением.
     * */
    QSqlQuery query;
    if(!query.exec( "CREATE TABLE " TABLE_TASK " ("
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                    TABLE_TASK_START_DATE       " VARCHAR(255)    NOT NULL,"
                    TABLE_TASK_DEADLINE_TIME    " VARCHAR(255)    NOT NULL,"
                    TABLE_TASK_DEADLINE_DATE    " VARCHAR(255)    NOT NULL,"
                    TABLE_TASK_TITLE            " VARCHAR(255)    NOT NULL,"
                    TABLE_TASK_DESC             " VARCHAR(255)    NOT NULL,"
                    TABLE_TASK_STATUS           " VARCHAR(255)    NOT NULL)") ||
            !query.exec( "CREATE TABLE " TABLE_SCHEDULE " ("
                         "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                         TABLE_SCHEDULE_START_TIME  " VARCHAR(255)    NOT NULL,"
                         TABLE_SCHEDULE_END_TIME    " VARCHAR(255)    NOT NULL,"
                         TABLE_SCHEDULE_WEEK        " VARCHAR(255)    NOT NULL,"
                         TABLE_SCHEDULE_TITLE       " VARCHAR(255)    NOT NULL,"
                         TABLE_SCHEDULE_DESC        " VARCHAR(255)    NOT NULL)")){
        qDebug() << "DataBase: error of create " << TABLE_TASK << " & " << TABLE_SCHEDULE;
        qDebug() << query.lastError().text();
        return false;
    } else {
        return true;
    }
    return false;
}

// Метод для вставки записи в базу данных для заданий по готовому List
bool SqlDB::inserIntoTableTask(const QVariantList &data) {
    /* Запрос SQL формируется из QVariantList,
     * в который передаются данные для вставки в таблицу.
     * */
    QSqlQuery query;
    /* В начале SQL запрос формируется с ключами,
     * которые потом связываются методом bindValue
     * для подстановки данных из QVariantList
     * */
    query.prepare("INSERT INTO " TABLE_TASK " ( "
                  TABLE_TASK_START_DATE ", "
                  TABLE_TASK_DEADLINE_TIME ", "
                  TABLE_TASK_DEADLINE_DATE ", "
                  TABLE_TASK_TITLE ", "
                  TABLE_TASK_DESC ", "
                  TABLE_TASK_STATUS " ) "
                  "VALUES (:StartDate, :DeadlineTime, :DeadlineDate, :TaskTitle, :TaskDescription, :TaskStatus)");
    query.bindValue(":StartDate",          data[0].toString());
    query.bindValue(":DeadlineTime",       data[1].toString());
    query.bindValue(":DeadlineDate",       data[2].toString());
    query.bindValue(":TaskTitle",          data[3].toString());
    query.bindValue(":TaskDescription",    data[4].toString());
    query.bindValue(":TaskStatus",         data[5].toString());
    // После чего выполняется запросом методом exec()
    if(!query.exec()){
        qDebug() << "error insert into " << TABLE_TASK;
        qDebug() << query.lastError().text();
        return false;
    } else {
        return true;
    }
    return false;
}
// Аналогично для рассписания
bool SqlDB::inserIntoTableSchedule(const QVariantList &data) {
    QSqlQuery query;
    query.prepare("INSERT INTO " TABLE_SCHEDULE " ( "
                  TABLE_SCHEDULE_START_TIME ", "
                  TABLE_SCHEDULE_END_TIME ", "
                  TABLE_SCHEDULE_WEEK ", "
                  TABLE_SCHEDULE_TITLE ", "
                  TABLE_SCHEDULE_DESC " ) "
                  "VALUES (:ScheduleStart, :ScheduleEnd, :ScheduleWeek, :ScheduleTitle, :ScheduleDescription)");
    query.bindValue(":ScheduleStart",       data[0].toString());
    query.bindValue(":ScheduleEnd",         data[1].toString());
    query.bindValue(":ScheduleWeek",        data[2].toString());
    query.bindValue(":ScheduleTitle",       data[3].toString());
    query.bindValue(":ScheduleDescription", data[4].toString());

    if(!query.exec()){
        qDebug() << "error insert into " << TABLE_SCHEDULE;
        qDebug() << query.lastError().text();
        return false;
    } else {
        return true;
    }
    return false;
}

// Метод формирования List для дальнейшей вставки в таблицу
bool SqlDB::inserIntoTable(const QString &db, const QString &start, const QString &end,
                           const QString &date, const QString &title, const QString &desc, const QString &status) {
    QVariantList data;
    data.append(db == "task" ? encodeDate(start) : start);
    data.append(end);
    data.append(db == "task" ? encodeDate(date) : date);
    data.append(title);
    data.append(desc);
    if(db == "task")
        data.append(status);

    if(db == "task" ? inserIntoTableTask(data) : inserIntoTableSchedule(data))
        return true;
    else
        return false;
}

// Метод для удаления записи из таблицы
bool SqlDB::removeRecord(const QString &db, const QString &id) {
    // Удаление строки из базы данных будет производитсья с помощью SQL-запроса
    QSqlQuery query;
    QString b = db == "task" ? TABLE_TASK : TABLE_SCHEDULE;

    // Удаление производим по id записи, который передается в качестве аргумента функции
    query.prepare("DELETE FROM " + b + " WHERE id= :ID ;");
    query.bindValue(":ID", id);

    // Выполняем
    if(!query.exec()){
        qDebug() << "error delete row " << b;
        qDebug() << query.lastError().text();
        return false;
    } else {
        return true;
    }
    return false;
}

// Метод проверки наличия не выполненных задач в дате
bool SqlDB::searchTask(const QString &date) {
    QSqlQuery query;
    query.prepare("SELECT COUNT(*) FROM " TABLE_TASK " WHERE " TABLE_TASK_DEADLINE_DATE " = '"+date+"' and "
                  TABLE_TASK_STATUS " = 'In process'");
    if(query.exec())
    {
        while (query.next())
        {
            if(query.value(0).toInt() > 0)
                return true;
            else return false;
        }
    } else return false;
    return false;
}
// Метод обновления статуса задачи по ее id
void SqlDB::updateTask(const QString &id, const QString &status) {
    QSqlQuery query;
    query.prepare("UPDATE " TABLE_TASK " SET " TABLE_TASK_STATUS " = :STATUS WHERE ID = :ID;");
    query.bindValue(":ID", id);
    query.bindValue(":STATUS", status);
    query.exec();
}
QString SqlDB::encodeDate(const QString &s) {
    QDateTime dt = QDateTime::fromString(s, "dd-MM-yyyy");
    QString timeStr = dt.toString("yyyyMMdd");
    return timeStr;
}
QString SqlDB::decodeDate(const QString &s) {
    QDateTime dt = QDateTime::fromString(s, "yyyyMMdd");
    QString timeStr = dt.toString("dd-MM-yyyy");
    return timeStr;
}
