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
    drawInputs();
    drawConsole();
  }
  image(name, 0, 0);


  getClock();

  // outofordersync();

  updateMIDI();
  updateVmix();
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
boolean hasD3, hasMIDI, hasTimecode;

void drawInputs() {
  push();
  translate(555,4);

  midiInput.draw(0,0);
  d3Input.draw(80,0);
  timecodeInput.draw(160,0);
  pop();
}

class input {
  String name = "";
  int w = 75;
  int h = 20;

  int timer = 0;
  int max = 1 * (60 * 60);

  input(String tempName) {
    name = tempName;
  }

  void draw(float posX, float posY) {
    push();
    textAlign(CENTER,CENTER);
    translate(posX,posY);

    fill(150,50,50);
    rect(0,0,w,h);

    if (timer == max) {
      fill(0,255,0);
      strokeWeight(2);
      stroke(0,255,0);
    } else {
      fill(50,150,50);
      strokeWeight(1);
      stroke(0);
    }

    rect(0,0,map(timer,0,max,0,w),h);

    fill(0);
    stroke(255);
    text(name,w/2,h/2.25);

    if (timer <= 0) {
      timer = 0;
    } else {
      timer--;
    }

    pop();
  }

  void trigger() {
      timer = max;
      if (name.equals("DISGUISE") && !hasD3) {
        consoleLog("RECEIVED TRIGGER FROM" + name + "!");
        hasD3 = true;
      } else if (name.equals("MIDI") && !hasMIDI) {
        consoleLog("RECEIVED TRIGGER FROM" + name + "!");
        hasMIDI = true;
      } else if (name.equals("TIMECODE") && !hasTimecode) {
        consoleLog("RECEIVED TRIGGER FROM" + name + "!");
        hasTimecode = true;
      }
      
  }
}