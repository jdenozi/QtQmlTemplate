#include <QApplication>
#include <QQmlApplicationEngine>
#include "version.h"

int main(int argc, char *argv[]) {
    QApplication a(argc, argv);
    QApplication::setApplicationName("Qt qml template");
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:modules/main.qml"));
    QObject::connect(
            &engine, &QQmlApplicationEngine::objectCreated, qApp,
            [url](QObject *obj, const QUrl &objUrl) {
                if (!obj && url == objUrl)
                    QCoreApplication::exit(-1);
            },
            Qt::QueuedConnection);
    engine.rootContext()->setContextProperty("appVersion", QString(QT_QML_TEMPLATE_VERSION));
    engine.addImportPath( "qrc:modules/");
    engine.load(url);
    qApp->exec();
}
