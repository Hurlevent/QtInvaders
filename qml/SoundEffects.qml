import QtQuick
import QtMultimedia

Item {
    function playRandomExplosion(){
        let clips = [explosion1, explosion2, explosion3, explosion4, explosion5, explosion6]
        clips[Math.floor(Math.random() * clips.length)].play();
    }
    function playRandomHit(){
        let clips = [hit1, hit2, hit3, hit4]
        clips[Math.floor(Math.random() * clips.length)].play();
    }
    function playRandomGameover(){
        let clips = [gameover1, gameover2]
        clips[Math.floor(Math.random() * clips.length)].play();
    }
    function playRandomShoot(){
        let clips = [shoot1, shoot2, shoot3, shoot4, shoot5, shoot6]
        clips[Math.floor(Math.random() * clips.length)].play();
    }
    function playRandomUfo(){
        let clips = [ufo1, ufo2]
        clips[Math.floor(Math.random() * clips.length)].play();
    }

    SoundEffect {
        id: explosion1
        source: "qrc:/sounds/explosion1.wav"
    }
    SoundEffect {
        id: explosion2
        source: "qrc:/sounds/explosion2.wav"
    }
    SoundEffect {
        id: explosion3
        source: "qrc:/sounds/explosion3.wav"
    }
    SoundEffect {
        id: explosion4
        source: "qrc:/sounds/explosion4.wav"
    }
    SoundEffect {
        id: explosion5
        source: "qrc:/sounds/explosion5.wav"
    }
    SoundEffect {
        id: explosion6
        source: "qrc:/sounds/explosion6.wav"
    }
    SoundEffect {
        id: gameover1
        source: "qrc:/sounds/gameover1.wav"
    }
    SoundEffect {
        id: gameover2
        source: "qrc:/sounds/gameover2.wav"
    }
    SoundEffect {
        id: hit1
        source: "qrc:/sounds/hit1.wav"
    }
    SoundEffect {
        id: hit2
        source: "qrc:/sounds/hit2.wav"
    }
    SoundEffect {
        id: hit3
        source: "qrc:/sounds/hit3.wav"
    }
    SoundEffect {
        id: hit4
        source: "qrc:/sounds/hit4.wav"
    }
    SoundEffect {
        id: shoot1
        source: "qrc:/sounds/shoot1.wav"
    }
    SoundEffect {
        id: shoot2
        source: "qrc:/sounds/shoot2.wav"
    }
    SoundEffect {
        id: shoot3
        source: "qrc:/sounds/shoot3.wav"
    }
    SoundEffect {
        id: shoot4
        source: "qrc:/sounds/shoot4.wav"
    }
    SoundEffect {
        id: shoot5
        source: "qrc:/sounds/shoot5.wav"
    }
    SoundEffect {
        id: shoot6
        source: "qrc:/sounds/shoot6.wav"
    }
    SoundEffect {
        id: ufo1
        source: "qrc:/sounds/ufo1.wav"
    }
    SoundEffect {
        id: ufo2
        source: "qrc:/sounds/ufo2.wav"
    }
    SoundEffect {
        id: ufo3
        source: "qrc:/sounds/ufo3.wav"
    }
}
