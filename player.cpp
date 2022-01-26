#include "player.h"

#include <QtQml/QQmlContext>
#include <QtQml/QQmlInfo>
#include <QQuickItem>

Player::Player(QObject *parent) : GameObject(parent)
{
    if (!parent)
        qWarning() << "Player object should not be the a top-level object";

    setParent(parent);

    QQmlContext *qmlContext = ::qmlContext(parent);

    if (!qmlContext) {
        qmlWarning(parent) << "No qml context for player object";
        return;
    }

    const auto playerQml = QUrl(QStringLiteral("qrc:PlayerView.qml"));

    QQmlComponent playerComponent(qmlContext->engine(), playerQml, parent);
    if (!playerComponent.isReady()) {
        qmlWarning(parent) << "Failed to load player component:\n"
                           << playerComponent.errorString();
        return;
    }

    m_player = qobject_cast<QQuickItem *>(playerComponent.create());

    if (!m_player) {
        qmlWarning(parent) << "Failed to create an instance of Player.qml\n"
                           << playerComponent.errorString();
        return;
    }

    m_player->setParent(this);

//    connect(m_player, &QQuickItem::implicitWidthChanged, this, &QQuickItem::setImplicitWidth);
//    connect(m_player, &QQuickItem::implicitHeightChanged, this, &QQuickItem::setImplicitHeight);

    qDebug() << "Player sprite created with implicitWidth: " << m_player->implicitWidth() << " and implicitHeight: " << m_player->implicitHeight();
}

void Player::moveTo(QPointF pos){
    m_targetDestination = pos;
}

void Player::tick(qreal deltaTime) {

    QVector2D src(QQuickItem::x(), QQuickItem::y());
    QVector2D dest(m_targetDestination.x(), m_targetDestination.y());

    if (dest != src) {
        QVector2D diff(dest - src);

        qreal allowedMovementNow = movementSpeed() * deltaTime;

        QVector2D newPos = diff.length() > allowedMovementNow ? diff.normalized() * movementSpeed() * deltaTime : dest;

        setX(newPos.x());
        setY(newPos.y());
    }
}

qreal Player::movementSpeed() const {
    return m_movementSpeed;
}

void Player::setMovementSpeed(qreal speed) {
    if (qFuzzyCompare(m_movementSpeed, speed))
        return;
    m_movementSpeed = speed;

    emit movementSpeedChanged();
}
