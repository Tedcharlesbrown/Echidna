import themidibus.*;
import websockets.*;
import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

MidiBus myBus; // The MidiBus

String myConsole = "";
int myConsoleLength = 0;

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



void sendOBSHint(String text) {
  OscMessage myMessage = new OscMessage("/hint/setText");
  myMessage.add(text);
  oscP5.send(myMessage, myRemoteLocation);
}



void printScreen(String text) {
  if (myConsoleLength > 6) {
    myConsole = "";
    myConsoleLength = 0;
  }
  myConsole += text + "\n";
  myConsoleLength++;
}
