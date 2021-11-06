String clock = "";
String clockFile = "";
String debug = "";
boolean recording = false;
int recordOffset = 0;
String recordTime = "";

boolean loaded = false;

PImage logo, name, gui;

void setup() {
  name = loadImage("data/images/name.png");
  logo = loadImage("data/images/logo_v2.png");
  gui = loadImage("data/images/gui.png");
  size(960, 540);

  setupSettings();

  setupVmix();
  serverSetup();
  setupMIDI();
  setupOSC();
  setupGui();

  loaded = true;
}

void draw() {
  background(0);
  if (millis() < 10 * 1000) { //10
    image(logo, 0, 0);
  } else {
    image(logo, 0, -height / 7, width / 1.75, height / 1.75);
    image(gui,0,0);
    cp5.show();
    drawConsole();
  }
  image(name, 0, 0);


  getClock();

  // outofordersync();

  updateMIDI();
  updateVmix();
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
  clockFile = hour + "." + minute + "." + second;
}

String millisToTimecode() {
  if (recording) {
    float input = ((millis() / 1000) * 59.94) - ((recordOffset / 1000) * 59.94);

    float frames = input % 59.94;
    float seconds = (input / 59.94) % 59.94;
    float minutes = (input / 59.94 / 59.94) % 59.94;
    float hours = (input / 59.94 / 59.94 / 59.94) % 59.94;

    String output = floor(hours) + ":" + floor(minutes) + ":" + floor(seconds) + ":" + floor(frames);

    return output;
  } else {
    return "NO";
  }


}

void setRecordTime() {
  recordOffset = millis();
}