import toxi.geom.*;
import toxi.physics3d.*;
import toxi.physics3d.behaviors.*;
import toxi.physics3d.constraints.*;
import toxi.processing.*;
import processing.sound.*;
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;
SkeletonTracker skeletonTracker;

WhiteNoise noise;
LowPass lowPass;

int spacing=70;
int edgeLength=1400;
int cols, rows;
int PARTICLE_COUNT=0;
int boxCounter;
float cutoff = 0;
final Boolean DEBUG_MODE = false;  // for showing skeletons

Vec3D headCoord;
VerletPhysics3D physics;
VerletParticle3D particles;
Vec3D attractPos1;
Vec3D attractPos2;
Vec3D attractPos3;


AttractionBehavior3D attractor1;
AttractionBehavior3D attractor2;
AttractionBehavior3D attractor3;

int[] numbers = new int[3];

PVector[] r_hand = new PVector[4]; 
PVector[] s_shoulder = new PVector[4]; 
PVector[] l_hand = new PVector[4]; 
//ArrayList<PVector> r_hand = new ArrayList<PVector>();

PVector performersIndex = new PVector(-edgeLength*0.5, -edgeLength*0.1, -edgeLength*0.1);

void setup() {
  size(1000, 800, P3D);
  //fullScreen(P3D, 2);
  smooth();
  boxCounter =0;
  physics = new VerletPhysics3D();

  kinect = new KinectPV2(this);
  skeletonTracker = new SkeletonTracker(kinect);

  cols = edgeLength/spacing+1;
  rows = edgeLength/spacing+1;


  noise = new WhiteNoise(this);
  lowPass = new LowPass(this);

  noise.play(0.5);
  lowPass.process(noise);

  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      VerletParticle3D p1 = new VerletParticle3D(-edgeLength/2 + i*spacing, edgeLength/2, -edgeLength/2+ j*spacing );
      physics.addParticle(p1);
      physics.addBehavior(new AttractionBehavior3D(p1, 50, -1.2f, 1f));
      if (i == 0 || i==cols-1 || j==0 || j==rows-1 ) {
        p1.lock();
      }
    }
  }


  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      VerletParticle3D p1 = new VerletParticle3D(-edgeLength/2 + i*spacing, -edgeLength/2, -edgeLength/2+ j*spacing );
      physics.addParticle(p1);
      physics.addBehavior(new AttractionBehavior3D(p1, 50, -1.2f, 1f));
      if (i == 0 || i==cols-1 || j==0 || j==rows-1 ) {
        p1.lock();
      }
    }
  }

  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      VerletParticle3D p1 = new VerletParticle3D(-edgeLength/2, -edgeLength/2 + i*spacing, -edgeLength/2+ j*spacing );
      physics.addParticle(p1);
      physics.addBehavior(new AttractionBehavior3D(p1, 50, -1.2f, 1f));
      if (i == 0 || i==cols-1 || j==0 || j==rows-1 ) {
        p1.lock();
      }
    }
  }

  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      VerletParticle3D p1 = new VerletParticle3D(edgeLength/2, -edgeLength/2 + i*spacing, -edgeLength/2+ j*spacing );
      physics.addParticle(p1);
      physics.addBehavior(new AttractionBehavior3D(p1, 50, -1.2f, 1f));
      if (i == 0 || i==cols-1 || j==0 || j==rows-1 ) {
        p1.lock();
      }
    }
  }

  int wallCount = 4;
  int particlesPerWall = cols*cols;
  PARTICLE_COUNT = physics.particles.size();

  for (int j=0; j < wallCount; j++)
  {
    for (int i =0; i<particlesPerWall; i++) {

      int[] xy = i2xy(i, cols);
      int x = xy[0];
      int y = xy[1];

      if (x < cols - 1 && y < rows -1)
      {
        int nextX = x+1;
        int nextY = y+1;

        int nextX_i = xy2i(nextX, y, cols);
        int nextY_i = xy2i(x, nextY, cols);

        int index = particlesPerWall*j + i;
        int nextX_index = particlesPerWall*j + nextX_i;
        int nextY_index = particlesPerWall*j + nextY_i;

        VerletParticle3D vp1 = (VerletParticle3D) physics.particles.get(index);
        VerletParticle3D vp2 = (VerletParticle3D) physics.particles.get(nextX_index);
        VerletParticle3D vp3 = (VerletParticle3D) physics.particles.get(nextY_index);

        VerletSpring3D sp = new VerletSpring3D(vp1, vp2, 10, 0.05);
        VerletSpring3D sp2 = new VerletSpring3D(vp1, vp3, 10, 0.05);
        VerletSpring3D sp3 = new VerletSpring3D(vp2, vp3, 10, 0.1);

        physics.addSpring(sp);
        physics.addSpring(sp2);
        physics.addSpring(sp3);
      }
    }
  }
}

int[] i2xy(int i, int _width) {
  int x = i%_width;
  int y = i/_width;
  return new int[]{x, y};
}
int xy2i(int x, int y, int _width) {
  return y*_width +x;
}

void applyG(float y) {
  Vec3D vg = new Vec3D(0, y, 0 );
  GravityBehavior3D g = new GravityBehavior3D(vg);
  physics.addBehavior(g);
}

void extendedBox(int BoxLength) {
  for (int r =0; r<4; r++) {
    rotateZ(HALF_PI*(r%4));
    for (int x=0; x<cols; x++) {
      stroke(255);
      strokeWeight(0.7);
      line(-BoxLength/2+spacing*x, -BoxLength/2, -BoxLength/2, -BoxLength/2+spacing*x, -BoxLength/2, -BoxLength/2-spacing*(cols-1));
      line(-BoxLength/2, -BoxLength/2, -BoxLength/2-spacing*x, BoxLength/2, -BoxLength/2, -BoxLength/2-spacing*x);
    }
  }
}

void draw() {
  background(0);
  noFill();
  stroke(255);
  strokeWeight(1);
  translate(width/2, height/2 -100, -600);
  scale(-1, 1, 1);
  skeletonTracker.update();
  pushMatrix();
  translate(performersIndex.x, performersIndex.y, performersIndex.z);  //50 is offset
  updateAttraction();

  if (DEBUG_MODE) skeletonTracker.drawSkeletons();
  popMatrix();
  noFill();
  
  for (int i=0; i<= boxCounter; i++) {
    virtualBB(i, -i*edgeLength);
  }

  physics.update();
  applyG(-0.001);
}


void virtualBB(int index, int translate) {
  pushMatrix();
  rotateZ(HALF_PI*(index%4));
  translate(0, 0, translate);
  box(edgeLength);
  for (int i=0; i<PARTICLE_COUNT; i++) {
    VerletParticle3D vp = (VerletParticle3D) physics.particles.get(i);
    strokeWeight(5);
    if (vp.isLocked()) {
      stroke(0, 255, 200);
    } else {
      stroke(0, 255, 200);
    }
    point(vp.x, vp.y, vp.z);
  }
  for (int i = 0; i < physics.springs.size(); i ++) {
    VerletSpring3D sp = (VerletSpring3D) physics.springs.get(i);
    stroke(255);
    strokeWeight(1);
    line(sp.a.x, sp.a.y, sp.a.z, sp.b.x, sp.b.y, sp.b.z);
  }
  popMatrix();
}
void updateAttraction() {
  for (int i = 0; i < skeletonTracker.numTracked(); i++) {
    r_hand[i] = skeletonTracker.getJointPosition(i, KinectPV2.JointType_HandRight);
    s_shoulder[i] = skeletonTracker.getJointPosition(i, KinectPV2.JointType_SpineShoulder);
    l_hand[i] = skeletonTracker.getJointPosition(i, KinectPV2.JointType_HandLeft);
    if (r_hand != null) {  // if someone apprears

      if (DEBUG_MODE) {
        showAttractors(i);
      }

      // make sound based on right hand
      cutoff = map(r_hand[i].y, 0, 1000, 10000, 20);
      lowPass.freq(cutoff);


      if (attractPos1 == null) {
        println("setup attraction");
        attractPos1 = new Vec3D((r_hand[i].x-width/2), (r_hand[i].y), 0+(r_hand[i].y -height/2)); 
        attractor1 = new AttractionBehavior3D(attractPos1, 500, -150);
        physics.addBehavior(attractor1);

        attractPos2 = new Vec3D((s_shoulder[i].x-width/2), (s_shoulder[i].y -height/2), 0+(s_shoulder[i].y -height/2)); 
        attractor2 = new AttractionBehavior3D(attractPos2, 800, 100);
        physics.addBehavior(attractor2);

        attractPos3 = new Vec3D((l_hand[i].x-width/2), (l_hand[i].y ), 0+(l_hand[i].y -height/2)); 
        attractor3 = new AttractionBehavior3D(attractPos3, 500, -100);
        physics.addBehavior(attractor3);
      } else {
        //updateing
        attractPos1.set((r_hand[i].x-width/2), (r_hand[i].y), 0+(r_hand[i].y -height/2));
        attractPos2.set((s_shoulder[i].x-width/2), (s_shoulder[i].y -height/2), 0+(s_shoulder[i].y -height/2));
        attractPos3.set((l_hand[i].x-width/2), (l_hand[i].y), 0+(l_hand[i].y -height/2));
      }
    }
  }
}

void showAttractors(int i) {
  pushMatrix();
  translate(r_hand[i].x, r_hand[i].y, r_hand[i].z);
  fill(250, 0, 0);
  box(50);
  popMatrix();

  pushMatrix();
  translate(s_shoulder[i].x, s_shoulder[i].y, s_shoulder[i].z);
  fill(0, 250, 0);
  box(50);
  popMatrix();

  pushMatrix();
  translate(l_hand[i].x, l_hand[i].y, l_hand[i].z);
  fill(0, 0, 250);
  box(50);
  popMatrix();


  /////// these are the other limbs point attraction ////// 
  //println(map(r_hand[i].z, 0, 5, edgeLength, -10));
  //// checking attraction points
  //pushMatrix();
  //translate((r_hand[i].x-width/2), (r_hand[i].y), 0+(r_hand[i].y -height/2));
  //fill(250, 0, 0);
  //sphere(40);
  //popMatrix();

  //pushMatrix();
  //translate((s_shoulder[i].x-width/2), (s_shoulder[i].y -height/2), 0+(s_shoulder[i].y -height/2));
  //fill(0, 250, 0);
  //sphere(40);
  //popMatrix();

  //pushMatrix();
  //translate((l_hand[i].x-width/2), (l_hand[i].y), 0+(l_hand[i].y -height/2));
  //fill(0, 0, 250);
  //sphere(40);
  //popMatrix();
}

void keyPressed(){
boxCounter++;
}
