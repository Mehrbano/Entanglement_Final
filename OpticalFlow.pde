//*** Optical Flow Class ***//
// This class is optic flow
// It is activated by keypress "w"
// Same, modified and added syntax to HIDETOSHI'S OPTICAL FLOW

class OpticalFlow {
  MainCofig config;
  PartiManager particles;
  PVector[][] field;
  int cols, rows;
  int life;
  int resolve; 
  int size;
  float df; //difference
  float[] fx, fy, ft;   // regression
  // same calculation as HIDETOSHI'S OPTICAL FLOW
  int regVector = 3*9; // regression vector length
  // internal variables
  float[] dtr;         // average grid values differentiation by t 
  float[] dxr;         // x 
  float[] dyr;         // y 
  float[] dar;         // a
  float[] flowx, flowy;     // computed optical flow
  float[] sflowx, sflowy;   // changing of flow

  OpticalFlow(MainCofig _config, PartiManager _particles) {
    config = _config;
    particles = _particles;
    resolve = config.setupFlowFieldResolution;
    cols = gKinectWidth/resolve;
    rows = gKinectHeight/resolve;
    field = makePerlinNoiseField (rows, cols);
    size = resolve * 2;
    life = 1*gConfig.flowLineAlpha;
    // create array of variables
    dar = new float[cols*rows];
    dtr = new float[cols*rows];
    dxr = new float[cols*rows];
    dyr = new float[cols*rows];
    flowx = new float[cols*rows];
    flowy = new float[cols*rows];
    sflowx = new float[cols*rows];
    sflowy = new float[cols*rows];
    // regression vectors
    fx = new float[regVector];
    fy = new float[regVector];
    ft = new float[regVector];
    //call
    update();
  }

  void update() {
    sweepOne();
    sweepTwo();
    solveFlow();
  }
  // rectangle area calculate
  float PixelsGrayscale(int x1, int y1, int x2, int y2) {
    if (x1 < 0)          x1 = 0;
    if (x2 >= gKinectWidth)    x2 = gKinectWidth - 1;
    if (y1 < 0)          y1 = 0;
    if (y2 >= gKinectHeight)  y2 = gKinectHeight - 1;
    float sum = 0.0;
    for (int y = y1; y <= y2; y++) {
      for (int i = gKinectWidth * y + x1; i <= gKinectWidth * y+x2; i++) {
        sum += gNormalizedDepth[i];
      }
    }
    int numPixel = (x2-x1+1) * (y2-y1+1); // number of pixels
    return sum / numPixel;
  }

  // extract values from 9 neighbour grids
  void getNeigboringPixels(float x[], float y[], int i, int j) {
    y[j+0] = x[i+0];
    y[j+1] = x[i-1];
    y[j+2] = x[i+1];
    y[j+3] = x[i-cols];
    y[j+4] = x[i+cols];
    y[j+5] = x[i-cols-1];
    y[j+6] = x[i-cols+1];
    y[j+7] = x[i+cols-1];
    y[j+8] = x[i+cols+1];
  }

  void solveFlowIndex(int index) {
    float xx, xy, yy, xt, yt;
    float a, u, v, w;
    // covering area
    xx = xy = yy = xt = yt = 0.0;
    for (int i = 0; i < regVector; i++) {
      xx += fx[i]*fx[i];
      xy += fx[i]*fy[i];
      yy += fy[i]*fy[i];
      xt += fx[i]*ft[i];
      yt += fy[i]*ft[i];
    }
    // least computation
    a = xx*yy - xy*xy + config.flowfieldRegularization;
    u = yy*xt - xy*yt; // x direction
    v = xx*yt - xy*xt; // y direction
    // optical flow x (pixel per frame)    
    flowx[index] = -2*resolve*u/a; 
    flowy[index] = -2*resolve*v/a; 
  }

  void sweepOne() {
    for (int col = 0; col < cols; col++) {
      int x0 = col * resolve + resolve/2;
      for (int row = 0; row < rows; row++) {
        int y0 = row * resolve + resolve/2;
        int index = row * cols + col;
        // compute average pixel
        float avg = PixelsGrayscale (x0-size, y0-size, x0+size, y0+size);
        // compute time difference
        dtr[index] = avg - dar[index]; 
        // save the pixel
        dar[index] = avg;
      }
    }
  }

  void sweepTwo() {
    for (int col = 1; col < cols-1; col++) {
      for (int row = 1; row<rows-1; row++) {
        int index = row * cols + col;
        // compute x difference
        dxr[index] = dar[index+1] - dar[index-1];
        // compute y difference
        dyr[index] = dar[index+cols] - dar[index-cols];
      }
    }
  }

  // solve optic flow
  void solveFlow() {
    // get time distance between frames at current time
    df = config.flowfieldPredictionTime * config.setupFPS;
    // for kinect to window size mapping below
    float normalizedKinectWidth   = 1.0f / ((float) gKinectWidth);
    float normalizedKinectHeight  = 1.0f / ((float) gKinectHeight);
    float kinectToWindowWidth  = ((float) width) * normalizedKinectWidth;
    float kinectToWindowHeight = ((float) height) * normalizedKinectHeight;

    for (int col = 1; col < cols-1; col++) {
      int x0 = col * resolve + resolve/2;
      for (int row = 1; row < rows-1; row++) {
        int y0 = row * resolve + resolve/2;
        int index = row * cols + col;
        // neighboring pixel
        getNeigboringPixels(dxr, fx, index, 0); 
        getNeigboringPixels(dyr, fy, index, 0); 
        getNeigboringPixels(dtr, ft, index, 0); 
        // smoothing
        solveFlowIndex (index);
        sflowx[index] += (flowx[index] - sflowx[index]) * config.flowfieldSmoothing;
        sflowy[index] += (flowy[index] - sflowy[index]) * config.flowfieldSmoothing;
        // angular distance of vector
        float u = df * sflowx[index];
        float v = df * sflowy[index];
        float a = sqrt(u * u + v * v);
        // register new vector
        if (a >= gConfig.flowfieldMinVelocity) {
          field[col][row] = new PVector(u, v);
          // showFlowLines
          if (config.showFlowLines) {
            float startX = width - (((float) x0) * kinectToWindowWidth);
            float startY = ((float) y0) * kinectToWindowHeight;
            float endX   = width - (((float) (x0+u+life)) * kinectToWindowWidth);
            float endY   = ((float) (y0+v+life)) * kinectToWindowHeight;
            //LINE
            stroke(random(0,255), 20, 30, gConfig.flowLineAlpha);
            line(startX, startY, endX, endY);
            //DOT
            fill (#6AFA05, gConfig.flowLineAlpha); 
            rect (startX-1, startY-1, 2, 2);
          }

          // same syntax as memo's fluid solver (http://memo.tv/msafluid_for_processing)
          float normalizedX = (x0+u) * normalizedKinectWidth;
          float normalizedY = (y0+v) * normalizedKinectHeight;
          float velocityX  = ((x0+u) - x0) * normalizedKinectWidth;
          float velocityY  = ((y0+v) - y0) * normalizedKinectHeight;
          particles.addParticlesForForce(1-normalizedX, normalizedY, -velocityX, velocityY);
        }
      }
    }
  }
// same syntax as "Juggling Molecules" (c) 2011-2014 Jason Stephens, Owen Williams
  PVector lookup(PVector worldLocation) {
    int i = (int) constrain(worldLocation.x / resolve, 0, cols-1);
    int j = (int) constrain(worldLocation.y / resolve, 0, rows-1);
    return field[i][j].get();
  }
}
//***PERLIN***//
PVector[][] makePerlinNoiseField (int rows, int cols) {  
  PVector[][] field = new PVector[cols][rows];
  float xOffset = 0;
  for (int col = 0; col < cols; col++) {
    float yOffset = 0;
    for (int row = 0; row < rows; row++) {
      float theta = map (noise (xOffset, yOffset), 0, 500, 0, TWO_PI);
      field[col][row] = new PVector(cos(theta+theta), sin(random(theta)), cos(-theta));
      yOffset += 0.1;
    }
    xOffset += 0.1;
  }
  return field;
}

