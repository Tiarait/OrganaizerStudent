#include "schedulelistmodel.h"
#include "sqldb.h"


ScheduleListModel::ScheduleListModel(QObject *parent) :
    QSqlQueryModel(parent){
    this->updateModel(QDate::currentDate().toString("yyyyMMdd"));
}
QVariant ScheduleListModel::data(const QModelIndex & index, int role) const {
    int columnId = role - Qt::UserRole - 1;
    QModelIndex modelIndex = this->index(index.row(), columnId);
    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}

QHash<int, QByteArray> ScheduleListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[ScheduleStart] = "schedulstart";
    roles[ScheduleEnd] = "schedulend";
    roles[ScheduleWeek] = "schedulweek";
    roles[ScheduleTitle] = "schedultitle";
    roles[ScheduleDescription] = "scheduldesc";
    return roles;
}

void ScheduleListModel::updateModel(const QString &week){
    this->setQuery("SELECT id, "
                   TABLE_SCHEDULE_START_TIME ", "
                   TABLE_SCHEDULE_END_TIME ", "
                   TABLE_SCHEDULE_WEEK ", "
                   TABLE_SCHEDULE_TITLE ", "
                   TABLE_SCHEDULE_DESC " FROM " TABLE_SCHEDULE " WHERE "
                   TABLE_SCHEDULE_WEEK " = '"+week+"' ORDER BY " TABLE_SCHEDULE_START_TIME);
}

QVariantMap ScheduleListModel::get(int idx){
    QVariantMap map;
    foreach(int k, roleNames().keys()) {
        map[roleNames().value(k)] = data(index(idx, 0), k);
    }
    return map;
}
