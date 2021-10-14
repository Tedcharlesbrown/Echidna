import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import http.*; 
import themidibus.*; 
import javax.sound.midi.MidiMessage; 
import javax.sound.midi.SysexMessage; 
import javax.sound.midi.ShortMessage; 
import netP5.*; 
import oscP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class D3CueBud extends PApplet {

String clock = "";
String debug = "";

public void setup() {
  
  setupSettings();

  setupGui();
  serverSetup();
  setupMIDI();
  setupOSC();
}

int delay = 0;
Boolean trigger = false;
int videoDelay = 150;

public void draw() {
  getClock();
  background(0);


  screenshot();
}

public void getClock() {
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


public void screenshot() {
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

String d3Position = "";
String d3Mode = "";
String d3Hint = "";
String d3NextCue = "";
String d3CurrentTriggerType = "";
String d3CurrentTrigger = "";
String d3NextTriggerType = "";
String d3NextTrigger = "";
String d3ID = "";
String d3Name = "";
String d3OldCurrentCue = "";
String d3CurrentCue = "";

float d3Heart, d3Volume, d3Brightness, d3BPM;

public void d3OSCParse(OscMessage theOscMessage) {
  if (theOscMessage.checkTypetag("s")) {
    d3StringParse(theOscMessage.addrPattern(), theOscMessage.get(0).stringValue());
  } else if (theOscMessage.checkTypetag("f")) {
    d3FloatParse(theOscMessage.addrPattern(), theOscMessage.get(0).floatValue());
  }
  d3Debug();
}

public void d3StringParse(String address, String value) {
  try {
    if (address.indexOf(d3PositionAddress) != -1) {
      d3Position = value;
    } else if (address.indexOf(d3NameAddress) != -1) { //Track
      d3Name = value;
    } else if (address.indexOf(d3IDAddress) != -1) {
      d3ID = value;
    } else if (address.indexOf(d3CurrentCueAddress) != -1) {
      d3CurrentCue = value;
    } else if (address.indexOf(d3NextCueAddress) != -1) {
      d3NextCue = value;
    } else if (address.indexOf(d3HintAddress) != -1) {
      d3Hint = value;
      parseD3Hint(value);
    } else if (address.indexOf(d3ModeAddress) != -1) {
      d3Mode = value;
    }
  } catch (Exception e) {

  }
}

public void d3FloatParse(String address, float value) {
  try {
    if (address.indexOf(d3HeartAddress) != -1) {
      d3Heart = value;
    } else if (address.indexOf(d3VolumeAddress) != -1) {
      d3Volume = value;
    } else if (address.indexOf(d3BrightnessAddress) != -1) {
      d3Brightness = value;
    } else if (address.indexOf(d3BPMAddress) != -1) {
      d3BPM = value;
    }
  } catch (Exception e) {

  }
}

public void parseD3Hint(String value) {
  int indexStart;
  int indexEnd;

  // if (value.indexOf("+") > value.indexOf("CUE")) {
  //   indexStart = value.indexOf("CUE");
  //   indexEnd = value.indexOf("|");

  //   d3CurrentTrigger = value.indexOf(indexStart + 4, indexEnd).trim();
  // }

  indexStart = value.indexOf("+");
  value = value.substring(indexStart + 12).trim();

  indexStart = value.indexOf(" ");
  indexEnd = value.indexOf("|");

  d3NextTriggerType = value.substring(0, indexStart).trim();
  d3NextTrigger = value.substring(indexStart, indexEnd).trim();
}

/*void outofordersync() {
  if (lxCurrentCue > nextTrigger && nextTriggerType.equals(CUE)) {
    while (lxCurrentCue > nextTrigger) {
      goto next d3Cue
    }
  }
  
  if (lxCurrentCue < curentTrigger && currentTriggerType.equals(CUE)) {
   while (lxCurrentCue < currentTrigger) {
      goto lxCurrentCue--
    }
  }
}*/

public void d3Debug() {
  if (!d3CurrentCue.equals(d3OldCurrentCue)) {
    debug += "<clock>" + clock + ": " + "</clock>";
    debug += "<d3>";
    debug += "D3:   ";
    debug += d3CurrentCue;
    debug += "   |   " + "<debug>";
    debug += "Position: " + d3Hint + ";";
    debug += " Next Trigger: " + d3NextTrigger;
    debug += "</d3>";
    debug += "</debug>";
    debug += ",";

    d3OldCurrentCue = d3CurrentCue;
  }
}
String eosActiveCue = "/eos/out/";

String eosCurrentCue = "";
String eosPreviousCue = "";
String eosPendingCue = "";
String eosPendingCueTime = "";
String eosCurrentCuePercentage = "";
String eosCurrentCueTime = "";

public void eosOSCParse(OscMessage theOscMessage) {
	String address = theOscMessage.addrPattern();

	if (theOscMessage.checkTypetag("s")) {
		String argumentZero = theOscMessage.get(0).stringValue();
		if (address.equals("/eos/out/previous/cue/text") && argumentZero.length() != 0) {
			eosPreviousCue = eosCueParse(argumentZero).get(0);
		} else if (address.equals("/eos/out/active/cue/text") && argumentZero.length() != 0) {
			eosCurrentCue = eosCueParse(argumentZero).get(0);
		} else if (address.equals("/eos/out/pending/cue/text") && argumentZero.length() != 0) {
			eosPendingCue = eosCueParse(argumentZero).get(0);
			eosPendingCueTime = eosCueParse(argumentZero).get(1);
		}
	}
}


public StringList eosCueParse(String argument) {

	StringList returnArgument;
	returnArgument = new StringList();

	String cue = "";
	String time = "";
	String percentage = "";

	int index = argument.indexOf(" ");
	cue = argument.substring(0, index);
	returnArgument.set(0, cue);

	argument = argument.substring(index + 1);
	index = argument.indexOf(" ");

	if (index == -1) { //If end of message, no percentage...
		returnArgument.set(1, time);
	} else if (argument.indexOf("100%") != -1) {
		time = argument.substring(0, index);
		percentage = "100%";
		returnArgument.set(1, time);
		returnArgument.set(2, percentage);
	} else {
		percentage = argument.substring(index + 1);
		returnArgument.set(2, percentage);
	}

	return returnArgument;

}


ControlP5 cp5;

public void setupGui() {
	cp5 = new ControlP5(this);

	cp5.addTextfield("HTTP PORT")
	.setValue(PORT_HTTP)
	.setPosition(20, 20)
	.setSize(100, 40)
	.setFont(createFont("arial",20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addTextfield("DISGUISE IN PORT")
	.setValue(PORT_DISGUISE_IN)
	.setPosition(220, 20)
	.setSize(100, 40)
	.setFont(createFont("arial",20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addTextfield("REAPER IN PORT")
	.setValue(PORT_REAPER_IN)
	.setPosition(420, 20)
	.setSize(100, 40)
	.setFont(createFont("arial",20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addTextfield("MIDI IN PORT")
	.setValue(MIDI_INPUT)
	.setPosition(620, 20)
	.setSize(100, 40)
	.setFont(createFont("arial",20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;
}

// void controlEvent(ControlEvent theEvent) {
//   if(theEvent.isAssignableFrom(Textfield.class)) {
//     println("controlEvent: accessing a string from controller '"
//             +theEvent.getName()+"': "
//             +theEvent.getStringValue()
//             );
//   }
// }

// public void input(String theText) {
//   // automatically receives results from controller input
//   println("a textfield event for controller 'input' : "+theText);
// }


SimpleHTTPServer server;

String[] serverText;

public void serverSetup() {

  try {
    server = new SimpleHTTPServer(this, PApplet.parseInt(PORT_HTTP));
    DynamicResponseHandler responder = new DynamicResponseHandler(new JSONEcho(), "application/json");
    server.createContext("echo", responder);

    server.serve("index.html");
    server.serve("style.css");
    server.serve("script.js");

    server.serve("debug.html");
    server.serve("debug.css");

    server.serve("showfeed.png");
    server.serve("multiview.png");
  } catch (Exception e) {

  }

}

boolean obsStatus = false;


class JSONEcho extends ResponseBuilder {
  public  String getResponse(String requestBody) {
    JSONObject json = parseJSONObject(requestBody);
    // println(json);
    // int number = json.getInt("requestClock");
    json.setBoolean("obs", obsStatus);


    json.setString("clock", clock);
    json.setString("timeCode", timeCode);

    json.setString("lxCurrentList1Cue", lxMidiList1CueNumber);
    json.setString("lxMidiRaw", lxMidiRaw);
    json.setString("lxDeviceID", lxMidiDeviceID);
    json.setString("lxCommandFormat", lxMidiCommandFormat);
    json.setString("lxCommand", lxMidiCommand);
    json.setString("lxCommandData", lxMidiCommandDataRaw);

    json.setString("lxCueList", lxMidiCueList);
    json.setString("lxNowAll", lxMidiCueNumber);


    json.setString("d3Position", d3Position);
    json.setString("d3Hint", d3Hint);
    json.setString("d3Name", d3Name);
    json.setString("d3Mode", d3Mode);

    json.setString("d3CurrentCue", d3CurrentCue);
    json.setString("d3NextCue", d3NextCue);
    json.setString("d3NextTrigger", d3NextTriggerType + " : " + d3NextTrigger);

    json.setString("lxHistory", lxMidiCueHistory);
    json.setString("debugText", debug);

    return json.toString();
  }
}

 //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html



MidiBus myBus; // The MidiBus

String stopOrResume = "[STOP] OR [RESUME]";

String lxMidiRaw = "";
String lxMidiDeviceID = "";
String lxMidiCommandFormat = "";
String lxMidiCommand = "";
String lxMidiCommandData = "";
String lxMidiCommandDataRaw = "";
String lxOldMidiCueNumber = "";
String lxMidiCueNumber = "";
String lxMidiList1CueNumber = "";
String lxMidiCueList = "";

String lxMidiCueHistory = "";

int indexStart, indexEnd;

public void setupMIDI() {
	MidiBus.list();
	// println(MidiBus.availableInputs());
	// println(MidiBus.availableOutputs());
	myBus = new MidiBus(this, PApplet.parseInt(MIDI_INPUT), PApplet.parseInt(MIDI_OUTPUT));
}


public void midiMessage(MidiMessage message) {
	if (message.getMessage().length >= 10) {
		parseSYSEX(message);
	} else {
		for (int i = 0; i < message.getMessage().length - 1; i++) {
			String m = hex(message.getMessage()[i]);
			debug += "<clock>" + clock + ": " + "</clock>";
			debug += m + ",";
		}
	}
	lxMidiRaw = "";
	for (int i = 0; i < message.getMessage().length - 1; i++) {
		String m = hex(message.getMessage()[i]);
		lxMidiRaw += m;
	}
}

public void parseSYSEX(MidiMessage message) {
	lxMidiCommandDataRaw = "";
	for (int i = 1; i < message.getMessage().length; i++) {
		String m = hex(message.getMessage()[i]);
		if (i == 2) {
			lxMidiDeviceID = m;
		} else if (i == 4) {
			lxMidiCommandFormat = m;
		} else if (i == 5) {
			lxMidiCommand = m;
		} else if (i >= 6) {
			parseLXCue(m);
			lxMidiCommandDataRaw += m;
		}
	}
	// println("Cue List: " + lxMidiCueList);
	// println("Cue Number: " + lxMidiCueNumber);
	if (lxMidiCueList.equals("1") && lxMidiCueNumber.indexOf("[") == -1) {
		lxMidiList1CueNumber = lxMidiCueNumber;
	}
	lxDebug();
	lxMidiCommandData = ""; //Reset Command
}

public void lxDebug() {
	lxMidiCueHistory += "<clock>" + clock + ": " + "</clock>";
	lxMidiCueHistory += lxMidiCueList + " / " + lxMidiCueNumber;
	lxMidiCueHistory += ",";

	debug += "<clock>" + clock + ": " + "</clock>";
	debug += "<lx>";
	debug += "LX:   ";
	debug += lxMidiCueList + " / " + lxMidiCueNumber;
	debug += "   |   " + "<debug>";
	debug += "ID: " + lxMidiDeviceID + ";";
	debug += " Format: " + lxMidiCommandFormat + ";";
	debug += " Command: " + lxMidiCommand + ";";
	debug += " Data: " + lxMidiCommandDataRaw;
	debug += "</lx>";
	debug += "</debug>";
	debug += ",";
}

public void parseLXCue(String m) {

	if (!m.equals("F7")) { //IGNORE MIDI ENDING
		lxMidiCommandData += m + " ";
	}
	indexEnd = lxMidiCommandData.indexOf("00"); //Find split
	if (indexEnd != -1) { //If cannot find split
		//GET CUE NUMBER
		lxMidiCueNumber = lxMidiCommandData.substring(0, indexEnd);
		String[] split = split(lxMidiCueNumber, ' ');
		lxMidiCueNumber = "";
		for (int i = 0; i < split.length - 1; i++) {
			if (split[i].charAt(1) == 'E') {
				lxMidiCueNumber += ".";
			} else {
				lxMidiCueNumber += split[i].charAt(1);
			}
		}
		if (lxMidiCueNumber.equals("0")) {
			if (lxMidiCommand.equals("02")) {
				lxMidiCueNumber = "[STOP]";
			} else if (lxMidiCommand.equals("03")) {
				lxMidiCueNumber = "[RESUME]";
			} else {
				lxMidiCueNumber = stopOrResume;
			}

		}
		//GET CUE LIST
		lxMidiCueList = lxMidiCommandData.substring(indexEnd + 3, lxMidiCommandData.length());
		split = split(lxMidiCueList, ' ');
		lxMidiCueList = "";
		for (int i = 0; i < split.length - 1; i++) {
			lxMidiCueList += split[i].charAt(1);
		}
	}
}



OscP5 disguiseIn, eosIn, reaperIn;
NetAddress eosOut;


public void setupOSC() {
	disguiseIn = new OscP5(this, PApplet.parseInt(PORT_DISGUISE_IN));
	reaperIn = new OscP5(this, PApplet.parseInt(PORT_REAPER_IN));
	// eosIn = new OscP5(this, int(PORT_EOS_IN));
	// eosOut = new NetAddress(IP_EOS_OUT, int(PORT_EOS_OUT));
}

/* incoming osc message are forwarded to the oscEvent method. */
public void oscEvent(OscMessage theOscMessage) {
	String address = theOscMessage.addrPattern();
	if (address.indexOf(d3Address) != -1) { //From D3
		d3OSCParse(theOscMessage);
	} else if (address.indexOf(eosActiveCue) != -1) { //From EOS
		eosOSCParse(theOscMessage);
	} else if (address.indexOf(reaperTime) != -1) { //From REAPER
		reaperParse(theOscMessage);
	}
}

String reaperTime = "/frames/str";

String timeCode = "";

public void reaperParse(OscMessage theOscMessage) {
	timeCode = theOscMessage.get(0).stringValue();
}
String DEFAULT_PORT_HTTP = "8000";
String DEFAULT_PORT_DISGUISE_IN = "7400";
String DEFAULT_PORT_REAPER_IN = "9000";
String DEFAULT_PORT_EOS_IN = "4444";

String DEFAULT_IP_EOS_OUT = "192.168.1.202";
String DEFAULT_PORT_EOS_OUT = "3333";

String DEFAULT_MIDI_INPUT = "0";
String DEFAULT_MIDI_OUTPUT = "-1";

//---

String PORT_HTTP, PORT_DISGUISE_IN, PORT_REAPER_IN, PORT_EOS_IN, IP_EOS_OUT, PORT_EOS_OUT, MIDI_INPUT, MIDI_OUTPUT;

public void defaultSettings() {
	PORT_HTTP = DEFAULT_PORT_HTTP;
	PORT_DISGUISE_IN = DEFAULT_PORT_DISGUISE_IN;
	PORT_REAPER_IN = DEFAULT_PORT_REAPER_IN;
	PORT_EOS_IN = DEFAULT_PORT_EOS_IN;

	IP_EOS_OUT = DEFAULT_IP_EOS_OUT;
	PORT_EOS_OUT = DEFAULT_PORT_EOS_OUT;

	MIDI_INPUT = DEFAULT_MIDI_INPUT;
	MIDI_OUTPUT = DEFAULT_MIDI_OUTPUT;
}



PrintWriter settingsOut;

public void setupSettings() {
	defaultSettings();
	String[] settings = loadStrings("data/settings.txt");
	try {
		int arrayLength = settings.length;
		for (int i = 0; i < arrayLength; i++) {
			int indexStart = settings[i].indexOf(":");
			String value = settings[i].substring(indexStart + 1).trim();

			switch (i) {
			case 0:
				PORT_HTTP = value;
				break;
			case 1:
				PORT_DISGUISE_IN = value;
				break;
			case 2:
				PORT_REAPER_IN = value;
				break;
			case 3:
				MIDI_INPUT = value;
				break;
			}
		}
	} catch (Exception e) {
		settingsOut = createWriter("data/settings.txt");
		settingsOut.print("HTTP PORT: ");
		settingsOut.println(DEFAULT_PORT_HTTP);
		settingsOut.print("D3 PORT IN: ");
		settingsOut.println(DEFAULT_PORT_DISGUISE_IN);
		settingsOut.print("REAPER PORT IN: ");
		settingsOut.println(DEFAULT_PORT_REAPER_IN);
		// settingsOut.print("EOS PORT IN: ");
		// settingsOut.println(DEFAULT_PORT_EOS_IN);
		// settingsOut.println(DEFAULT_IP_EOS_OUT);
		// settingsOut.println(DEFAULT_PORT_EOS_OUT);
		settingsOut.print("MIDI INPUT: ");
		settingsOut.println(DEFAULT_MIDI_INPUT);
		// settingsOut.println(DEFAULT_MIDI_OUTPUT);

		settingsOut.flush();
		settingsOut.close();
	}
	// printArray(settings);

}
  public void settings() {  size(960, 540); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "D3CueBud" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
