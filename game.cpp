#include "game.h"
#include <QRandomGenerator>
#include <QDebug>

Game::Game(QObject *parent)
    : QObject(parent)
{
    words = {
        "APPLE","GRAPE","CRANE","STONE","SHARK",
        "PLANT","BRICK","LIGHT","SOUND","WATER",
        "HOUSE","MOUSE","TRAIN","FLAME","BRAIN",
        "CLOUD","RIVER","FIELD","PLANE","SUGAR",
        "CHAIR","TABLE","CLEAN","BREAK","DREAM",
        "SWEET","HEART","WORLD","GREEN","BLACK"
    };

    target = words[
        QRandomGenerator::global()->bounded(words.size())
    ];

    qDebug() << "TARGET:" << target;
}

bool Game::isValidWord(const QString &guess)
{
    return words.contains(guess.toUpper());
}

QString Game::checkWord(const QString &guess)
{
    QString g = guess.toUpper();

    QString result = "XXXXX";
    QString temp = target;

    // Green Phase
    for (int i = 0; i < 5; i++) {
        if (g[i] == temp[i]) {
            result[i] = 'G';
            temp[i] = '*';
        }
    }

    // Yellow Phase
    for (int i = 0; i < 5; i++) {
        if (result[i] == 'G') continue;

        int pos = temp.indexOf(g[i]);
        if (pos != -1) {
            result[i] = 'Y';
            temp[pos] = '*';
        }
    }

    qDebug() << "GUESS:" << g << "RESULT:" << result;

    return result;
}