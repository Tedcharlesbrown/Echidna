import themidibus.*;
import websockets.*;
import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

MidiBus myBus; // The MidiBus

String myConsole = "";
int myConsoleLength = 0;

String oldCue = "old";
String newCue = "new";

void setup() {
  MidiBus.list();
  size(400, 400);
  oscP5 = new OscP5(this, 7400);
  myRemoteLocation = new NetAddress("10.71.10.160", 3333);
}

void draw() {
  background(0);
  fill(255);
  stroke(255);
  int sizeOfText = 32;
  textSize(sizeOfText);
  textAlign(LEFT, LEFT);
  text(myConsole, sizeOfText, sizeOfText);
}

void mousePressed() {
  printScreen("TEST");
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkTypetag("s")) {
    oscStringParse(theOscMessage.addrPattern(), theOscMessage.get(0).stringValue());
    // print(" addrpattern: "+theOscMessage.addrPattern());
    // println(theOscMessage.get(0).stringValue());
  }
}

String d3_SC = "/d3/showcontrol/";
String d3Hint = d3_SC + "sectionhint";
String d3Current = d3_SC + "currentsectionname";
String d3Next = d3_SC + "nextsectionname";

void oscStringParse(String address, String arg) {
  if (address.equals(d3Hint)) {
    sendOBSHint(arg);
    // println(arg);
  }

  if (address.equals(d3Current)) {
    parseD3Cue(arg);
  }
}

void sendOBSHint(String text) {
  OscMessage myMessage = new OscMessage("/hint/setText");
  myMessage.add(text);
  oscP5.send(myMessage, myRemoteLocation);
}

void parseD3Cue(String text) {
  newCue = text;
  if (!newCue.equals(oldCue)) {
    oldCue = newCue;
    printScreen(newCue);
  }

}

void printScreen(String text) {
  if (myConsoleLength > 6) {
    myConsole = "";
    myConsoleLength = 0;
  }
  myConsole += text + "\n";
  myConsoleLength++;
}
