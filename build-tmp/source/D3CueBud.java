import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import netP5.*; 
import oscP5.*; 
import http.*; 
import themidibus.*; 
import javax.sound.midi.MidiMessage; 
import javax.sound.midi.SysexMessage; 
import javax.sound.midi.ShortMessage; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class D3CueBud extends PApplet {





OscP5 oscP5;
NetAddress myRemoteLocation;

String myConsole = "";
int myConsoleLength = 0;

  public void setup() {
  MidiBus.list();
  
  oscP5 = new OscP5(this, 7400);
  myRemoteLocation = new NetAddress("10.71.10.160", 3333);
}

public void draw() {
  background(0);
  fill(255);
  stroke(255);
  int sizeOfText = 32;
  textSize(sizeOfText);
  textAlign(LEFT, LEFT);
  text(myConsole, sizeOfText, sizeOfText);
}

public void mousePressed() {
  printScreen("TEST");
}



public void sendOBSHint(String text) {
  OscMessage myMessage = new OscMessage("/hint/setText");
  myMessage.add(text);
  oscP5.send(myMessage, myRemoteLocation);
}



public void printScreen(String text) {
  if (myConsoleLength > 6) {
    myConsole = "";
    myConsoleLength = 0;
  }
  myConsole += text + "\n";
  myConsoleLength++;
}
String d3Address = "/d3/showcontrol/";

String d3HeartAddress = d3Address + "heartbeat";
String d3PositionAddress = d3Address + "trackposition";
String d3NameAddress = d3Address + "trackname";
String d3IDAddress = d3Address + "trackid";
String d3CurrentCueAddress = d3Address + "currentsectionname";
String d3NextCueAddress = d3Address + "nextsectionname";
String d3HintAddress = d3Address + "sectionhint";
String d3VolumeAddress = d3Address + "volume";
String d3BrightnessAddress = d3Address + "brightness";
String d3BPMAddress = d3Address + "bpm";
String d3ModeAddress = d3Address + "playmode";

String d3Position, d3Name, d3ID, d3CurrentCue, d3NextCue, d3Hint, d3Mode;
float d3Heart, d3Volume, d3Brightness, d3BPM;

public void d3StringParse(String address, String value) {
  if (address.indexOf(d3PositionAddress) != -1) {
    d3Position = value;
    // println(value);
  } else if (address.indexOf(d3NameAddress) != -1) {
    d3Name = value;
    // println(value);
  } else if (address.indexOf(d3IDAddress) != -1) {
    d3ID = value;
    // println(value);
  } else if (address.indexOf(d3CurrentCueAddress) != -1) {
    d3CurrentCue = value;
    // println(value);
  } else if (address.indexOf(d3NextCueAddress) != -1) {
    d3NextCue = value;
    // println(value);
  } else if (address.indexOf(d3HintAddress) != -1) {
    d3Hint = value;
    // println(value);
  } else if (address.indexOf(d3ModeAddress) != -1) {
    d3Mode = value;
    // println(value);
  }
}

public void d3FloatParse(String address, float value) {
  if (address.indexOf(d3HeartAddress) != -1) {
    d3Heart = value;
    // println(value);
  } else if (address.indexOf(d3VolumeAddress) != -1) {
    d3Volume = value;
    // println(value);
  } else if (address.indexOf(d3BrightnessAddress) != -1) {
    d3Brightness = value;
    // println(value);
  } else if (address.indexOf(d3BPMAddress) != -1) {
    d3BPM = value;
    // println(value);
  }
}


SimpleHTTPServer server;
PrintWriter output;

String[] serverText;

public void serverSetup() {
  output = createWriter("data/index.html");
  server = new SimpleHTTPServer(this); 

  output.println("<!DOCTYPE html>");
  output.println("<html>");
  output.println("<head>");
  output.println("<title>Page Title</title>");
  output.println("<body>");

  output.println("<h1>");
  output.println("<h1>LX Cue Number: ");

  output.println("</body>");
  output.println("</html>");
  output.flush();

  serverText = loadStrings("index.html");
  printArray(serverText);
}

public void serverDraw() {
      output = createWriter("data/index.html");

  for (int i = 0; i < serverText.length; i++) {
    if (i == 5) {
      output.print("<h1>");
      output.print(hour() + ":" + minute() + "." + second());
      output.println("</h1>");
    } else if (i == 6) {
      output.print("<h1>LX Cue Number: ");
      output.print(millis());
      output.println("</h1>");
    } else {
      //output.println(serverText[i]);
    }
  }
  output.flush();
}

 //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html



MidiBus myBus; // The MidiBus
/* incoming osc message are forwarded to the oscEvent method. */
public void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkTypetag("s")) {
    oscStringParse(theOscMessage.addrPattern(), theOscMessage.get(0).stringValue());
  } else if (theOscMessage.checkTypetag("f")) {
    oscFloatParse(theOscMessage.addrPattern(), theOscMessage.get(0).floatValue());
  }
}

public void oscStringParse(String address, String value) {
  if (address.indexOf(d3Address) != -1) {
    d3StringParse(address, value);
  }
}

public void oscFloatParse(String address, float value) {
  if (address.indexOf(d3Address) != -1) {
    d3FloatParse(address, value);
  }
}

  public void settings() {  size(400, 400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "D3CueBud" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
