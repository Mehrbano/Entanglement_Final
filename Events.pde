//*** Class Events ***///
void keyPressed() {
  if (key == 'q') {
    gConfig.showParticles = !gConfig.showParticles;
    println("show particles: " + gConfig.showParticles);
  } else if (key == 'w') {
    gConfig.showFlowLines = !gConfig.showFlowLines;
    println("show optical flow: " + gConfig.showFlowLines);
  } else if (key == 'a') {
    gConfig.showTactile = !gConfig.showTactile;
    println("show tactile: " + gConfig.showTactile);
  }
  // different blend modes
  else if (key == '1') {
    gConfig.blendMode = BLEND;
    println("Blend mode: BLEND");
  } else if (key == '2') {
    gConfig.blendMode = ADD;
    println("Blend mode: ADD");
  } else if (key == '3') {
    gConfig.blendMode = DARKEST;
    println("Blend mode: DARKEST");
  } else if (key == '4') {
    gConfig.blendMode = LIGHTEST;
    println("Blend mode: LIGHTEST");
  } else if (key == '5') {
    gConfig.blendMode = DIFFERENCE;
    println("Blend mode: DIFFERENCE");
  } else if (key == '6') {
    gConfig.blendMode = EXCLUSION;
    println("Blend mode: EXCLUSION");
  } else if (key == '7') {
    gConfig.blendMode = MULTIPLY;
    println("Blend mode: MULTIPLY");
  } 
}

