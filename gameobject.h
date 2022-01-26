#ifndef GAMEOBJECT_H
#define GAMEOBJECT_H

#include <QQuickItem>

class GameObject : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QVector2D position READ position WRITE setPosition NOTIFY positionChanged)
public:
    explicit GameObject(QObject * parent = nullptr);
    ~GameObject();

    QVector2D position() const;
    void setPosition(const QVector2D &position);

    virtual void moveTo(QPointF pos) = 0;
    virtual void tick(qreal deltaTime) = 0;
    virtual bool intersectsWith(const GameObject* other);

Q_SIGNALS:
    void positionChanged();
};

#endif // GAMEOBJECT_H
