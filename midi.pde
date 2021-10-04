import themidibus.*;
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

MidiBus myBus; // The MidiBus

String commandData = "";
String cueNumber = "";
String cueList = "";

int indexStart, indexEnd;

void setupMIDI() {
	MidiBus.list();
	myBus = new MidiBus(this,0,-1);
}


void midiMessage(MidiMessage message) {
	if (message.getMessage().length >= 10) {
		parseSYSEX(message);
	}
}

void parseSYSEX(MidiMessage message) {
	for (int i = 1; i < message.getMessage().length; i++) {
		String m = hex(message.getMessage()[i]);
		if (i == 2) {
			// println("Device ID: " + m);
		} else if (i == 4) {
			// println("Command Format: " + m);
		} else if (i == 5) {
			// println("Command: " + m);
		} else if (i >= 6) {
			parseLXCue(m);
		}
	}
	// println("Cue List: " + cueList);
	println("Cue Number: " + cueNumber);
	commandData = "";
	// println();
	// println();
}

void parseLXCue(String m) {
	if (!m.equals("F7")) { //IGNORE MIDI ENDING
		commandData += m + " ";
	}
	indexEnd = commandData.indexOf("00"); //Find split
	if (indexEnd != -1) { //If cannot find split
		//GET CUE NUMBER
		cueNumber = commandData.substring(0, indexEnd);
		String[] split = split(cueNumber, ' ');
		cueNumber = "";
		for (int i = 0; i < split.length - 1; i++) {
			if (split[i].charAt(1) == 'E') {
				cueNumber += ".";
			} else {
				cueNumber += split[i].charAt(1);
			}
		}
		//GET CUE LIST
		cueList = commandData.substring(indexEnd + 3, commandData.length());
		split = split(cueList, ' ');
		cueList = "";
		for (int i = 0; i < split.length - 1; i++) {
			cueList += split[i].charAt(1);
		}
	}
}
