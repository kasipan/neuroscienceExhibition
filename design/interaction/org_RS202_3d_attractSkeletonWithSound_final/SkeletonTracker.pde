public class SkeletonTracker {
  
  protected KinectPV2 kinect;
  protected ArrayList<KSkeleton> skeletonArray;
  protected ArrayList<KSkeleton> skeletonArray2;
  
  /**
   * Constuctor - call this in your setup function
   */
  SkeletonTracker(KinectPV2 _kinect) {
    kinect = _kinect;
    kinect.enableSkeletonColorMap(true);
    kinect.enableSkeleton3DMap(true);
    kinect.init();
  }
  
  /**
   * update - call this once every frame to update the joint positions
   */
  public void update() {
    skeletonArray = kinect.getSkeletonColorMap();
    skeletonArray2 =  kinect.getSkeleton3d();
  }
  
  /**
   * numTracked - returns the number of people tracked
   */
  public int numTracked(){
    return skeletonArray.size();
  }
  
  /**
   * getSkeletonIndexColor - returns the index color of the skeleton with the provided index
   */
  public color getSkeletonIndexColor(int skeletonIndex) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(skeletonIndex);
    return skeleton.getIndexColor();
  }
  
  /**
   * getJointPosition - returns the x and y positions of the given skeleton
   *                  - if there are no skeltons being tracked it returns null
   * 
   * Possible Joint types:
   *   - JointType_Head
   *   - JointType_Neck
   *   - JointType_SpineShoulder
   *   - JointType_SpineMid
   *   - JointType_SpineBase
   *   - JointType_ShoulderLeft
   *   - JointType_ElbowLeft
   *   - JointType_WristLeft
   *   - JointType_HandLeft
   *   - JointType_HandTipLeft
   *   - JointType_ThumbLeft
   *   - JointType_ShoulderRight
   *   - JointType_ElbowRight
   *   - JointType_WristRight
   *   - JointType_HandRight
   *   - JointType_HandTipRight
   *   - JointType_ThumbRight
   *   - JointType_HipLeft
   *   - JointType_KneeLeft
   *   - JointType_AnkleLeft
   *   - JointType_FootLeft
   *   - JointType_HipRight
   *   - JointType_KneeRight
   *   - JointType_AnkleRight
   *   - JointType_FootRight
   */
  public PVector getJointPosition(int skeletonIndex, int jointType) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(skeletonIndex);
    KSkeleton skeleton2 = (KSkeleton) skeletonArray2.get(skeletonIndex);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      KJoint[] joints2 = skeleton2.getJoints();
      
      return new PVector(joints[jointType].getX(), joints[jointType].getY(), joints2[jointType].getZ());
      //return new PVector(joints[jointType].getX(), joints[jointType].getY(), 0);
    }
    return null;
  }
  
  /**
   * Call this in your draw function if you want to draw the skeltons
   */
  public void drawSkeletons() {
    // iterate over all skeletons
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      if (skeleton.isTracked()) {
        KJoint[] joints = skeleton.getJoints();
  
        color col = skeleton.getIndexColor();
        fill(col);
        stroke(col);
        
        drawBody(joints);
        //draw different color for each hand state
        drawHandState(joints[KinectPV2.JointType_HandRight]);
        drawHandState(joints[KinectPV2.JointType_HandLeft]);
      }
    }
  }
  
  
  //DRAW BODY
  void drawBody(KJoint[] joints) {
    drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
    drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
    drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
    drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
    drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
    drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
    drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
    drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);
  
    // Right Arm
    drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
    drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
    drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
    drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
    drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);
  
    // Left Arm
    drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
    drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
    drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
    drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
    drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);
  
    // Right Leg
    drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
    drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
    drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);
  
    // Left Leg
    drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
    drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
    drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);
  
    drawJoint(joints, KinectPV2.JointType_HandTipLeft);
    drawJoint(joints, KinectPV2.JointType_HandTipRight);
    drawJoint(joints, KinectPV2.JointType_FootLeft);
    drawJoint(joints, KinectPV2.JointType_FootRight);
  
    drawJoint(joints, KinectPV2.JointType_ThumbLeft);
    drawJoint(joints, KinectPV2.JointType_ThumbRight);
  
    drawJoint(joints, KinectPV2.JointType_Head);
  }
  
  //draw joint
  void drawJoint(KJoint[] joints, int jointType) {
    pushMatrix();
    translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
    ellipse(0, 0, 25, 25);
    popMatrix();
  }
  
  //draw bone
  void drawBone(KJoint[] joints, int jointType1, int jointType2) {
    pushMatrix();
    translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
    ellipse(0, 0, 25, 25);
    popMatrix();
    line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
  }
  
  //draw hand state
  void drawHandState(KJoint joint) {
    noStroke();
    handState(joint.getState());
    pushMatrix();
    translate(joint.getX(), joint.getY(), joint.getZ());
    ellipse(0, 0, 70, 70);
    popMatrix();
  }
  
  /*
  Different hand state
   KinectPV2.HandState_Open
   KinectPV2.HandState_Closed
   KinectPV2.HandState_Lasso
   KinectPV2.HandState_NotTracked
   */
  void handState(int handState) {
    switch(handState) {
    case KinectPV2.HandState_Open:
      fill(0, 255, 0);
      break;
    case KinectPV2.HandState_Closed:
      fill(255, 0, 0);
      break;
    case KinectPV2.HandState_Lasso:
      fill(0, 0, 255);
      break;
    case KinectPV2.HandState_NotTracked:
      fill(255, 255, 255);
      break;
    }
  }
}
