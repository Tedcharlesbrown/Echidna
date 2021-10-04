import themidibus.*;
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

MidiBus myBus; // The MidiBus

String lxMidiCommandData = "";
String lxOldMidiCueNumber = "";
String lxMidiCueNumber = "";
String lxMidiCueList = "";



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
	// println("Cue List: " + lxMidiCueList);
	// println("Cue Number: " + lxMidiCueNumber);
	lxMidiCommandData = "";
	// println();
	// println();
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
		//GET CUE LIST
		lxMidiCueList = lxMidiCommandData.substring(indexEnd + 3, lxMidiCommandData.length());
		split = split(lxMidiCueList, ' ');
		lxMidiCueList = "";
		for (int i = 0; i < split.length - 1; i++) {
			lxMidiCueList += split[i].charAt(1);
		}
	}
}
