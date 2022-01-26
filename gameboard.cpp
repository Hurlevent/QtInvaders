#include "gameboard.h"

GameBoard::GameBoard()
{
    m_hitPoints = 0;
    m_bombs = 0;
    m_score = 0;
    m_gameTimer = new QTimer;
    connect(m_gameTimer, &QTimer::timeout, this, &GameBoard::tick);
}

GameBoard::~GameBoard(){
    if(m_gameTimer) {
        delete m_gameTimer;
    }
    m_gameTimer = nullptr;
}

void GameBoard::start(qreal speed){
    reset();
}

void GameBoard::reset(){
    setHitPoints(3);
    setBombs(2);
    setScore(0);
}

void GameBoard::tick() {


}

QUrl GameBoard::background() const {
    return QUrl("qrc:nebula/stars.png");
}

int GameBoard::hitPoints() const {
    return m_hitPoints;
}
void GameBoard::setHitPoints(int hitPoints){
    if (m_hitPoints == hitPoints)
        return;
    m_hitPoints = hitPoints;
    emit hitPointsChanged();
}

int GameBoard::bombs() const {
    return m_bombs;
}
void GameBoard::setBombs(int bombs){
    if (m_bombs == bombs)
        return;
    m_bombs = bombs;
    emit bombsChanged();
}

int GameBoard::score() const {
    return m_score;
}
void GameBoard::setScore(int score) {
    if (m_score == score)
        return;
    m_score = score;
    emit scoreChanged();
}

int GameBoard::graceCount() const {
    return m_graceCount;
}
