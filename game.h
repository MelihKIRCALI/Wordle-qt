#ifndef GAME_H
#define GAME_H

#include <QObject>
#include <QString>
#include <QStringList>

class Game : public QObject
{
    Q_OBJECT
public:
    explicit Game(QObject *parent = nullptr);

    Q_INVOKABLE QString checkWord(const QString &guess);
    Q_INVOKABLE bool isValidWord(const QString &guess);

private:
    QString target;
    QStringList words;
};

#endif // GAME_H