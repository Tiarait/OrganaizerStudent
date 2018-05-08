QT += qml quick sql
CONFIG += c++11

include(src/src.pri)

RESOURCES += resource.qrc
RC_FILE = appicon.rc

target.path = /bin
INSTALLS += target
