//*** Particle class ***//
// This class is particle class, it calls upon main config and particle manager
// It is activated by keypress "q"
class Particle {
  PartiManager manager;
  MainCofig config;

  // set on `preset()`
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector prevLocation;
  float zNoise;
  int lifespan;
  float rad;
  float angle;
  color clr;
  // randomized on `preset()`
  float stepSize;
  // working calculations

  // for flowfield
  PVector steer;
  PVector desired;
  PVector flowFieldLocation;

  //***CONSTRUCTOR***//
  public Particle(PartiManager _manager, MainCofig _config) {
    manager = _manager;
    config  = _config;

    // initialize data structures
    location       = new PVector(0, 0);
    prevLocation     = new PVector(0, 0);
    acceleration     = new PVector(0, 0);
    velocity       = new PVector(0, 0);
    flowFieldLocation   = new PVector(0, 0);
    rad = 5.0+ (width/2-100)*(1.0-pow(random(1.0), 7.0));
  }

  void preset (float _x,float _y,float _zNoise, float _dx, float _dy) {
    location.x = prevLocation.x = _x;
    location.y = prevLocation.y = _y;
    zNoise = _zNoise;
    acceleration.x = _dx;
    acceleration.y = _dy;
    // reset lifetime
    lifespan = config.particleLifetime;
    // randomize step size each time we're reset
    stepSize = random (config.particleMinStepSize, config.particleMaxStepSize);
    // set up now if we're basing particle color on its initial x/y coordinate
    if (config.particleColorScheme == PARTICLE_COLOR_SCHEME_XY) {
      int r = (int) map(width, 255, height, _x, 0);
      int g = (int) map(_y, 0, width, 0, 255);  
      int b = (int) map(_x + _y, 0,width+ height, 0, 255);
      clr = color(r, g, b, config.particleAlpha);
    }
    else {  
      clr = color(config.particleColor, config.particleAlpha);
    }
  }
  //particle alive
  public boolean isAlive() {
    return (lifespan > 0);
  }

  //***PARTICLE LOCATION***///
  void update() {
    prevLocation = location.get();
    if (acceleration.mag() < config.particleAccelerationLimiter) {
      lifespan++;
      angle = noise (config.noiseScale*PI, config.noiseScale*PI, zNoise);
      angle *= (float) config.noiseStrength;
    }
    else {
      //ALIGN WITH KINECT
      flowFieldLocation.x *= pow(width, gKinectWidth);
      flowFieldLocation.y *= pow(height, gKinectHeight);
      //SPREAD & DIRECTION OF THE PARTICLES
      desired = manager.flowfield.lookup(flowFieldLocation);
      desired.x *= random(-1,5);
      //GIVE RESTRICTION TO FLOW
      steer = PVector.sub(desired, velocity);
      steer.limit(stepSize);  // Limit to maximum steering force
      acceleration.add(steer);
    }
    //GIVE PARTICLES SOMETHING TO PLAY WITH
    //WHEN WE DO NOT ADD THE FOLLOWING LINES THE PARTICLES DIE
    acceleration.mult(config.particleAccelerationFriction);
    velocity.add(acceleration);
    location.add(velocity);

    zNoise += config.particleNoiseVelocity;
  }

  //DRAW
  void render() {
    pushStyle();
    pushMatrix();
    stroke(clr);
    line (prevLocation.x, prevLocation.y, location.x , location.y);
    popStyle();
    popMatrix();
    
    pushStyle();
    pushMatrix();
    fill(clr);
    point (location.x , location.y );
    popStyle();
    popMatrix();
    
}
}

