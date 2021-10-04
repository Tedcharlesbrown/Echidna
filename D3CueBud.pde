import processing.video.*;

Capture video;

String clock;

void setup() {
  size(960, 540);
  surface.setResizable(true);

  printArray(Capture.list());
  video = new Capture(this, 1920/2, 1080/2, Capture.list()[1], 30);
  video.start();

  serverSetup();
  setupMIDI();
  setupOSC();
}

void captureEvent(Capture video) {
  video.read();
}

int delay = 0;
Boolean trigger = false;
int videoDelay = 150;

void draw() {
  getClock();
  background(0);

  image(video, 0, 0);

  screenshot();
}

void getClock() {
  String hour = "";
  String minute = "";
  String second = "";

  if (hour() < 10) {
    hour = "0" + str(hour());
  } else {
    hour = str(hour());
  }
  if (minute() < 10) {
    minute = "0" + str(minute());
  } else {
    minute = str(minute());
  }
  if (second() < 10) {
    second = "0" + str(second());
  } else {
    second = str(second());
  }

  clock = hour + ":" + minute + "." + second;

}


void screenshot() {
  if (!d3OldCurrentCue.equals(d3CurrentCue) || !lxOldMidiCueNumber.equals(lxMidiCueNumber)) {
   delay = millis();
   d3OldCurrentCue = d3CurrentCue;
   lxOldMidiCueNumber = lxMidiCueNumber;
   trigger = true;
  } else {
   if (millis() > delay + videoDelay && trigger) {
     saveFrame("data/webImage.png");
     trigger = false;
     // println("SAVE FRAME");
   }
  }
}
