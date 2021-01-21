

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  MyRealGame daGame = MyRealGame();
  runApp(
    GameWidget(
      game: daGame,
    ),
  );
}

enum Direction {up, down, left, right}
enum Typez {rotate, updown, leftright}

class Fly extends SpriteComponent with HasGameRef<MyRealGame> {
  Typez tag;//to keep the ref of which object of FLY class is being checked at runtime
  Direction dir;

  @override
  void render(Canvas c) { super.render(c); }


  @override
  void update(double t) {
    super.update(t);

    switch(tag) {
      case Typez.rotate: {  angle+=0.01; }
      break;
      case Typez.updown: {  update_updownPosition();}
      break;
      case Typez.leftright: {  update_leftrightPosition(); }
      break;
    }

  }

  @override //called when Component is just delivered onto the canvas
  void onMount() async {
    super.onMount();
    print('Mount...');
    size = Vector2.all(50);
    anchor = Anchor.center;
    switch(tag) {
      case Typez.rotate: {  x = 100; y = 100; }
      break;
      case Typez.updown: {  x = 200; y = 100; dir = Direction.up;}
      break;
      case Typez.leftright: {  x = 200; y = 300; dir = Direction.left; }
      break;
    }
  }

  void update_updownPosition() {
    if(y<=100 && dir == Direction.up){dir= Direction.down;}
    else if(y>=500 && dir==Direction.down){dir = Direction.up;}
    if(dir==Direction.down){y+=1.5;}
    else if(dir == Direction.up){y-=1.5;}
  }

  void update_leftrightPosition() {
    if(x<=100 && dir == Direction.left){dir = Direction.right;}
    else if(x>=300 && dir == Direction.right){dir = Direction.left;}
    if(dir == Direction.right){x++;}
    else if(dir == Direction.left){x--;}
  }

}


class MyRealGame extends BaseGame{
  Sprite theSprite;
  Fly updownFly = Fly();//will need a variable since we are checking stuff at run time
  Fly leftrightFly = Fly();//same as above
  SpriteAnimationComponent aniCom1;//needed to be called from outside onLoad(), hence cant be local

  Future<void> onLoad() async {
    print('LOAD....');
    theSprite = await loadSprite('fly.png');

    add(Fly()//since we arent interacting with this object, kept it annonymous
      ..sprite=theSprite
      ..tag=Typez.rotate);

    add(updownFly
      ..sprite=theSprite
      ..tag=Typez.updown);

    add(leftrightFly
      ..sprite=theSprite
      ..tag=Typez.leftright);

    //this is customised way to construct your frames... but easier is to use SpriteAnimationData.sequenced constructor
    var spriteSheet =  await images.load('spritesheet.png');      
    final spriteSize = Vector2(32.0, 72.0);
    List<SpriteAnimationFrameData> frames = List(8);
    frames[0] = SpriteAnimationFrameData(srcPosition: Vector2(0,0), srcSize: Vector2(16,36), stepTime: 0.2);
    frames[1] = SpriteAnimationFrameData(srcPosition: Vector2(16,0), srcSize: Vector2(16,36), stepTime: 0.2);
    frames[2] = SpriteAnimationFrameData(srcPosition: Vector2(32,0), srcSize: Vector2(16,36), stepTime: 0.2);
    frames[3] = SpriteAnimationFrameData(srcPosition: Vector2(48,0), srcSize: Vector2(16,36), stepTime: 0.2);
    frames[4] = SpriteAnimationFrameData(srcPosition: Vector2(64,0), srcSize: Vector2(16,36), stepTime: 0.2);
    frames[5] = SpriteAnimationFrameData(srcPosition: Vector2(80,0), srcSize: Vector2(16,36), stepTime: 0.2);
    frames[6] = SpriteAnimationFrameData(srcPosition: Vector2(96,0), srcSize: Vector2(16,36), stepTime: 0.2);
    frames[7] = SpriteAnimationFrameData(srcPosition: Vector2(112,0), srcSize: Vector2(16,36), stepTime: 0.2);
    SpriteAnimationData data = SpriteAnimationData(frames);
    final aniCom = SpriteAnimationComponent.fromFrameData(spriteSize,spriteSheet,data)
      ..x = 100
      ..y = 450;
    add(aniCom);
    //==================================

    //example of getting co ordinates in a non linear spritesheet
    var explode =  await images.load('explode.png');
    final spriteSize1 = Vector2(100, 100);
    List<SpriteAnimationFrameData> frames1 = List(16);
    int z=0;
    for(int y=0;y<=192;y+=64){
      for(int x=0;x<=192;x+=64) {
        frames1[z] = SpriteAnimationFrameData(srcPosition: Vector2(x.toDouble(),y.toDouble()), srcSize: Vector2(64,64), stepTime: 0.2);
        z++;
      }
    }
    /*frames1 = [
          SpriteAnimationFrameData(srcPosition: Vector2(0,0), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(64,0), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(128,0), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(192,0), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(0,64), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(64,64), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(128,64), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(192,64), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(0,128), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(64,128), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(128,128), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(192,128), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(0,192), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(64,192), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(128,192), srcSize: Vector2(64,64), stepTime: 0.2),
          SpriteAnimationFrameData(srcPosition: Vector2(192,192), srcSize: Vector2(64,64), stepTime: 0.2)
          ];*/
    SpriteAnimationData data1 = SpriteAnimationData(frames1);
    aniCom1 = SpriteAnimationComponent.fromFrameData(spriteSize1,explode,data1,removeOnFinish: true);
  //==================================

    //if your sprite sheet is in sequence from left to right... you can use this data constructor... simple & fast
    SpriteAnimationData data2 = SpriteAnimationData.sequenced(amount: 8, stepTime: 0.2, textureSize: Vector2(16,36) );
    final aniCom2 = SpriteAnimationComponent.fromFrameData(spriteSize,spriteSheet,data2)
      ..x = 100
      ..y = 350;
    add(aniCom2);


  }

  @override
  void update(double t) {
    super.update(t);

    if(leftrightFly.shouldRemove){return;}//if this isnt there it might still run the below if block even after being removed!
    if(leftrightFly.checkOverlap(updownFly.position)){
      print('BANG ');
      PositionExplosion();
      leftrightFly.remove();
      updownFly.remove();
    }

  }

  //just a simple logic to decide where to draw the explosion animation
  void PositionExplosion() {
    if(leftrightFly.dir==Direction.left){
      if(leftrightFly.y > updownFly.y){
        aniCom1.x = updownFly.x ;
        aniCom1.y = updownFly.y ;
        print('111');
      }
      else{
        aniCom1.x = leftrightFly.x -50;
        aniCom1.y = updownFly.y -50;
        print('222');
      }
    }
    else{//moving right
      if(leftrightFly.y > updownFly.y){
        aniCom1.x = leftrightFly.x;
        aniCom1.y = leftrightFly.y;
        print('3333');
      }
      else{
        aniCom1.x = updownFly.x -50;
        aniCom1.y = leftrightFly.y -50;
        print('444');
      }
    }
    add(aniCom1);//only after it has received an x&y cordinate.. add it to the game
  }


}


