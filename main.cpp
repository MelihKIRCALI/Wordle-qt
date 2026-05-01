#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "game.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    Game game;
    engine.rootContext()->setContextProperty("game", &game);

    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/Wordle/Main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}