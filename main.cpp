#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QBluetoothLocalDevice>
#include <QQmlContext>
#include <QDebug>
#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QtAndroid>
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    //conf bluetooth
    QList<QBluetoothHostInfo> infos = QBluetoothLocalDevice::allDevices();
    //verifie que le bluetooth est accessible
    if(infos.isEmpty())
        qWarning() << "Missing Bluetooth local device. ";

#ifndef Q_OS_ANDROID
    QString uuid;
    if (QtAndroid::androidSdkVersion() >= 23)
        uuid = QStringLiteral("c8e96402-0102-cf9c-274b-701a950fe1e8");
    else
        uuid = QStringLiteral("e8e10f95-1a70-4b27-9ccf-02010264e9c8");
#else
    const QString uuid(QStringLiteral("e8e10f95-1a70-4b27-9ccf-02010264e9c8"));
#endif


    QQmlApplicationEngine engine;

    QQuickView view(&engine, 0);
    view.rootContext()->setContextProperty("targetUuid", &uuid);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
