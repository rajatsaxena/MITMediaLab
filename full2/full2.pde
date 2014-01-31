class SkeletonPoser {
  SimpleOpenNI context;
  ArrayList rules;

  
  SkeletonPoser(SimpleOpenNI context){
    this.context = context;
    rules = new ArrayList();
  }

  void addRule(int fromJoint, int jointRelation, int toJoint){
    PoseRule rule = new PoseRule(context, fromJoint, jointRelation, toJoint);
    rules.add(rule);
  }
  
  boolean check(int userID){
    boolean result = true;
    for(int i = 0; i < rules.size(); i++){
      PoseRule rule = (PoseRule)rules.get(i);
      result = result && rule.check(userID);
    }
    return result;
  }
  
}

class PoseRule {
  int fromJoint;
  int toJoint;
  PVector fromJointVector;
  PVector toJointVector;
  SimpleOpenNI context;
    
  int jointRelation; // one of:  
  static final int ABOVE     = 1;
  static final int BELOW     = 2;
  static final int LEFT_OF   = 3;
  static final int RIGHT_OF  = 4;
  
  PoseRule(SimpleOpenNI context, int fromJoint, int jointRelation, int toJoint){
    this.context = context;
    this.fromJoint = fromJoint;
    this.toJoint = toJoint;
    this.jointRelation = jointRelation;
    
    fromJointVector = new PVector();
    toJointVector = new PVector();
  }
  
  boolean check(int userID){
    
    // populate the joint vectors for the user we're checking
    context.getJointPositionSkeleton(userID, fromJoint, fromJointVector);
    context.getJointPositionSkeleton(userID, toJoint, toJointVector);
    
    boolean result=true;
    
    switch(jointRelation){
     case ABOVE:
       result = (fromJointVector.y > toJointVector.y);
     break;
     case BELOW:
       result = (fromJointVector.y < toJointVector.y);
     break;
     case LEFT_OF:
       result = (fromJointVector.x < toJointVector.x);
     break;
     case RIGHT_OF:
       result = (fromJointVector.x > toJointVector.x);
     break;
    }
    
    return result;
  } 
}

import SimpleOpenNI.*;
// import and declarations for minim:
import ddf.minim.*;
Minim minim, minim1;
AudioPlayer player, player1;
// declare our poser object
SkeletonPoser pose, pose1;

SimpleOpenNI  kinect;

void setup() {
  size(640,480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
  
  // initialize the minim object
  minim = new Minim(this);
  minim1 = new Minim(this);
  // and load the stayin alive mp3 file
  player = minim.loadFile("stayingalive.mp3");
  player1= minim1.loadFile("pehlibaaris.mp3");
  
  // initialize the pose object
  pose = new SkeletonPoser(kinect);
  // rules for the right arm
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_HAND, PoseRule.BELOW, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_HAND, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_ELBOW, PoseRule.BELOW, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_ELBOW, PoseRule.RIGHT_OF, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  // rules for the left arm
  pose.addRule(SimpleOpenNI.SKEL_LEFT_ELBOW, PoseRule.BELOW, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  pose.addRule(SimpleOpenNI.SKEL_LEFT_ELBOW, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  pose.addRule(SimpleOpenNI.SKEL_LEFT_HAND, PoseRule.RIGHT_OF, SimpleOpenNI.SKEL_LEFT_ELBOW);
  pose.addRule(SimpleOpenNI.SKEL_LEFT_HAND, PoseRule.BELOW, SimpleOpenNI.SKEL_LEFT_ELBOW);
  // rules for the right leg
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_KNEE, PoseRule.BELOW, SimpleOpenNI.SKEL_RIGHT_HIP);
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_KNEE, PoseRule.RIGHT_OF, SimpleOpenNI.SKEL_RIGHT_HIP);
  // rules for the left leg
  pose.addRule(SimpleOpenNI.SKEL_LEFT_KNEE, PoseRule.BELOW, SimpleOpenNI.SKEL_LEFT_HIP);
  pose.addRule(SimpleOpenNI.SKEL_LEFT_KNEE, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_LEFT_HIP);
  pose.addRule(SimpleOpenNI.SKEL_LEFT_FOOT, PoseRule.BELOW, SimpleOpenNI.SKEL_LEFT_KNEE);
  pose.addRule(SimpleOpenNI.SKEL_LEFT_FOOT, PoseRule.RIGHT_OF, SimpleOpenNI.SKEL_LEFT_KNEE);
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_FOOT, PoseRule.BELOW, SimpleOpenNI.SKEL_RIGHT_KNEE);
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_FOOT, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_RIGHT_KNEE);   
  strokeWeight(5);
  
  
  pose1 = new SkeletonPoser(kinect);
  // rules for the right arm
  pose1.addRule(SimpleOpenNI.SKEL_RIGHT_HAND, PoseRule.ABOVE, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  pose1.addRule(SimpleOpenNI.SKEL_RIGHT_HAND, PoseRule.RIGHT_OF, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  pose1.addRule(SimpleOpenNI.SKEL_RIGHT_ELBOW, PoseRule.ABOVE, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  pose1.addRule(SimpleOpenNI.SKEL_RIGHT_ELBOW, PoseRule.RIGHT_OF, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  // rules for the left arm
  pose1.addRule(SimpleOpenNI.SKEL_LEFT_ELBOW, PoseRule.BELOW, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  pose1.addRule(SimpleOpenNI.SKEL_LEFT_ELBOW, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  pose1.addRule(SimpleOpenNI.SKEL_LEFT_HAND, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_LEFT_ELBOW);
  pose1.addRule(SimpleOpenNI.SKEL_LEFT_HAND, PoseRule.BELOW, SimpleOpenNI.SKEL_LEFT_ELBOW);
  // rules for the right leg
  pose1.addRule(SimpleOpenNI.SKEL_RIGHT_KNEE, PoseRule.BELOW, SimpleOpenNI.SKEL_RIGHT_HIP);
  pose1.addRule(SimpleOpenNI.SKEL_RIGHT_KNEE, PoseRule.RIGHT_OF, SimpleOpenNI.SKEL_RIGHT_HIP);
  // rules for the left leg
  pose1.addRule(SimpleOpenNI.SKEL_LEFT_KNEE, PoseRule.BELOW, SimpleOpenNI.SKEL_LEFT_HIP);
  pose1.addRule(SimpleOpenNI.SKEL_LEFT_KNEE, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_LEFT_HIP);
  pose1.addRule(SimpleOpenNI.SKEL_LEFT_FOOT, PoseRule.BELOW, SimpleOpenNI.SKEL_LEFT_KNEE);
  pose1.addRule(SimpleOpenNI.SKEL_LEFT_FOOT, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_LEFT_KNEE);  
  strokeWeight(5);
}

void draw() {
  background(0);
  kinect.update();
  image(kinect.depthImage(), 0, 0);

  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    int userId = userList.get(0);
    if( kinect.isTrackingSkeleton(userId)) {

      // check to see if the user
      // is in the pose
      if(pose.check(userId)){
        //if they are, set the color white
         stroke(0,0,255);
         // and start the song playing
         if(!player.isPlaying() || player1.isPlaying()){
              player.pause();
              player1.play();
         }
       }
      else if (pose1.check(userId)) {
        //if they are, set the color white
         stroke(0,0,255);
         // and start the song playing
         if(!player1.isPlaying() || player.isPlaying()){
           player1.pause();
           player.play();
      }}
     
      else {
         // otherwise set the color to red
         // and don't start the song
         stroke(255,0,0);
         player.pause();
         player1.pause();
       }
       // draw the skeleton in whatever color we chose
       drawSkeleton(userId);
    }
  }
}

void drawSkeleton(int userId) {
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
}

void drawLimb(int userId, int jointType1, int jointType2)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float  confidence;

  // draw the joint position
  confidence = kinect.getJointPositionSkeleton(userId, jointType1, jointPos1);
  confidence = kinect.getJointPositionSkeleton(userId, jointType2, jointPos2);

  line(jointPos1.x, jointPos1.y, jointPos1.z, 
  jointPos2.x, jointPos2.y, jointPos2.z);
}

void keyPressed(){
  saveFrame("project"+random(100)+".png");
}


// user-tracking callbacks!

void onNewUser(SimpleOpenNI curContext,int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  kinect.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext,int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext,int userId)
{
  println("onVisibleUser - userId: " + userId);
}

