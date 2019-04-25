import peasy.*;

PeasyCam cam;
float cube_w = 80;
float cube_h = 80;
float cube_d = 80;
int gridsNum = 8;
float margin = cube_d / gridsNum;

color red = color(250, 150, 150);
color green = color(150, 250, 150);
color blue = color(150, 150, 250);
color purple = color(250, 150, 250);

float degree_x, degree_y;
float radius = 200;
float speed = 0;
float x_noise, y_noise;

//ArrayList<PVector> points = new ArrayList<PVector>();
//float[][] points = {{0,0}};
ArrayList<float[]> points = new ArrayList<float[]>();



void setup() {
  size(700, 700, P3D);

  translate(width/2, height/2);

  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(300);
  cam.setMaximumDistance(2000);
}



void draw() {
  background(150);

  //noFill();
  //stroke(255, 255, 255, 30);
  //sphere(radius);

  degree_x += speed+noise(x_noise)-0.5;
  degree_y += speed+noise(y_noise)-0.5;
  x_noise += random(0.1);
  y_noise += random(0.1);
  drawGrid(degree_x, degree_y);
  drawLine(degree_x, degree_y);
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


void drawLine(float degree_x, float degree_y){
  //float[][] f = {{degree_x, degree_y}};
  points.add(new float[]{degree_x, degree_y});
  //println("-----");
  //beginShape();
  for (float[] p : points) {
    //println(p);
    
    pushMatrix();
    rotateX(radians(p[0]));  //degree_x
    rotateY(radians(p[1]));  //degree_y
    translate(0, 0, radius);
    fill(255);
    stroke(255);
    box(1);
    //vertex(0,0,0);
    popMatrix();

  }
  //endShape();
  //println("-----");

}
