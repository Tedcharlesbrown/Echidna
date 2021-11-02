String clock = "";
String debug = "";

void setup() {
  size(960, 540);
  setupSettings();

  setupVmix();

  
  serverSetup();
  setupMIDI();
  setupOSC();
  setupGui();
}

void draw() {
  getClock();
  background(0);


  drawVmix();
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
