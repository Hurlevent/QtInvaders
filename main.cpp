#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QScopedPointer>

#include "inputsystem.h"
#include "player.h"

//#include "gameboard.h"


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QScopedPointer inputManager(new InputSystem);
    qmlRegisterSingletonInstance("QtInvaders.Input", 1, 0, "Input", inputManager.get());
    qmlRegisterType<Player>("QtInvaders", 1, 0, "Player");
    //qmlRegisterType<GameBoard>("QtInvaders", 1, 0, "GameBoard");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
