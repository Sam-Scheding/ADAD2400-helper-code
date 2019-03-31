/*
  A Perlin Noise visualiser based on code from Daniel Shiffman for perlin noise generation
  and slider code from Ben Lang
*/
// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/IKB1hWWedMk

int cols, rows;
int scl = 20;
int w = 2000;
int h = 1600;
//xvals:

float noiseVal = 0.4;
Slider noise;
Slider detail;
Slider falloff;

ArrayList<Slider> sliders;
float[][] terrain;

void setup() {
  size(800, 600, P3D);
  cols = w / scl;
  rows = h/ scl;
  terrain = new float[cols][rows];

  sliders = new ArrayList<Slider>(); // The sliders get added to this when they are created. It's purely for convenience in mouseDragged()
  noise = new Slider(30, 180, "Noise");
  detail = new Slider(250, 400, "Detail");
  falloff = new Slider(470, 620, "Fall Off");
}


void draw() {

  background(0);
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(x * noiseVal, y * noiseVal), 0, 1, -100, 100);
    }
  }
  
  
  int detailVal = (int)map(float(detail.pos), float(detail.start), float(detail.end), 1, 8);
  float falloffVal = map(float(falloff.pos), float(falloff.start), float(falloff.end), 0.1, 1);
  noiseVal = map(float(noise.pos), float(noise.start), float(noise.end), 0, 1);  


  // Draw each of the sliders
  noise.show();
  detail.show();
  falloff.show();

  // Add the slider vals to the terrain
  noiseDetail(detailVal, falloffVal);  


  // Draw the terrain
  noFill();
  translate(width/2, height/2+50);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vertex(x*scl, y*scl, terrain[x][y]);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }
  
  
}


class Slider {

  int pos, start, end;
  int y = 50;
  String name;
  Slider(int start, int end, String name) {
    this.start = start;
    this.end = end;
    this.pos = start;    
    this.name = name;
    sliders.add(this);
  }

  void show() {
    // Draw the label
    fill(255);
    text(this.name, start+(end-start)/2, y-20);
    // Draw the slider    
    rectMode(CENTER);
    stroke(255);
    line(start, y, end, y);
    fill(255, 105, 180);
    rect(pos, y, 15, 15);
  }  

  boolean hover() {
    if (mouseX > start && mouseX < end) {
      if (mouseY > y-10 && mouseY < y+10) {
        return true;
      }
      return false;
    }
    return false;
  }
}


void mouseDragged() {
  //if mouse is over any of the sliders
  for (Slider s : sliders) {
    if (s.hover()) {
      s.pos = mouseX;
    }
    constrain(s.pos, s.start, s.end); //slider pos must be within the minimum and maximum
  }
}
