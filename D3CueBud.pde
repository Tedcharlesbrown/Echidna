import processing.video.*;

Capture video;

void setup() {
  size(1920, 1080);
  surface.setResizable(true);

  printArray(Capture.list());
  // video = new Capture(this, Capture.list()[0]);
  video = new Capture(this, 1920, 1080, Capture.list()[0], 30);
  video.start();

  serverSetup();
  setupMIDI();
  setupOSC();
}

void captureEvent(Capture video) {
  video.read();
}

String oldTrigger = "";
int delay = 0;
Boolean trigger = false;
int videoDelay = 150;

void draw() {
  background(0);
  serverDraw();

  image(video, 0, 0);


  if (!oldTrigger.equals(d3CurrentCue)) {
    delay = millis();
      oldTrigger = d3CurrentCue;
      trigger = true;
  } else {
    if (millis() > delay + videoDelay && trigger) {
      saveFrame("data/webImage.png");
      trigger = false;
    }
  }
}