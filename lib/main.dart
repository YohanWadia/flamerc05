

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(
      game: MyRealGame(),
    ),
  );
}

class Fly extends SpriteComponent with HasGameRef<MyRealGame> {
  String tag,direction;



  @override
  void render(Canvas c) { super.render(c); }

  @override
  void update(double t) {
    super.update(t);
    if(tag=='rotate') { angle+=0.01;   }
    else if(tag=='up_down') {
      if(y<=100 && direction == 'up'){direction='down';}
      else if(y>=500 && direction=='down'){direction='up';}
      if(direction=='down'){y+=1.5;}
      else if(direction=='up'){y-=1.5;}
    }
    else if(tag=='left_right') {
      if(x<=100 && direction == 'left'){direction='right';}
      else if(x>=300 && direction=='right'){direction='left';}
      if(direction=='right'){x++;}
      else if(direction=='left'){x--;}
    }



  }

  @override
  void onMount() async {
    super.onMount();
    print('Mount...');
    size = Vector2.all(50);
    anchor = Anchor.center;
    if(tag=='rotate') {
      x = 100; y = 100;
    }
    else if(tag=='up_down') {
      x = 200; y = 100;
      direction = 'up';
    }
    else if(tag=='left_right') {
      x = 200; y = 300;
      direction = 'left';
    }
  }
}

class MyRealGame extends BaseGame{
  Sprite theSprite;
  Fly updownFly = Fly();
  Fly leftrightFly = Fly();
  SpriteAnimationComponent aniCom1;

  Future<void> onLoad() async {
    print('LOAD....');
    theSprite = await loadSprite('fly.png');
    add(Fly()
      ..sprite=theSprite
      ..tag='rotate');

    add(updownFly
      ..sprite=theSprite
      ..tag='up_down');

    add(leftrightFly
      ..sprite=theSprite
      ..tag='left_right');
    
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
    frames[7] = SpriteAnimationFrameData(srcPosition: Vector2(128,0), srcSize: Vector2(16,36), stepTime: 0.2);
    SpriteAnimationData data = SpriteAnimationData(frames);
    final aniCom = SpriteAnimationComponent.fromFrameData(spriteSize,spriteSheet,data)
      ..x = 100
      ..y = 450;
    add(aniCom);

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

    /*frames1[0] = SpriteAnimationFrameData(srcPosition: Vector2(0,0), srcSize: Vector2(64,64), stepTime: 0.2);
    frames1[1] = SpriteAnimationFrameData(srcPosition: Vector2(64,0), srcSize: Vector2(64,64), stepTime: 0.2);
    frames1[2] = SpriteAnimationFrameData(srcPosition: Vector2(128,0), srcSize: Vector2(64,64), stepTime: 0.2);
    frames1[3] = SpriteAnimationFrameData(srcPosition: Vector2(192,0), srcSize: Vector2(64,64), stepTime: 0.2);

    frames1[4] = SpriteAnimationFrameData(srcPosition: Vector2(0,64), srcSize: Vector2(64,64), stepTime: 0.2);
    frames1[5] = SpriteAnimationFrameData(srcPosition: Vector2(64,64), srcSize: Vector2(64,64), stepTime: 0.2);
    frames1[6] = SpriteAnimationFrameData(srcPosition: Vector2(128,64), srcSize: Vector2(64,64), stepTime: 0.2);
    frames1[7] = SpriteAnimationFrameData(srcPosition: Vector2(192,64), srcSize: Vector2(64,64), stepTime: 0.2);

    frames1[8] = SpriteAnimationFrameData(srcPosition: Vector2(0,128), srcSize: Vector2(64,64), stepTime: 0.2);
    frames1[9] = SpriteAnimationFrameData(srcPosition: Vector2(64,128), srcSize: Vector2(64,64), stepTime: 0.2);
    frames1[10] = SpriteAnimationFrameData(srcPosition: Vector2(128,128), srcSize: Vector2(64,64), stepTime: 0.2);
    frames1[11] = SpriteAnimationFrameData(srcPosition: Vector2(192,128), srcSize: Vector2(64,64), stepTime: 0.2);

    frames1[12] = SpriteAnimationFrameData(srcPosition: Vector2(0,192), srcSize: Vector2(64,64), stepTime: 0.2);
    frames1[13] = SpriteAnimationFrameData(srcPosition: Vector2(64,192), srcSize: Vector2(64,64), stepTime: 0.2);
    frames1[14] = SpriteAnimationFrameData(srcPosition: Vector2(128,192), srcSize: Vector2(64,64), stepTime: 0.2);
    frames1[15] = SpriteAnimationFrameData(srcPosition: Vector2(192,192), srcSize: Vector2(64,64), stepTime: 0.2);
*/
    SpriteAnimationData data1 = SpriteAnimationData(frames1);
    aniCom1 = SpriteAnimationComponent.fromFrameData(spriteSize1,explode,data1,removeOnFinish: true);

  }

  @override
  void update(double t) {
    super.update(t);

    if(leftrightFly.shouldRemove){return;}
    if(leftrightFly.checkOverlap(updownFly.position)){
      print('BANG ');
      PositionExplosion();
      leftrightFly.remove();
      updownFly.remove();
    }

  }

  void PositionExplosion() {
    if(leftrightFly.direction=='left'){
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
    add(aniCom1);
  }


}


