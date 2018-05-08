#ifndef TaskListModel_H
#define TaskListModel_H

#include <QObject>
#include <QSqlQueryModel>

class TaskListModel : public QSqlQueryModel {
    Q_OBJECT
    public:
        /* Перечисляем все роли, которые будут использоваться в TableView
         * Как видите, они должны лежать в памяти выше параметра Qt::UserRole
         * Связано с тем, что информация ниже этого адреса не для кастомизаций
         * */
        enum Roles {
            IdRole = Qt::UserRole + 1,  // id
            StartDate,                  // дата начала задания
            DeadlineTime,               // время крайнего срока
            DeadlineDate,               // дата крайнего срока
            TaskTitle,                  // название
            TaskDescription,            // описание
            TaskStatus                  // статус
        };

        // объявляем конструктор класса
        explicit TaskListModel(QObject *parent = 0);

        // Переопределяем метод, который будет возвращать данные
        QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    protected:
        /* хешированная таблица ролей для колонок.
         * Метод используется в дебрях базового класса QAbstractItemModel,
         * от которого наследован класс QSqlQueryModel
         * */
        QHash<int, QByteArray> roleNames() const;
    signals:

    public slots:
        void updateModel(const QString &date);
        QVariantMap get(int idx);
};

#endif // TaskListModel_H
