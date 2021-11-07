input d3Input = new input("DISGUISE");
input midiInput = new input("MIDI");
input timecodeInput = new input("TIMECODE");
input vMixInput = new input ("VMIX");
boolean hasD3, hasMIDI, hasTimecode;

void drawInputs() {
  push();
  translate(555,4);

  midiInput.draw(0,0);
  d3Input.draw(80,0);
  timecodeInput.draw(160,0);
  vMixInput.draw(240,0);
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
        consoleLog("RECEIVED TRIGGER FROM " + name + "!");
        hasD3 = true;
      } else if (name.equals("MIDI") && !hasMIDI) {
        consoleLog("RECEIVED TRIGGER FROM " + name + "!");
        hasMIDI = true;
      } else if (name.equals("TIMECODE") && !hasTimecode) {
        consoleLog("RECEIVED TRIGGER FROM " + name + "!");
        hasTimecode = true;
      }
  }
}