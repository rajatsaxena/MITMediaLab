import processing.opengl.*;
import SimpleOpenNI.*;
import ddf.minim.*;

SimpleOpenNI kinect;

float rotation = 0;

// two AudioPlayer objects this time
Minim minim;
AudioPlayer kick;
AudioPlayer hat;
AudioPlayer snare;

// declare our two hotpoint objects
Hotpoint hatTrigger;
Hotpoint kickTrigger;
Hotpoint snareTrigger;

float s = 1;

void setup() {
  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();

  minim = new Minim(this);
  // load both audio files
  hat = minim.loadFile("hat.wav");
  kick = minim.loadFile("kick.wav");
  snare = minim.loadFile("snare.wav");
  
  // initialize hotpoints with their origins (x,y,z) and their size
  hatTrigger = new Hotpoint(200, 0, 600, 180);
  kickTrigger = new Hotpoint(-200, 0, 600, 180);
  snareTrigger = new Hotpoint(0, -200, 600, 180);
}

void draw() {
  background(0);
  kinect.update();

  translate(width/2, height/2, -1000);
  rotateX(radians(180));

  translate(0, 0, 1400);
  rotateY(radians(map(mouseX, 0, width, -180, 180)));

  translate(0, 0, s*-1000);
  scale(s);


  stroke(255);

  PVector[] depthPoints = kinect.depthMapRealWorld();

  for (int i = 0; i < depthPoints.length; i+=10) {
    PVector currentPoint = depthPoints[i];

    // have each hotpoint check to see
    // if it includes the currentPoint
    hatTrigger.check(currentPoint);
    kickTrigger.check(currentPoint);
    snareTrigger.check(currentPoint);
    
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }

  println(hatTrigger.pointsIncluded);

  if(hatTrigger.isHit()) {
    hat.play();
  }  
  
  if(!hat.isPlaying()) {
    hat.rewind();
    hat.pause();
  }

  if (kickTrigger.isHit()) {
    kick.play();
  }  
  
  if(!kick.isPlaying()) {
    kick.rewind();
    kick.pause();
  }
 
  if (snareTrigger.isHit()) {
    snare.play();
  }  
  
  if(!snare.isPlaying()) {
    snare.rewind();
    snare.pause();
  } 
  
  // display each hotpoint
  // and clear its points
  hatTrigger.draw();
  hatTrigger.clear();
  
  kickTrigger.draw();
  kickTrigger.clear();
  
  snareTrigger.draw();
  snareTrigger.clear();
}

void stop()
{
  // make sure to close
  // both AudioPlayer objects
  kick.close();
  hat.close();
  snare.close();
  
  minim.stop();
  super.stop();
}

void keyPressed() {
  if (keyCode == 38) {
    s = s + 0.01;
  }
  if (keyCode == 40) {
    s = s - 0.01;
  }
}

