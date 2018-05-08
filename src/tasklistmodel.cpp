#include "tasklistmodel.h"
#include "sqldb.h"

TaskListModel::TaskListModel(QObject *parent) :
    QSqlQueryModel(parent) {
    this->updateModel(QDate::currentDate().toString("yyyyMMdd"));
}

// Метод для получения данных из модели
QVariant TaskListModel::data(const QModelIndex & index, int role) const {

    // Определяем номер колонки, адрес так сказать, по номеру роли
    int columnId = role - Qt::UserRole - 1;
    // Создаём индекс с помощью новоиспечённого ID колонки
    QModelIndex modelIndex = this->index(index.row(), columnId);

    /* И с помощью уже метода data() базового класса
     * вытаскиваем данные для таблицы из модели
     * */
    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}

// Метод для получения имен ролей через хешированную таблицу.
QHash<int, QByteArray> TaskListModel::roleNames() const {
    /* То есть сохраняем в хеш-таблицу названия ролей
     * по их номеру
     * */
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[StartDate] = "startdate";
    roles[DeadlineTime] = "endtime";
    roles[DeadlineDate] = "enddate";
    roles[TaskTitle] = "tasktitle";
    roles[TaskDescription] = "taskdesc";
    roles[TaskStatus] = "taskstatus";
    return roles;
}

// Метод обновления таблицы в модели представления данных
void TaskListModel::updateModel(const QString &date) {
    // Обновление производится SQL-запросом к базе данных
    this->setQuery("SELECT id, "
                   TABLE_TASK_START_DATE ", "
                   TABLE_TASK_DEADLINE_TIME ", "
                   TABLE_TASK_DEADLINE_DATE ", "
                   TABLE_TASK_TITLE ", "
                   TABLE_TASK_DESC ", "
                   TABLE_TASK_STATUS " FROM " TABLE_TASK " WHERE " TABLE_TASK_DEADLINE_DATE " >= '"+date+"' and "
                   TABLE_TASK_START_DATE" <= '"+date+"' ORDER BY " TABLE_TASK_STATUS "," TABLE_TASK_DEADLINE_DATE);
}
// Получение значений по строке из модели представления данных
QVariantMap TaskListModel::get(int idx) {
    QVariantMap map;
    foreach(int k, roleNames().keys()) {
        map[roleNames().value(k)] = data(index(idx, 0), k);
    }
    return map;
}
