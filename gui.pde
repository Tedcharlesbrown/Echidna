import controlP5.*;
import java.util.*;

ControlP5 cp5;

void setupGui() {
	cp5 = new ControlP5(this);

	cp5.addTextfield("HTTP PORT")
	.setValue(PORT_HTTP)
	.setPosition(20, 20)
	.setSize(100, 40)
	.setFont(createFont("arial", 20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addTextfield("DISGUISE PORT")
	.setValue(PORT_DISGUISE_IN)
	.setPosition(220, 20)
	.setSize(100, 40)
	.setFont(createFont("arial", 20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addTextfield("REAPER PORT")
	.setValue(PORT_REAPER_IN)
	.setPosition(420, 20)
	.setSize(100, 40)
	.setFont(createFont("arial", 20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addTextfield("VMIX PORT")
	.setValue(PORT_VMIX)
	.setPosition(20, 200)
	.setSize(100, 40)
	.setFont(createFont("arial", 20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addButton("RECORD")
	.setValue(0)
	.setPosition(400, 400)
	.setFont(createFont("arial", 20))
	.setSize(150, 50)
	.setSwitch(true)
	;

	List l = Arrays.asList(MidiBus.availableInputs());

	cp5.addScrollableList("dropdown")
	.setLabel("MIDI IN PORT")
	.setPosition(620, 20)
	.setSize(250, 400)
	.setFont(createFont("arial", 17))
	.setBarHeight(40)
	.setItemHeight(40)
	.addItems(l)
	.setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
	.setValue(int(MIDI_INPUT))
	;
}

void dropdown(int n) { //get dropdown value
	MIDI_INPUT = str(n);
	closeMIDI();
	setupMIDI();
	println("MIDI IN PORT SET TO: " + n);
	saveSettings();
}

void controlEvent(ControlEvent theEvent) {
	if (theEvent.isAssignableFrom(Textfield.class)) {
		if (theEvent.getName().equals("HTTP PORT")) {
			PORT_HTTP = theEvent.getStringValue();
			serverStop();
			serverSetup();
			println("HTTP PORT SET TO: " + theEvent.getStringValue());
		} else if (theEvent.getName().equals("DISGUISE PORT")) {
			PORT_DISGUISE_IN = theEvent.getStringValue();
			stopOSC();
			setupOSC();
			println("DISGUISE PORT SET TO: " + theEvent.getStringValue());
		} else if (theEvent.getName().equals("REAPER PORT")) {
			PORT_REAPER_IN = theEvent.getStringValue();
			stopOSC();
			setupOSC();
			println("REAPER PORT SET TO: " + theEvent.getStringValue());
		} else if (theEvent.getName().equals("VMIX PORT")) {
			PORT_VMIX = theEvent.getStringValue();
			setupVmix();
			println("VMIX PORT SET TO: " + theEvent.getStringValue());
		}
		saveSettings();
	} 
}

public void RECORD(boolean theValue) {
	if (theValue) {
		startRecord();
	} else {
		stopRecord();
	}
}