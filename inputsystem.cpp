#include "inputsystem.h"

InputSystem::InputSystem()
{

}

bool InputSystem::event(QEvent *e){
    if(e->type() == QEvent::KeyPress) {
        auto keyPressEvent = static_cast<QKeyEvent*>(e);
        switch (keyPressEvent->key()) {
        qDebug() << "pressedKey: " << keyPressEvent->key();
        case Qt::Key_Right:
            m_rightDown = true;
            m_leftDown = false;
            return true;
        case Qt::Key_Left:
            m_leftDown = true;
            m_rightDown = false;
            return true;
        case Qt::Key_Up:
            m_upDown = true;
            m_downDown = false;
            return true;
        case Qt::Key_Down:
            m_downDown = true;
            m_upDown = false;
            return true;
        case Qt::Key_Shift:
            m_shiftDown = true;
            return true;
        case Qt::Key_Space:
            m_spacebarDown = true;
            return true;
        case Qt::Key_Z:
            m_zDown = true;
            return true;
        case Qt::Key_X:
            m_xDown = true;
            return true;
        case Qt::Key_Escape:
            emit escapePressed();
        }
    } else if (e->type() == QEvent::KeyRelease){
        auto keyReleaseEvent = static_cast<QKeyEvent*>(e);
        switch (keyReleaseEvent->key()) {
        case Qt::Key_Right:
            m_rightDown = false;
            return true;
        case Qt::Key_Left:
            m_leftDown = false;
            return true;
        case Qt::Key_Up:
            m_upDown = false;
            return true;
        case Qt::Key_Down:
            m_downDown = false;
            return true;
        case Qt::Key_Shift:
            m_shiftDown = false;
            return true;
        case Qt::Key_Space:
            m_spacebarDown = false;
            return true;
        case Qt::Key_Z:
            m_zDown = false;
            return true;
        case Qt::Key_X:
            m_xDown = false;
            return true;
        }
    }

    return false;
}

QVector2D InputSystem::pollVector() const {
    qreal x = qreal(-int(m_leftDown)) + qreal(int(m_rightDown));
    qreal y = qreal(int(m_upDown)) + qreal(-int(m_downDown));

    return QVector2D(x,y).normalized();
}
bool InputSystem::pollSpacebar() const {
    return m_spacebarDown;
}
bool InputSystem::pollShift() const {
    return m_shiftDown;
}
bool InputSystem::pollZ() const {
    return m_zDown;
}
bool InputSystem::pollX() const {
    return m_xDown;
}
