//*** Kinect Class ***///
import org.openkinect.processing.*;

int gKinectWidth  = 640;
int gKinectHeight = 480;
int lowestMin = 470;
int highestMax = 1000;

class Kinecter {
  Kinect kinect;
  boolean isKinected = false;
  boolean depthImageAsGreyscale = false;
  int thresholdRange = 8000;
  // modified and unchanged from "Juggling Molecules" Interactive Light Sculpture (c) 2011-2014 Jason Stephens, Owen Williams
  Kinecter(PApplet parent) {
    try {
      kinect = new Kinect(parent);
      kinect.initDepth();
      kinect.initVideo();
      kinect.enableIR(true);
      isKinected = true;
      println("KINECT IS INITIALISED");
    }
    catch (Throwable t) {
      isKinected = false;
      println("KINECT NOT INITIALISED");
      println(t);
    }
  }
  // modifications in "Juggling Molecules" Interactive Light Sculpture (c) 2011-2014 Jason Stephens, Owen Williams
  void updateKinect() {
    if (!isKinected) return;

    gRawDepth = kinect.getRawDepth();
    int lastPixel = gRawDepth.length;
    for (int i=0; i < lastPixel; i++) {
      int depth = gRawDepth[i];
    if (depth <= gConfig.kinectMinDepth) {
        gDepthImg.pixels[i] = color(0, 255, 0);	
        gNormalizedDepth[i] = 255;
      } 
      else if (depth >= gConfig.kinectMaxDepth) {
        gDepthImg.pixels[i] = color(0, 0, 255);
        gNormalizedDepth[i] = 0;
      } 
      else {
        int greyScale = (int) map ((float)depth, gConfig.kinectMinDepth, gConfig.kinectMaxDepth, 255, 0);
        gDepthImg.pixels[i] = (depthImageAsGreyscale ? color(greyScale) : 255);
        gNormalizedDepth[i] = 255;
      }
    }
    // update thresholded image
    gDepthImg.updatePixels();
  }
}

