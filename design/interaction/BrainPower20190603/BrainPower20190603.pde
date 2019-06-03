import toxi.geom.*;
import toxi.physics3d.*;
import toxi.physics3d.behaviors.*;
import toxi.physics3d.constraints.*;
import toxi.processing.*;
import processing.sound.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
String viewerIP = "172.20.10.8";    // Viewer's IP

int spacing=100;
int edgeLength=1400;
int cols, rows;
int PARTICLE_COUNT=0;
int boxCounter;
float cutoff = 0;
int move;
int boxStart;
boolean moving = true;

Vec3D headCoord;
VerletPhysics3D physics;
VerletParticle3D particles;
Vec3D attractPos1;
//Vec3D attractPos2;
//Vec3D attractPos3;

AttractionBehavior3D attractor1;
//AttractionBehavior3D attractor2;
//AttractionBehavior3D attractor3;

//int[] numbers = new int[3];
//PVector[] r_hand = new PVector[4]; 
//PVector[] s_shoulder = new PVector[4]; 
//PVector[] l_hand = new PVector[4]; 
//ArrayList<PVector> r_hand = new ArrayList<PVector>();

PVector performersIndex = new PVector(-edgeLength*0.5, -edgeLength*0.1, -edgeLength*0.1);

void setup() {
  size(1000, 800, P3D);
  frameRate(12);
  //fullScreen(P3D, 2);
  smooth();

  // box counter for extra box
  boxCounter =3;
  move=0;
  boxStart = 0;
  physics = new VerletPhysics3D();

  // number of columns and rows
  cols = edgeLength/spacing+1;
  rows = edgeLength/spacing+1;

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
      VerletParticle3D p2 = new VerletParticle3D(-edgeLength/2 + i*spacing, -edgeLength/2, -edgeLength/2+ j*spacing );
      physics.addParticle(p2);
      physics.addBehavior(new AttractionBehavior3D(p2, 50, -1.2f, 1f));
      if (i == 0 || i==cols-1 || j==0 || j==rows-1 ) {
        p2.lock();
      }
    }
  }

  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      VerletParticle3D p3 = new VerletParticle3D(-edgeLength/2, -edgeLength/2 + i*spacing, -edgeLength/2+ j*spacing );
      physics.addParticle(p3);
      physics.addBehavior(new AttractionBehavior3D(p3, 50, -1.2f, 1f));
      if (i == 0 || i==cols-1 || j==0 || j==rows-1 ) {
        p3.lock();
      }
    }
  }

  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      VerletParticle3D p4 = new VerletParticle3D(edgeLength/2, -edgeLength/2 + i*spacing, -edgeLength/2+ j*spacing );
      physics.addParticle(p4);
      physics.addBehavior(new AttractionBehavior3D(p4, 50, -1.2f, 1f));
      if (i == 0 || i==cols-1 || j==0 || j==rows-1 ) {
        p4.lock();
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

        physics.addSpring(sp);
        physics.addSpring(sp2);
      }
    }
  }

  // OSC setup
  oscP5 = new OscP5(this, 9999);
}




void draw() {
  background(0);
  noFill();
  stroke(255);
  strokeWeight(1);
  translate(width/2, height/2 -100, move);
  scale(-1, 1, 1);
  if (moving)
  {
    if (mouseY > height/2)
    {
      move+=10;
    } else
    {
      move-=10;
    }
  }
  if (move%400 == 0)
  {
    boxCounter++;
    println(boxCounter);
  }
  if (boxCounter%10 == 0)
  {
    boxStart++;
  }

  pushMatrix();
  translate(performersIndex.x, performersIndex.y, performersIndex.z);  //50 is offset
  updateAttraction();
  popMatrix();
  noFill();

  for (int i=2; i<= boxCounter; i++) {
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
    //point(vp.x, vp.y, vp.z);
  }
  for (int i = 0; i < physics.springs.size(); i ++) {
    VerletSpring3D sp = (VerletSpring3D) physics.springs.get(i);
    stroke(255);
    strokeWeight(1);
    line(sp.a.x, sp.a.y, sp.a.z, sp.b.x, sp.b.y, sp.b.z);
  }
  popMatrix();
}

// for Debug
void updateAttraction() {
  showAttractors();
  
  if (attractPos1 == null) {
    println("setup attraction");
    attractPos1 = new Vec3D((mouseX-width/2), (mouseY), 0+(mouseY -height/2)); 
    attractor1 = new AttractionBehavior3D(attractPos1, 500, -150);
    physics.addBehavior(attractor1);

    //attractPos2 = new Vec3D((s_shoulder[i].x-width/2), (s_shoulder[i].y -height/2), 0+(s_shoulder[i].y -height/2)); 
    //attractor2 = new AttractionBehavior3D(attractPos2, 800, 100);
    //physics.addBehavior(attractor2);

    //attractPos3 = new Vec3D((l_hand[i].x-width/2), (l_hand[i].y ), 0+(l_hand[i].y -height/2)); 
    //attractor3 = new AttractionBehavior3D(attractPos3, 500, -100);
    //physics.addBehavior(attractor3);
  } else {
    //updateing
    attractPos1.set((mouseX-width/2), (mouseY), 0+(mouseY -height/2));
    //attractPos2.set((s_shoulder[i].x-width/2), (s_shoulder[i].y -height/2), 0+(s_shoulder[i].y -height/2));
    //attractPos3.set((l_hand[i].x-width/2), (l_hand[i].y), 0+(l_hand[i].y -height/2));
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


//////// Sending Interation Data to the Sphere Viewer /////////
void sendInteractedPoints(String text){
  
  NetAddress location = new NetAddress(viewerIP, 2345);
  
  OscMessage message = new OscMessage("/");
  message.add(text);
  oscP5.send(message, location);
}



//////// DEBUG ////////
void showAttractors() {
  // checking attraction points
  pushMatrix();
  translate((mouseX), (mouseY), 0+(mouseY -height/2));
  fill(250, 0, 0);
  sphere(400);
  popMatrix();
}

void keyPressed() {
  moving = !moving;
  sendInteractedPoints("Right");
}
