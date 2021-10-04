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

void draw() {
  background(0);
  serverDraw();

  image(video, 0, 0);

  
  saveFrame("data/webImage.png");
}