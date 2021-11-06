String debug = "";
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

  // drawInputs();
}

String clock = "";
String clockFile = "";

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

boolean recording = false;
int recordOffset = 0;
String recordTime = "";

void setRecordTime() {
  recordOffset = millis();
}

input d3Input = new input("DISGUISE");
input midiInput = new input("MIDI");
input timecodeInput = new input("TIMECODE");

void drawInputs() {
  d3Input.draw(200,500);
}

class input {
  String name = "";
  int w = 100;
  int h = 20;
  color c = color(0,255,0);
  input(String tempName) {
    name = tempName;
  }

  void draw(float posX, float posY) {
    push();
    textAlign(CENTER,CENTER);
    translate(posX,posY);

    fill(c);
    rect(0,0,w,h);


    fill(0);
    stroke(255);
    text(name,w/2,h/2.25);


    pop();
  }

  void update(boolean trigger) {
    if (trigger) {
      c = color(0,255,0);
    }
  }
}