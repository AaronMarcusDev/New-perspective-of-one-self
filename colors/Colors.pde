// Black/White state
int blackValue = 0;    // 0 = no black, 255 = fully black
int whiteValue = 255;  // 0 = no white, 255 = fully white

// Silence detection for black
float silenceThreshold = 0.01;    // amplitude below this = silence
float silenceTimeLimit = 10.0;     // seconds of silence before black creeps in
float blackIncrementRate = 0.5;   // how much blackValue increases per second of silence
float lastSoundTime = 0;          // millis() of last detected sound

// Emotion color multipliers for certain  - each float[] is {blackMultiplier, whiteMultiplier}
float[] angerMultiplier    = {1.2, 0.8};   // darker, less white
float[] happyMultiplier    = {0.8, 1.2};   // lighter, more white
float[] sadMultiplier      = {1.4, 0.6};   // very dark, muted
float[] disgustMultiplier  = {1.1, 0.9};   // slightly dark
float[] surpriseMultiplier = {0.4, 0.4};   // less black AND less white — vivid, saturated colors

// Hue Arrays - deterimes the range of hue colors
int[] angerHue = {0, 35, 340, 360}; // red/orange
int[] happyHue = {40, 200}; //yellow - light blue
int[] sadHue = {200, 265}; // blue
int[] disgustHue = {85, 135, 265, 310}; // green/purple
int[] surpriseHue = {0, 360}; // any color


void setup() {
  size(200,200);
  colorMode(HSB, 360, 255, 255);
}

//takes in a pitch value and an emotionHue array (the pitch determines the hue from a set of possible hues from the array)
int returnHue(int pitch, int[] emotionHue) {
  
  // Sum total range across all min/max pairs
  int rangeTotal = 0;
  for (int i = 0; i < emotionHue.length; i += 2) {
    rangeTotal += (emotionHue[i+1] - emotionHue[i]);
  }
  
  // Map pitch to a value within the combined range
  int mappedValue = mapRange(pitch, 80, 8000, 0, rangeTotal);
  
  // Walk through the pairs to find which segment mappedValue falls in
  int accumulated = 0;
  for (int i = 0; i < emotionHue.length; i += 2) {
    int segmentSize = emotionHue[i+1] - emotionHue[i];
    if (mappedValue <= accumulated + segmentSize) {
      // Offset from the segment's min once found
      return emotionHue[i] + (mappedValue - accumulated);
    }
    accumulated += segmentSize;
  }
  
  // Fallback: return the last max value
  return emotionHue[emotionHue.length - 1];
}


// Updates blackValue based on silence duration
void updateBlack(float currentAmplitude) {
  float currentTime = millis() / 1000.0;

  if (currentAmplitude > silenceThreshold) {
    // Sound detected — reset silence timer, fade black back out
    lastSoundTime = currentTime;
    blackValue = max(0, blackValue - 5);
  } else {
    // Silence — check if past the threshold
    float silenceDuration = currentTime - lastSoundTime;
    if (silenceDuration > silenceTimeLimit) {
      float excessSilence = silenceDuration - silenceTimeLimit;
      blackValue = min(255, blackValue + (int)(blackIncrementRate * excessSilence));
    }
  }
}


//updates the value of whiteness based on the sound amplitude
void updateWhite(float currentAmplitude, float minAmplitude, float maxAmplitude) {
  // Quiet = low saturation (more white), Loud = high saturation (more vivid)
  whiteValue = (int)mapRangeF(currentAmplitude, minAmplitude, maxAmplitude, 0, 255);
  whiteValue = constrain(whiteValue, 0, 255);
}


// Applies emotion-specific multipliers to black and white values
// Returns a float[] of {adjustedBlack, adjustedWhite}
float[] applyEmotionMultiplier(float[] multiplier) {
  float adjustedBlack = constrain(blackValue * multiplier[0], 0, 255);
  float adjustedWhite = constrain(whiteValue * multiplier[1], 0, 255);
  return new float[]{adjustedBlack, adjustedWhite};
}


// Float version of mapRange for precision
float mapRangeF(float value, float inMin, float inMax, float outMin, float outMax) {
  return ((value - inMin) / (inMax - inMin)) * (outMax - outMin) + outMin;
}

//maps the value of a given range onto another
int mapRange(int value, int inMin, int inMax, int outMin, int outMax) {
  return (int)(((float)(value - inMin) / (inMax - inMin)) * (outMax - outMin) + outMin);
}

//gets the final color
color colorPicker(int pitch, int[] hueSet) {
  return color(returnHue(pitch, hueSet), whiteValue, 255 - blackValue);
}

void draw() {
  //test stuff
  updateWhite(90, 0, 100);
  updateBlack(0.05);
  color tCol = colorPicker(4000, angerHue);
  fill(tCol);
  rect(10,10,100,100);  
}
