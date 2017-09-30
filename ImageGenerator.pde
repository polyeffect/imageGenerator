/**
 *
 *KEYS
 *
 *
 *
 *
 *
 *
 *
 *
 */

import controlP5.*;
import processing.pdf.*;
import java.util.Calendar;
import java.util.*;
import org.processing.wiki.triangulate.*;
import java.awt.Frame;
import java.awt.BorderLayout;
import java.awt.image.BufferedImage;

/* variables */
//----- color -----//
color bgColor;
int H=0, S=0, B=0, SH=0, SS=0, SB=0;
int cnt= 0;
boolean isAutoSave = false;
int frameNum = 0;

PImage img;
//String imgSrc = "s3.png"; //PNG
String imgSrc = "apple.jpg"; // JPG
//String imgSrc = "1.jpeg"; // JPEG
int pointillize = 16;
int radius=5, diameter=5, zoom=-100, savePDFCnt=0;
float time=0.0;
boolean freeze=false, isBGBlack=false;
int numLoop=0;
boolean savePDF = false, isEndRecord = false;

//----- Agents -----//
Agent[] agents = new Agent[1000000]; 
int agentsCount=4000, agentsLife=1, agentsRes=3;
float noiseScale=300, noiseStrength=10, polygonScale=1, angle1, angle2, seed=0.01;
float bezierAngle=10;
float overlayAlpha=10, agentsAlpha=90, strokeAlpha=100, lumin=50, strokeWidth=0.3;
color[] c = new color[1000000];
int drawMode=1;
boolean isGrayscale=false, isBnW=false, isDark=false, isBezier=false, invertB=false, isStrokeColor=false;

//----- ocsillation -----//
int pointCount;
PVector[] prePoints = new PVector[1000000];
PVector[] lissajousPoints = new PVector[0];
float connectionRadius=10, minConnRadius=0, maxConnRadius=10;
int i1 = 0;

//----- Polygon -----//
public boolean displayMesh = false;
public boolean displayResult = false;
public java.awt.Insets insets; 
public int widthInsets;
public int heightInsets;
HashSet<Integer> chosenPointsList = new HashSet<Integer>();
ArrayList triangles = new ArrayList();
ArrayList<PVector> points = new ArrayList<PVector>();

//----- ControlP5 -----//
ControlP5 controlP5;
boolean GUI = false;
boolean guiEvent = false;
boolean showGUI = false, isHideGUI = false;
Slider[] sliders;
Toggle[] toggles;
Range[] ranges;

//----- Image output -----//
boolean saveOneFrame = false;
int qualityFactor = 3;

void setup() {
  size(1000, 1000, P2D);
  frameRate(30);
  cursor(CROSS);
  colorMode(HSB, 360, 100, 100, 100);
  img = loadImage(imgSrc);
  smooth();
  setupGUI();

  insets = frame.getInsets();
  widthInsets = insets.left + insets.right;
  heightInsets = insets.top + insets.bottom;

  points.add(new PVector(0, 0, 0));
  points.add(new PVector(img.width, 0, 0));
  points.add(new PVector(img.width, img.height, 0));
  points.add(new PVector(0, img.height, 0));
  points.add(new PVector(img.width/2, img.height/2, 0));

  for (int i=0; i<points.size(); i++) {
    int pixelInteger = int(points.get(i).y*img.width + points.get(i).x);
    chosenPointsList.add(pixelInteger);
  }
}

void draw() {
  //if (savePDF) beginRecord(PDF, timestamp() + ".pdf");

  bgColor = color(H, S, B);
  fill(bgColor, overlayAlpha);
  noStroke();
  if (!freeze)rect(0, 0, width, height);

  loadPixels();
  for (int y = 0; y < img.height; y += agentsRes) {
    for (int x = 0; x < img.width; x += agentsRes) {
      int loc = x + y * img.width;

      strokeWeight(strokeWidth * 2);
      strokeJoin(BEVEL);
      if (!isGrayscale) {
        if (!isStrokeColor) {
          stroke(img.pixels[loc], strokeAlpha);
        } else {
          stroke(SH, SS, SB);
        }
        fill(img.pixels[loc], agentsAlpha);
      } else {
        if (!isStrokeColor) stroke(map(brightness(img.pixels[loc]), 0, 100, 0, 360), strokeAlpha);
        else stroke(img.pixels[loc], strokeAlpha);
        fill(map(brightness(img.pixels[loc]), 0, 100, 0, 360), agentsAlpha);
      }

      if (isBnW) {
        noStroke(); 
        if (invertB)fill(0, 100);
        else fill(360, 100);
      }

      if (numLoop%agentsLife == 0) 
      //if (numLoop  == 0) 
        agents[loc] = new Agent(x, y);

      if (drawMode == 1) {
        if (!freeze)agents[loc].randomDirection();
      } else if (drawMode == 2) {
        if (!freeze)agents[loc].randomDirection2();
      } else if (drawMode == 3) {
        if (!freeze)agents[loc].triangleGenerate(agentsRes, polygonScale);
      } else if (drawMode == 4) {
        if (!freeze)agents[loc].hexagonGenerate(agentsRes, polygonScale);
      } else if (drawMode == 5) {
        if (!isBnW) {
          agents[loc].ellipseGenerate(polygonScale);
        } else {
          float sz =  map(brightness(img.pixels[loc]), 0, 100, 0, 360) / 360 * agentsRes;
          agents[loc].ellipseGenerateBW(sz);
        }
      } else if (drawMode == 6) {
        if (!isBnW) {
          agents[loc].rectGenerate(polygonScale);
        } else {
          float sz =  map(brightness(img.pixels[loc]), 0, 100, 0, 360) / 360 * agentsRes;
          agents[loc].rectGenerateBW(sz);
        }
      } else if (drawMode == 7) {
        if (isDark) {
          if (brightness(img.pixels[loc]) < lumin) {
            //float brightnessScale = brightness(img.pixels[loc]);
            float sz = (360 - map(brightness(img.pixels[loc]), 0, 100, 0, 360)) / 360 * agentsRes / noiseStrength;
            agents[loc].oscillationEllipseBW(polygonScale, sz);
            prePoints[pointCount] = new PVector(x, y);
            c[pointCount] = img.pixels[loc];
            if (cnt==0) pointCount++;
          }
        } else {
          if (brightness(img.pixels[loc]) > lumin) {
            float brightnessScale = brightness(img.pixels[loc]);
            agents[loc].oscillationEllipse(polygonScale, brightnessScale);
            prePoints[pointCount] = new PVector(x, y);
            c[pointCount] = img.pixels[loc];
            if (cnt==0) pointCount++;
          }
        }
      }
    }
  }

  if (drawMode == 7) {
    if (i1 == 0) {
      calculateLissajousPoints();
      i1 = 0;
    }

    while (i1 < pointCount) {
      for (int i2 = 0; i2 < i1; i2++) {
        if (isBnW) {
          if (invertB) stroke(0, strokeAlpha);
          else stroke(360, strokeAlpha);
        } else if (isGrayscale) {
          stroke(map(brightness(c[i2]), 0, 100, 0, 360), strokeAlpha);
        } else {
          if (!isStrokeColor)stroke(c[i2], strokeAlpha);
          else stroke(SH,SS,SB, strokeAlpha);
        }
        if (!isBezier) {
          drawLine(lissajousPoints[i1], lissajousPoints[i2]);
        } else {
          drawBezier(lissajousPoints[i1], lissajousPoints[i2]);
        }
      }
      i1++;
    }
    //cnt = 1;
    pointCount = 0;
    cnt = 0;
    i1 = 0;
  }

  if (drawMode == 8) {
    //noLoop();
    if (cnt == 0) {
      for (int i=0; i < 50; i++) {
        int pixelInteger = (int) random(i);
        HashSet<Integer> chosenPointsHashA = new HashSet<Integer>(chosenPointsList); 
        HashSet<Integer> chosenPointsHashB = new HashSet<Integer>(chosenPointsList);

        chosenPointsHashA.add(pixelInteger);

        if (chosenPointsHashA.size() !=chosenPointsHashB.size()) {
          points.add( new PVector((int)random(0, 1000), (int)random(0, 1000), 0));
        }
      }
    }
    ArrayList<PVector> pointsTri = new ArrayList<PVector>(points);
    triangles = Triangulate.triangulate(pointsTri);

    for (int i = 0; i < triangles.size(); i++) {
      Triangle t = (Triangle)triangles.get(i);

      int ave_x = int((t.p1.x + t.p2.x + t.p3.x)/3);
      int ave_y = int((t.p1.y + t.p2.y + t.p3.y)/3);

      //stroke(SH, SS, SB,strokeAlpha);
      stroke(img.get(ave_x, ave_y),strokeAlpha);
      fill(img.get(ave_x, ave_y), 100);
      triangle(t.p1.x, t.p1.y, t.p2.x, t.p2.y, t.p3.x, t.p3.y);
    }
    cnt=1;
  }
  numLoop++;



  if (savePDF) savePDFCnt++;
  if (savePDF && savePDFCnt == agentsLife) {
    savePDF = false;
    isEndRecord = false;
    savePDFCnt = 0;
    println("saving to pdf – finishing");
    endRecord();
  }

  //if (savePDF && isEndRecord) {
  // savePDF = false;
  // isEndRecord = false;
  // println("saving to pdf – finishing");
  // endRecord();
  //}
  
  if(isAutoSave) {
     saveFrameasImage();
  }
}

void calculateLissajousPoints() {
  if (pointCount != lissajousPoints.length - 1) {
    lissajousPoints = new PVector[pointCount+1];
  }

  for (int i = 0; i <= pointCount; i++) {
    lissajousPoints[i] = prePoints[i];
  }
}

void drawLine(PVector p1, PVector p2) {
  float d;

  d = PVector.dist(p1, p2);

  if (d >= minConnRadius && d <= maxConnRadius) {
    line(p1.x, p1.y, p2.x, p2.y);
  }
}

void drawBezier(PVector p1, PVector p2) {
  float d;

  d = PVector.dist(p1, p2);

  if (minConnRadius < d && d <= maxConnRadius) {
    noFill();
    angle1 =  sin(seed)/bezierAngle * noise(p1.x, p1.y);
    angle2 =  sin(seed)/bezierAngle * noise(p2.x, p2.y);
    bezier(p1.x, p1.y, p1.x+p1.x*angle1, p1.y+p1.y*angle1, p2.x+p2.x*angle2, p2.y+p2.y*angle2, p2.x, p2.y);
    seed+=0.1;
  }
}

void saveFrameasImage() {
  ++frameNum;
  saveFrame(frameNum +".png");
  
}

/* Interaction */
void keyPressed() {
}

void keyReleased() {
  if (key=='1') {
    drawMode = 1;
    strokeWidth = 0.3; 
    agentsRes = 3;
    overlayAlpha = 10;
  }
  if (key=='2') {
    drawMode = 2;
    strokeWidth = 0.3; 
    agentsRes = 3;
    overlayAlpha = 10;
  }
  if (key=='3') {
    drawMode = 3; 
    strokeWidth = 0; 
    agentsRes = 8;
    overlayAlpha = 255;
  }
  if (key=='4') {
    drawMode = 4;
    strokeWidth = 0; 
    agentsRes = 16;
    overlayAlpha = 255;
  }
  if (key=='5') {
    drawMode = 5;
    agentsRes = 10;
    overlayAlpha = 255;
  }
  if (key=='6') {
    drawMode = 6;
    agentsRes = 10;
    overlayAlpha = 255;
  }
  if (key=='7') {
    background(bgColor);
    drawMode = 7;
    agentsRes = 14;
    overlayAlpha = 127;
  }

  if (key=='8') {
    drawMode = 8;
    overlayAlpha = 0;
    cnt = 0;
  }
  if (key=='a' || key=='A') {
    frameNum = 0;
    isAutoSave = !isAutoSave;
  }
  if (key=='s' || key=='S') saveFrame(timestamp()+".png");// save as .png image
  if (key=='p' || key=='P') {
    savePDF = true;
    beginRecord(PDF, timestamp() + ".pdf");
  }
  if (key=='e' || key=='E') {
    //isEndRecord = true;
    endRecord();
  }
  if (key=='f' || key=='F') freeze = !freeze; // pause/play
  if (key=='b' || key=='B') isBGBlack = !isBGBlack;
  if (key=='v' || key=='V') isBezier = !isBezier;

  if (key == DELETE || key == BACKSPACE) background(bgColor);
  if (key==' ') {
    int newNoiseSeed = (int) random(100000);
    noiseSeed(newNoiseSeed);
  }

  if (key=='m' || key=='M') { // show/hide menu
    showGUI = controlP5.getGroup("menu").isOpen();
    showGUI = !showGUI;
  }

  if (showGUI) controlP5.getGroup("menu").open();
  else controlP5.getGroup("menu").close();

  if (key=='h' || key=='H') {
    isHideGUI = !isHideGUI;
  }

  if (isHideGUI) hideGUI();
  else drawGUI();
}

void mousePressed() {
  if (drawMode == 7) {
    //pointCount = 0;
    //cnt = 0;
    //i1 = 0;
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}