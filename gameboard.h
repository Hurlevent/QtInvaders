#ifndef GAMEBOARD_H
#define GAMEBOARD_H

#include <QQuickItem>

class GameBoard : public QQuickItem
{
    Q_OBJECT
public:
    explicit GameBoard();

    Q_INVOKABLE void init();
    Q_INVOKABLE void exec();
private:


};

#endif // GAMEBOARD_H
