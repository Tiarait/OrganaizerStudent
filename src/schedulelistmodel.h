#ifndef SCHEDULELISTMODEL_H
#define SCHEDULELISTMODEL_H

#include <QObject>
#include <QSqlQueryModel>

//Аналогично как в tasklistmodel
class ScheduleListModel : public QSqlQueryModel {
    Q_OBJECT
    public:
        enum Roles {
            IdRole = Qt::UserRole + 1,
            ScheduleStart,
            ScheduleEnd,
            ScheduleWeek,
            ScheduleTitle,
            ScheduleDescription
        };
        explicit ScheduleListModel(QObject *parent = 0);
        QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    protected:
        QHash<int, QByteArray> roleNames() const;
    public slots:
        void updateModel(const QString &week);
        QVariantMap get(int idx);
};


#endif // SCHEDULELISTMODEL_H
