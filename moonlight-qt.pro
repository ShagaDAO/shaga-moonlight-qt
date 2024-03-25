TEMPLATE = subdirs
SUBDIRS = \
    moonlight-common-c \
    qmdnsengine \
    app \
    h264bitstream

# Build the dependencies in parallel before the final app
app.depends = qmdnsengine moonlight-common-c h264bitstream
win32:!winrt {
    SUBDIRS += AntiHooking
    app.depends += AntiHooking
}
!winrt:win32|macx {
    SUBDIRS += soundio
    app.depends += soundio
}

# Support debug and release builds from command line for CI
CONFIG += debug_and_release

# Run our compile tests
load(configure)
qtCompileTest(SL)
qtCompileTest(EGL)

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/./release/ -liroh_net_ffi.dll
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/./debug/ -liroh_net_ffi.dll

INCLUDEPATH += $$PWD/moonlight-common-c
DEPENDPATH += $$PWD/moonlight-common-c

win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$PWD/./release/libiroh_net_ffi.dll.a
else:win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$PWD/./debug/libiroh_net_ffi.dll.a

unix:!macx: LIBS += -L$$PWD/./ -liroh_net_ffi.dll

INCLUDEPATH += $$PWD/''
DEPENDPATH += $$PWD/''

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/./release/ -llibiroh_net_ffi.dll
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/./debug/ -llibiroh_net_ffi.dll

INCLUDEPATH += $$PWD/moonlight-common-c/moonlight-common-c/src
DEPENDPATH += $$PWD/moonlight-common-c/moonlight-common-c/src

win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$PWD/./release/liblibiroh_net_ffi.dll.a
else:win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$PWD/./debug/liblibiroh_net_ffi.dll.a
