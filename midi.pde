import themidibus.*;
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

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

void setupMIDI() {
	// MidiBus.list();
	// println(MidiBus.availableInputs());
	// println(MidiBus.availableOutputs());
	myBus = new MidiBus(this, int(MIDI_INPUT), int(MIDI_OUTPUT));
}

void closeMIDI() {
	myBus.close();
}


void midiMessage(MidiMessage message) {
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

void parseSYSEX(MidiMessage message) {
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

void lxDebug() {
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

void parseLXCue(String m) {

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
