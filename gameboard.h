#ifndef GAMEBOARD_H
#define GAMEBOARD_H

#include <QQuickItem>
#include <QList>
#include <QTimer>
//#include <QtQuick/private/QQuickImage>
#include <QUrl>

#include "player.h"
#include "inputsystem.h"

/*
 *  TODO: need some kind of timeline that will spawn objects
 *  objects will need to be removed/cleaned up once they escape the board or are destroyed by other means.
 *
 *  PollVector from inputSystem, and move player and all other objects in motion
 *  Spawn player bullet if z, spawn bomb if x
 *
 *  Test for collision/intersection between the player and enemies
 *  Test for collision/intersection between player bullet and enemies non-bullets.
 *
 *
 */

class GameBoard : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(int hitPoints READ hitPoints WRITE setHitPoints NOTIFY hitPointsChanged)
    Q_PROPERTY(int bombs READ bombs WRITE setBombs NOTIFY bombsChanged)
    Q_PROPERTY(int score READ score WRITE setScore NOTIFY scoreChanged)
    Q_PROPERTY(int graceCount READ graceCount NOTIFY graceCountChanged)
    Q_PROPERTY(QUrl background READ background NOTIFY backgroundChanged)
public:
    explicit GameBoard();
    ~GameBoard();

    Q_INVOKABLE void start(qreal speed);
    //Q_INVOKABLE void addToObjectPool();

    QUrl background() const;

    int hitPoints() const;
    void setHitPoints(int hitPoints);

    int bombs() const;
    void setBombs(int bombs);

    int score() const;
    void setScore(int score);

    int graceCount() const;

Q_SIGNALS:
    void hitPointsChanged();
    void bombsChanged();
    void scoreChanged();
    void graceCountChanged();
    void backgroundChanged();

private:
    void tick();
    void reset();

    int m_hitPoints;
    int m_bombs;
    int m_score;
    int m_graceCount;

    QList<GameObject *> m_objectPool;
    QTimer *m_gameTimer = nullptr;
};

#endif // GAMEBOARD_H
