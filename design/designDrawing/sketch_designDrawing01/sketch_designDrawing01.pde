import peasy.*;

PeasyCam cam;
float cube_w = 80;
float cube_h = 80;
float cube_d = 80;
int gridsNum = 8;
float margin = cube_d / gridsNum;
float degree_x, degree_y;
float radius = 200;
float speed = 0.25;
color red = color(250, 150, 150);
color green = color(150, 250, 150);
color blue = color(150, 150, 250);
color purple = color(250, 150, 250);


void setup() {
  size(700, 700, P3D);

  translate(width/2, height/2);

  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(300);
  cam.setMaximumDistance(2000);
}



void draw() {
  background(150);

  noFill();
  stroke(255, 255, 255, 30);
  sphere(radius);

  degree_x += speed;
  degree_y += speed;
  drawGrid(degree_x, degree_y);
}



void drawGrid(float degree_x, float degree_y) {
  pushMatrix();
  rotateX(radians(degree_x));
  rotateY(radians(degree_y));  
  translate(0, 0, radius);
  noFill();
  stroke(255, 255, 255);
  for (int i=0; i<=gridsNum; i++) {
    beginShape();
    stroke(red);
    vertex(-cube_w/2, -cube_h/2, i*margin-cube_w/2);
    stroke(green);
    vertex(cube_w/2, -cube_h/2, i*margin-cube_w/2);
    stroke(blue);
    vertex(cube_w/2, cube_h/2, i*margin-cube_w/2);
    stroke(purple);
    vertex(-cube_w/2, cube_h/2, i*margin-cube_w/2);
    endShape(CLOSE);

    stroke(255);
    beginShape();
    stroke(green);
    vertex(i*margin-cube_w/2, -cube_h/2, -cube_w/2);
    stroke(purple);
    vertex(i*margin-cube_w/2, cube_h/2, -cube_w/2);
    stroke(blue);
    vertex(i*margin-cube_w/2, cube_h/2, cube_w/2);
    stroke(red);
    vertex(i*margin-cube_w/2, -cube_h/2, cube_w/2);
    endShape(CLOSE);


    beginShape();
    stroke(red);
    vertex(-cube_w/2, i*margin-cube_w/2, -cube_w/2);
    stroke(purple);
    vertex(-cube_w/2, i*margin-cube_w/2, cube_w/2);
    stroke(blue);
    vertex(cube_w/2, i*margin-cube_w/2, cube_w/2);
    stroke(green);
    vertex(cube_w/2, i*margin-cube_w/2, -cube_w/2);
    endShape(CLOSE);
    //fill(20);
    //box(cube_w);
  }

  // human
  stroke(255);
  rotateY(-radians(degree_y));
  rotateX(-radians(degree_x));
  fill(0, 0, 0, 50);
  box(7, 30, 7);

  popMatrix();
}
