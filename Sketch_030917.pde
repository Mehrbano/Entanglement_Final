/*******************************************************************
 *   Devloped by Mehrbano Khattak //view credicts 
 *   for final project of MA Computational Arts, Goldsmiths College, University of London
 **  NOTE
 *   This program is developed in Processing 2.2.1
 *   Due to some technical issues that was mentioned on the compart forum
 *   This program contains keyPressed commands from 1 to 7 for color modes
 *   and keys 'q' for particles 'w' for optic 'a' for tactile
 *  
 *******************************************************************/
 
import processing.video.*;
import processing.opengl.*;
import java.util.Iterator;

//*** GLOBAL ***//
// call all classes
MainCofig gConfig;
Kinecter gKinecter;
OpticalFlow gFlowfield;
PartiManager gPartiManager;
Tactile gTactile;
Texture gTexture;
//raw depth kinect
int[] gRawDepth;
//depth and threshold
int[] gNormalizedDepth;
//image depth
PImage gDepthImg;

//*** START PROGRAM ***//
// there is a gap of a 6sec for compiling the code
void start() {
  gConfig = new MainCofig();
}

//*** INITIALIZE ***//
void setup() {
  size (displayWidth, displayHeight, OPENGL);
  background(55, 100, 50);
  noiseSeed(gConfig.setupNoiseSeed);
  frameRate(gConfig.setupFPS);
  // initialize depth variables
  gRawDepth = new int[gKinectWidth*gKinectHeight];
  gNormalizedDepth = new int[gKinectWidth*gKinectHeight];
  gDepthImg = new PImage(gKinectWidth, gKinectHeight);
  // helpers of all classes
  gKinecter = new Kinecter(this);
  gPartiManager = new PartiManager(gConfig);
  gFlowfield = new OpticalFlow(gConfig, gPartiManager);
  gPartiManager.flowfield = gFlowfield;
  gTactile = new Tactile();
}

//*** DRAW ***//
void draw() {
  pushStyle();
  pushMatrix();
  if (gConfig.showFade) blendScreen(gConfig.fadeColor, gConfig.fadeAlpha);
  gKinecter.updateKinect();
  gFlowfield.update();
  if (gConfig.showParticles) gPartiManager.updateWithRender();
  popStyle();
  popMatrix();
}

//*** CREATE BLENDSCREEN ***//
void blendScreen (color bgColor, int opacity) {
  pushStyle(); 
  blendMode(gConfig.blendMode); 
  noStroke();
  fill(255, 100, 50, opacity);
  rect(0, 0, width, height);
 // calling tactile 
 if (gConfig.showTactile) gTactile.upGradeTactile();
  blendMode(BLEND);
  popStyle();
}

