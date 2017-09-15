//*** Main Configeration Class **//
// Global color
int PARTICLE_COLOR_SCHEME_XY= 1;
class MainCofig {
MainCofig() {
 }
  int setupWindowWidth = 640;
  int setupWindowHeight = 480;
  // framerate
  int setupFPS = 60;
  //noise
  int setupNoiseSeed = 26103;
  // blend mode
  int blendMode = BLEND;
  // booleans
  boolean showParticles = true;
  boolean showFlowLines = false;
  boolean showDepthImage = false;
  boolean showNoise = true;
  boolean showFade = true;
  boolean showTactile = false;
  // fade effect - min and max gives better fade effect
  int fadeAlpha = 15;
  int MIN_fadeAlpha = 0;
  int MAX_fadeAlpha = 255;
  color fadeColor = color(0, 155);

  //*** KINECT ***//
  // kinect setup minimum
  int kinectMinDepth = 100;
  int MIN_kinectMinDepth = 0;
  int MAX_kinectMinDepth = 3000;
  // kinect setup maximum
  int kinectMaxDepth = 950;
  int MIN_kinectMaxDepth = 0;
  int MAX_kinectMaxDepth = 2047;
  
  //*** OPTICAL FLOW ***//
  // resolution
  int setupFlowFieldResolution = 5;
  // comput flow
  float flowfieldPredictionTime = 1.5;
  float MIN_flowfieldPredictionTime = .1;
  float MAX_flowfieldPredictionTime = 2.5;
  // velocity
  int flowfieldMinVelocity = 10; //by increasing this the flow of optic is made far apart 
  int MIN_flowfieldMinVelocity = 1;
  // regression least squares computed
  float flowfieldRegularization = pow (-10, 8); 
  float MIN_flowfieldRegularization = 0;
  float MAX_flowfieldRegularization = pow(10, 10);
  // smoothness
  float flowfieldSmoothing = 0.05; //smaller value result better smooth
  float MIN_flowfieldSmoothing = 0.02; 
  float MAX_flowfieldSmoothing = 1;
  // alpha gives blur
  int flowLineAlpha = 30;
  int MIN_flowLineAlpha   = 10;
  int MAX_flowLineAlpha   = 255;

  //*** PERLIN NOISE ***//
  // strength
  int noiseStrength = 10;
  int MIN_noiseStrength = 1;
  int MAX_noiseStrength = 100;
  // scale
  int noiseScale = 10; 
  int MIN_noiseScale = 1;
  int MAX_noiseScale = 100;

  //*** PARTICLES AND FLOW FIELD ***//
  // force
  float particleForceMultiplier = 50;   
  float MIN_particleForceMultiplier = 1;
  float MAX_particleForceMultiplier = 300;
  // speed
  float particleAccelerationFriction = .75; 
  float MIN_particleAccelerationFriction = .001;
  float MAX_particleAccelerationFriction = .999;
  // speed ofreturn
  float particleAccelerationLimiter = .35;  
  float MIN_particleAccelerationLimiter = .001;
  float MAX_particleAccelerationLimiter = .999;
  // change in cloud form
  float particleNoiseVelocity = .05;
  float MIN_particleNoiseVelocity = .005;
  float MAX_particleNoiseVelocity = .3;

  //*** PARTICLES DRAWN ***//
  int particleColorScheme = PARTICLE_COLOR_SCHEME_XY;
  color particleColor    = color(255, 0, 255);
  // Opacity particle lines
  int particleAlpha  = 50; 
  int MIN_particleAlpha   = 10;
  int MAX_particleAlpha   = 255;
  // number of particles active
  int particleMaxCount = 30000;
  int MIN_particleMaxCount = 1000;
  int MAX_particleMaxCount = 30000;
  // particles movement
  int particleGenerateRate = 2; 
  int MIN_particleGenerateRate = 1;
  int MAX_particleGenerateRate = 50;
  // particle movement per frame minimum
  int particleMinStepSize = 4;
  int MIN_particleMinStepSize = 2;
  int MAX_particleMinStepSize = 10;
  // particle movement per frame maximum
  int particleMaxStepSize = 8;
  int MIN_particleMaxStepSize = 2;
  int MAX_particleMaxStepSize = 10;
  // life 
  int particleLifetime = 400;
  int MIN_particleLifetime = 50;
  int MAX_particleLifetime = 1000;
}

