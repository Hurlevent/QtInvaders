#include "gameobject.h"

GameObject::GameObject(QObject * parent)
{
    setParent(parent);
    connect(this, &QQuickItem::xChanged, this, &GameObject::positionChanged);
    connect(this, &QQuickItem::yChanged, this, &GameObject::positionChanged);
}

GameObject::~GameObject(){
    disconnect(this, &QQuickItem::xChanged, this, &GameObject::positionChanged);
    disconnect(this, &QQuickItem::yChanged, this, &GameObject::positionChanged);
}

bool GameObject::intersectsWith(const GameObject* other) {

    return boundingRect().intersects(other->boundingRect());
}

QVector2D GameObject::position() const {
    return QVector2D(QQuickItem::x(), QQuickItem::y());
}

void GameObject::setPosition(const QVector2D &position) {
    QQuickItem::setX(position.x());
    QQuickItem::setY(position.y());
}
