//*** Tactile Class***//
// This class is a pattern class, it is activated by keypress "a"
// It is used in void blendScreen in the main sketch for create ambience
// The image used in this class is a screen shot of particle

int DIM, NUMTRI; 
PImage img; 

class Tactile {
  MainCofig config;
  OpticalFlow flowfield;
  PartiManager particles;

Tactile () {
    img = loadImage("8.png"); 
    textureMode(NORMAL); 
    noStroke();
  }

  void upGradeTactile() {
      DIM = (int) map(0, 10, 0, 0, 40); // set DIM in the range from 1 to 40 according to mouseX
      NUMTRI = DIM*DIM; // calculate the total number of cells in the grid
      beginShape(TRIANGLE); // draw a Shape of QUADS
      blendMode(gConfig.fadeAlpha); 
      texture(img); // use the image as a texture
      // draw all the QUADS in the grid...
      for (int i=0; i<NUMTRI; i++) {
        drawTact(i, int(i+noise(i+frameRate*0.001)*TWO_PI)%NUMTRI);
      }
      endShape();
    }
  
  void drawTact(int indexPos, int indexTex) {
    // calculate the position of the vertices
    float x1 = float(indexPos%DIM)/DIM*width;
    float y1 = float(indexPos/DIM)/DIM*height;
    float x2 = float(indexPos%DIM+1)/DIM*width;
    float y2 = float(indexPos/DIM+1)/DIM*height;
    // calculate the texture coordinates
    float x1Tex = float(indexTex%DIM)/DIM;
    float y1Tex = float(indexTex/DIM)/DIM;
    float x2Tex = float(indexTex%DIM+1)/DIM;
    float y2Tex = float(indexTex/DIM+1)/DIM;
    // use the above calculations for 4 vertex() calls
    vertex(x1, y1, x1Tex, y1Tex);
    vertex(x2, y1, x2Tex, y1Tex);
    vertex(x2, y2, x2Tex, y2Tex);
    vertex(x1, y2, x1Tex, y2Tex);
  }
}

