#pragma once

#include <QObject>
#include <qqmlintegration.h>



class KeyLock : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    
    Q_PROPERTY(bool capsLock READ capsLock NOTIFY capsLockChanged)
    Q_PROPERTY(bool numLock READ numLock NOTIFY numLockChanged)

public:
    KeyLock(QObject *parent = nullptr);
    KeyLock(const KeyLock &) = delete;
    KeyLock &operator=(const KeyLock&) = delete;
    KeyLock(KeyLock &&) = delete;
    KeyLock &operator=(KeyLock&&) = delete;

    [[nodiscard]] bool capsLock() const {
        return m_capsLock;
    }
    [[nodiscard]] bool numLock() const {
        return m_numLock;
    }

signals:
    void capsLockChanged();
    void numLockChanged();

private:
    bool m_capsLock = false;
    bool m_numLock = false;
};