import peasy.*;

PeasyCam cam;
float cube_w = 10;
float cube_h = 10;
float cube_d = 10;
int gridsNum = 8;
float margin = cube_d / gridsNum;

color red = color(250, 150, 150);
color green = color(150, 250, 150);
color blue = color(150, 150, 250);
color purple = color(250, 150, 250);


int red1,blue1,green1;

float degree_x, degree_y;
float radius = 200;
float rotateSpeed_X = 0.1;
float rotateSpeed_Y = 0.03;
float x_noise, y_noise;

//ArrayList<PVector> points = new ArrayList<PVector>();
//float[][] points = {{0,0}};
ArrayList<float[]> points = new ArrayList<float[]>();
float x_coord, y_coord, z_coord;



void setup() {
  size(700, 700, P3D);

  translate(width/2, height/2);

  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(300);
  cam.setMaximumDistance(2000);
}



void draw() {
  background(255);
  degree_x += (rotateSpeed_X)+noise(x_noise)-0.5;
  degree_y += (rotateSpeed_Y)+noise(y_noise)-0.5;
  red1++;
  blue1++;
  green1++;
  x_noise += random(0.1);
  y_noise += random(0.1);
  drawTrace(degree_x, degree_y);
  drawGrid();
}



void drawGrid() {

  stroke(red);
  line(x_coord, y_coord, z_coord, x_coord+cube_w, y_coord, z_coord);

  // y axis
  stroke(green);
  line(x_coord, y_coord, z_coord, x_coord, y_coord+cube_h, z_coord);

  // z axis
  strokeWeight(2);
  stroke(blue);
  line(x_coord, y_coord, z_coord, x_coord, y_coord, z_coord+cube_w);
}

void drawTrace(float degree_x, float degree_y) {
  points.add(new float[]{degree_x, degree_y});
  //println("-----");
  beginShape();
  for (float[] p : points) {

    x_coord=radius*sin(radians(p[0]))*cos(radians(p[1]));
    y_coord=radius*sin(radians(p[0]))*sin(radians(p[1]));
    z_coord=radius*cos(radians(p[0]));
    //println(x_coord, y_coord, z_coord);
    noFill();
    //stroke(red1, 0, 0);
    //point(x_coord, y_coord, z_coord);
    stroke(255,0,0,100);
    vertex(x_coord, y_coord, z_coord);
  }
  endShape();
  //println("-----");
}
