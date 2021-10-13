import processing.video.*;

String clock;

void setup() {
  size(960, 540);
  // surface.setResizable(true);

  serverSetup();
  setupMIDI();
  setupOSC();
}

int delay = 0;
Boolean trigger = false;
int videoDelay = 150;

void draw() {
  getClock();
  background(0);

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
  // if (!d3OldCurrentCue.equals(d3CurrentCue) || !lxOldMidiCueNumber.equals(lxMidiCueNumber)) {
  //  delay = millis();
  //  d3OldCurrentCue = d3CurrentCue;
  //  lxOldMidiCueNumber = lxMidiCueNumber;
  //  trigger = true;
  // } else {
  //  if (millis() > delay + videoDelay && trigger) {
  //    saveFrame("data/showfeed.png");
  //    trigger = false;
  //    // println("SAVE FRAME");
  //  }
  // }
}
