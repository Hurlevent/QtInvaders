#ifndef INPUTSYSTEM_H
#define INPUTSYSTEM_H

#include <QObject>
#include <QEvent>
#include <QKeyEvent>

class InputSystem : public QObject
{
    Q_OBJECT
public:
    explicit InputSystem();

    bool event(QEvent *e) override;

    Q_INVOKABLE QVector2D pollVector() const;
    Q_INVOKABLE bool pollSpacebar() const;
    Q_INVOKABLE bool pollShift() const;
    Q_INVOKABLE bool pollZ() const;
    Q_INVOKABLE bool pollX() const;

Q_SIGNALS:
    void escapePressed();

private:
    bool m_leftDown = false;
    bool m_rightDown = false;
    bool m_upDown = false;
    bool m_downDown = false;
    bool m_spacebarDown = false;
    bool m_zDown = false;
    bool m_xDown = false;
    bool m_shiftDown = false;
};

#endif // INPUTSYSTEM_H
