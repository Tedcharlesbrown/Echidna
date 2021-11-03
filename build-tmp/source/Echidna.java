import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import java.util.*; 
import java.net.*; 
import http.*; 
import themidibus.*; 
import javax.sound.midi.MidiMessage; 
import javax.sound.midi.SysexMessage; 
import javax.sound.midi.ShortMessage; 
import netP5.*; 
import oscP5.*; 
import http.requests.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Echidna extends PApplet {

String clock = "";
String debug = "";
boolean recording = false;
int recordOffset = 0;
String recordTime = "";

boolean loaded = false;

PImage logo, name;

public void setup() {
  name = loadImage("data/logo/name.png");
  logo = loadImage("data/logo/logo_v2.png");
  

  setupSettings();

  setupVmix();
  serverSetup();
  setupMIDI();
  setupOSC();
  setupGui();

  loaded = true;
}

public void draw() {
  background(0);
  if (millis() < 1 * 1000) { //10
    image(logo, 0, 0);
  } else {
    image(logo, 0, -height / 8, width / 2, height / 2);
    cp5.show();
  }
  image(name, 0, 0);


  getClock();

  updateVmix();
  drawConsole();
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

public String millisToTimecode() {
  if (recording) {
    float input = ((millis() / 1000) * 59.94f) - ((recordOffset / 1000) * 59.94f);

    float frames = input % 59.94f;
    float seconds = (input / 59.94f) % 59.94f;
    float minutes = (input / 59.94f / 59.94f) % 59.94f;
    float hours = (input / 59.94f / 59.94f / 59.94f) % 59.94f;

    String output = floor(hours) + ":" + floor(minutes) + ":" + floor(seconds) + ":" + floor(frames);

    return output;
  } else {
    return "NO";
  }


}

public void setRecordTime() {
  recordOffset = millis();
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

    TableRow newRow = debugTable.addRow();
    newRow.setString("Time", clock);
    newRow.setString("RecordTime", millisToTimecode());
    newRow.setString("Trigger", "D3");
    newRow.setString("Timecode", timeCode);
    newRow.setString("D3 Time", d3Position);
    newRow.setString("LX Cue", lxMidiCueList + "/" + lxMidiCueNumber);
    newRow.setString("D3 Cue", d3CurrentCue);
    saveTable(debugTable, "data/debug.csv");

    consoleLog(clock + ":" + "D3:" + d3CurrentCue);
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
String console = "";

public void setupGui() {
	cp5 = new ControlP5(this);

	cp5.addTextfield("HTTP PORT")
	.setValue(PORT_HTTP)
	.setPosition(20, 150)
	.setSize(100, 40)
	.setFont(createFont("arial", 20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addTextfield("DISGUISE PORT")
	.setValue(PORT_DISGUISE_IN)
	.setPosition(175, 150)
	.setSize(100, 40)
	.setFont(createFont("arial", 20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addTextfield("REAPER PORT")
	.setValue(PORT_REAPER_IN)
	.setPosition(350, 150)
	.setSize(100, 40)
	.setFont(createFont("arial", 20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addTextfield("VMIX PORT")
	.setValue(PORT_VMIX)
	.setPosition(20, 300)
	.setSize(100, 40)
	.setFont(createFont("arial", 20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addButton("RECORD")
	.setValue(0)
	.setPosition(20, 400)
	.setFont(createFont("arial", 20))
	.setSize(150, 50)
	.setSwitch(true)
	;

	List l = Arrays.asList(MidiBus.availableInputs());

	cp5.addScrollableList("dropdown")
	.setLabel("MIDI IN PORT")
	.setPosition(175, 300)
	.setSize(250, 400)
	.setFont(createFont("arial", 17))
	.setBarHeight(40)
	.setItemHeight(40)
	.addItems(l)
	.setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
	.setValue(PApplet.parseInt(MIDI_INPUT))
	;

	cp5.hide();
}


public void drawConsole() {
	int padding = 50;
	push();
	fill(50);
	stroke(255);
	translate(padding * 1.5f + width / 2, padding / 2);
	rect(0, 0, width / 2 - padding * 2, height - padding);

	int textSizer = 15;

	fill(255);
	noStroke();
	textSize(textSizer);
	translate(textSizer * 0.5f, textSizer * 0.5f);
	textAlign(LEFT, TOP);
	text(console, 0, 0);


	pop();
}


public void consoleLog(String log) {
	String temp = console;
	int numberOfLines = 1;
	for (int i = 0; i < temp.length(); i++) {
		if (temp.charAt(i) == '\n') {
			numberOfLines++;
		}
		if (numberOfLines == 20) { //Max number of lines
			temp = temp.substring(0, i);
		}
	}
	console = log;
	console += '\n';
	console += temp;

	println(log);
}

public void dropdown(int n) { //get dropdown value
	MIDI_INPUT = str(n);
	closeMIDI();
	setupMIDI();
	if (loaded) {
		consoleLog("MIDI IN PORT SET TO: " + n);
	}
	saveSettings();
}

public void controlEvent(ControlEvent theEvent) {
	if (theEvent.isAssignableFrom(Textfield.class)) {
		if (theEvent.getName().equals("HTTP PORT")) {
			PORT_HTTP = theEvent.getStringValue();
			serverStop();
			serverSetup();
			consoleLog("HTTP PORT SET TO: " + theEvent.getStringValue());
		} else if (theEvent.getName().equals("DISGUISE PORT")) {
			PORT_DISGUISE_IN = theEvent.getStringValue();
			stopOSC();
			setupOSC();
			consoleLog("DISGUISE PORT SET TO: " + theEvent.getStringValue());
		} else if (theEvent.getName().equals("REAPER PORT")) {
			PORT_REAPER_IN = theEvent.getStringValue();
			stopOSC();
			setupOSC();
			consoleLog("REAPER PORT SET TO: " + theEvent.getStringValue());
		} else if (theEvent.getName().equals("VMIX PORT")) {
			PORT_VMIX = theEvent.getStringValue();
			setupVmix();
			consoleLog("VMIX PORT SET TO: " + theEvent.getStringValue());
		}
		saveSettings();
	}
}

public void RECORD(boolean theValue) {
	if (theValue) {
		startRecord();
		recording = true;
		setRecordTime();
		debugTable.clearRows();
	} else {
		stopRecord();
		recording = false;
		recordOffset = 0;
	}
}

public static boolean pingHost(String host, int port, int timeout) {
	try {
		Socket socket = new Socket();
		socket.connect(new InetSocketAddress(host, port), timeout);
		return true;
	} catch (IOException e) {
		return false; // Either timeout or unreachable or failed DNS lookup.
	}
}


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

    consoleLog("SERVER RUNNING ON PORT: " + PORT_HTTP);
  } catch (Exception e) {
    consoleLog("COULD NOT START WEB SERVER");
  }

}

public void serverStop() {
  server.stop();
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
	// MidiBus.list();
	// println(MidiBus.availableInputs());
	// println(MidiBus.availableOutputs());
	myBus = new MidiBus(this, PApplet.parseInt(MIDI_INPUT), PApplet.parseInt(MIDI_OUTPUT));
}

public void closeMIDI() {
	myBus.close();
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
		updateVmix();
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

	TableRow newRow = debugTable.addRow();
	newRow.setString("Time",clock);
	newRow.setString("RecordTime",millisToTimecode());
	newRow.setString("Trigger","LX");
	newRow.setString("Timecode", timeCode);
	newRow.setString("D3 Time", d3Position);
	newRow.setString("LX Cue", lxMidiCueList + "/" + lxMidiCueNumber);
	newRow.setString("D3 Cue", d3CurrentCue);
	saveTable(debugTable,"data/debug.csv");

	consoleLog(clock + ":" + "LX:" + lxMidiCueList + "/" + lxMidiCueNumber);
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

public void stopOSC() {
	disguiseIn.stop();
	reaperIn.stop();
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

String DEFAULT_PORT_VMIX = "8088";

String DEFAULT_MIDI_INPUT = "0";
String DEFAULT_MIDI_OUTPUT = "-1";

Table debugTable;

//---

String PORT_HTTP, PORT_DISGUISE_IN, PORT_REAPER_IN, PORT_EOS_IN, IP_EOS_OUT, PORT_EOS_OUT, PORT_VMIX, MIDI_INPUT, MIDI_OUTPUT;

public void defaultSettings() {
	PORT_HTTP = DEFAULT_PORT_HTTP;
	PORT_DISGUISE_IN = DEFAULT_PORT_DISGUISE_IN;
	PORT_REAPER_IN = DEFAULT_PORT_REAPER_IN;
	PORT_EOS_IN = DEFAULT_PORT_EOS_IN;

	IP_EOS_OUT = DEFAULT_IP_EOS_OUT;
	PORT_EOS_OUT = DEFAULT_PORT_EOS_OUT;

	PORT_VMIX = DEFAULT_PORT_VMIX;

	MIDI_INPUT = DEFAULT_MIDI_INPUT;
	MIDI_OUTPUT = DEFAULT_MIDI_OUTPUT;
}



PrintWriter settingsOut;

public void setupSettings() {
	debugTable = new Table();
	debugTable.addColumn("Time");
	debugTable.addColumn("RecordTime");
	debugTable.addColumn("Trigger");
	debugTable.addColumn("Timecode");
	debugTable.addColumn("D3 Time");
	debugTable.addColumn("LX Cue");
	debugTable.addColumn("D3 Cue");
	saveTable(debugTable,"data/debug.csv");

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
				PORT_VMIX = value;
				break;
			case 4:
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

		settingsOut.print("VMIX PORT: ");
		settingsOut.println(DEFAULT_PORT_VMIX);

		settingsOut.print("MIDI INPUT: ");
		settingsOut.println(DEFAULT_MIDI_INPUT);


		settingsOut.flush();
		settingsOut.close();
	}
	// printArray(settings);

}

public void saveSettings() {
	println("SAVING SETTINGS");

	settingsOut = createWriter("data/settings.txt");

	settingsOut.print("HTTP PORT: ");
	settingsOut.println(PORT_HTTP);

	settingsOut.print("D3 PORT IN: ");
	settingsOut.println(PORT_DISGUISE_IN);

	settingsOut.print("REAPER PORT IN: ");
	settingsOut.println(PORT_REAPER_IN);

	settingsOut.print("VMIX PORT: ");
	settingsOut.println(PORT_VMIX);

	settingsOut.print("MIDI INPUT: ");
	settingsOut.println(MIDI_INPUT);


	settingsOut.flush();
	settingsOut.close();
}


String getIP = "http://127.0.0.1:";
String getFunction = "/api/?Function=";
String getPrefix = "";

boolean vMixAvailable = false;

public void setupVmix() {
	getPrefix = trim(getIP + PORT_VMIX + getFunction);

	if (pingHost("127.0.0.1", PApplet.parseInt(PORT_VMIX), 1000)) {
		GetRequest get = new GetRequest(getPrefix + "ActivatorRefresh"); //Check connection
		get.send();

		println(get.getContent());

		vMixAvailable = true;
		consoleLog("CONNECTED TO VMIX!");
	} else {
		vMixAvailable = false;
		consoleLog("COULD NOT CONNECT TO VMIX");
	}
}


public void updateVmix() {
	if (vMixAvailable) {
		screenshot();

		GetRequest get = new GetRequest(getPrefix + "SetText&Input=LXCue&SelectedName=Message&Value=" + lxMidiList1CueNumber); //LX CUE
		get.send();

		get = new GetRequest(getPrefix + "SetText&Input=D3Time&SelectedName=Message&Value=" + d3Position); // D3 Timeline
		get.send();

		get = new GetRequest(getPrefix + "SetText&Input=D3Cue&SelectedName=Message&Value=" + d3CurrentCue.replace(' ', '_')); // D3 Current Cue
		get.send();

		get = new GetRequest(getPrefix + "SetText&Input=D3Next&SelectedName=Message&Value=" + d3NextCue.replace(' ', '_')); // D3 Next Cue
		get.send();

		get = new GetRequest(getPrefix + "SetText&Input=D3Trigger&SelectedName=Message&Value=" + d3NextTriggerType + ":" + d3NextTrigger); // D3 Next Trigger
		get.send();

		get = new GetRequest(getPrefix + "SetText&Input=timeCode&SelectedName=Message&Value=" + timeCode); // D3 Next Trigger
		get.send();
	}
}

int delay = 0;
Boolean trigger = false;
int videoDelay = 150;

public void screenshot() {
	if (!d3OldCurrentCue.equals(d3CurrentCue) || !lxOldMidiCueNumber.equals(lxMidiCueNumber)) {
		delay = millis();
		d3OldCurrentCue = d3CurrentCue;
		lxOldMidiCueNumber = lxMidiCueNumber;
		trigger = true;
	} else {
		if (millis() > delay + videoDelay && trigger) {
			triggerScreenshot();
			trigger = false;
		}
	}
}

public void triggerScreenshot() {
	// GetRequest get = new GetRequest(getPrefix + "SnapshotInput&Input=[INPUTNAME]&Value=c://WebImage.png"); // Screenshot Stage Feed - Web Browser
	// get.send();
	GetRequest get = new GetRequest(getPrefix + "KeyPress&Value=F1"); // Screenshot Stage Feed - Web Browser
	get.send();
	delay(100);
	get = new GetRequest(getPrefix + "KeyPress&Value=F2"); // Screenshot Multiview - Web Browser
	get.send();
	delay(100);
	get = new GetRequest(getPrefix + "KeyPress&Value=F3"); // Screenshot Stage Feed - Archive
	get.send();
	delay(100);
	get = new GetRequest(getPrefix + "KeyPress&Value=F4"); // Screenshot Multiview - Archive
	get.send();

	// println(get.getContent());

	println("SCREENSHOT");
}

public void startRecord() {
	if (vMixAvailable) {
		GetRequest get = new GetRequest(getPrefix + "StartMultiCorder"); //Start multicorder
		get.send();
		consoleLog("STARTING RECORD");
	} else {
		consoleLog("PLEASE CHECK VMIX CONNECTION");
	}
}

public void stopRecord() {
	if (vMixAvailable) {
		GetRequest get = new GetRequest(getPrefix + "StopMultiCorder"); //Stop multicorder
		get.send();
		println(get.getContent());
		if (loaded) { //prevent early logging
			consoleLog("STOPPING RECORD");
		}
	} else {
		consoleLog("PLEASE CHECK VMIX CONNECTION");
	}
}




  public void settings() {  size(960, 540); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Echidna" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
