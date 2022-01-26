#ifndef PLAYER_H
#define PLAYER_H

#include "gameobject.h"

class Player : public GameObject
{
    Q_OBJECT
    Q_PROPERTY(qreal movementSpeed READ movementSpeed WRITE setMovementSpeed NOTIFY movementSpeedChanged)
public:
    explicit Player(QObject *parent = nullptr);

    virtual void moveTo(QPointF pos) override;

    virtual void tick(qreal deltaTime) override;

    qreal movementSpeed() const;
    void setMovementSpeed(qreal speed);

Q_SIGNALS:
    void movementSpeedChanged();

private:
    QQuickItem * m_player = nullptr;
    qreal m_movementSpeed = qreal(10);
    QPointF m_targetDestination;
};

#endif // PLAYER_H
