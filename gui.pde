import controlP5.*;
import java.util.*;

ControlP5 cp5;
String console = "CONSOLE";

void setupGui() {
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
	.setValue(int(MIDI_INPUT))
	;

	cp5.hide();
}


void drawConsole() {
	int padding = 50;
	push();
	fill(50);
	stroke(255);
	translate(padding * 1.5 + width / 2, padding / 2);
	rect(0, 0, width / 2 - padding * 2, height - padding);

	int textSizer = 15;

	fill(255);
	noStroke();
	textSize(textSizer);
	translate(textSizer * 0.5, textSizer * 0.5);
	textAlign(LEFT, TOP);
	text(console, 0, 0);


	pop();
}


void consoleLog(String log) {
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

void dropdown(int n) { //get dropdown value
	MIDI_INPUT = str(n);
	closeMIDI();
	setupMIDI();
	if (loaded) {
		consoleLog("MIDI IN PORT SET TO: " + n);
	}
	saveSettings();
}

void controlEvent(ControlEvent theEvent) {
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