import controlP5.*;
import java.util.*;
import java.net.*;

ControlP5 cp5;
String console = "";

List midiInputList;

void setupGui() {
	int textSize = 15;
	int inputWidth = 75;
	int inputHeight = 25;

	cp5 = new ControlP5(this);

	cp5.addTextfield("SERVER")
	.setValue(PORT_HTTP)
	.setPosition(57, 200)
	.setSize(inputWidth, inputHeight)
	.setFont(createFont("arial", textSize))
	.setFocus(false)
	.setAutoClear(false)
	.setColorValue(0xffffffff)
	.setColorActive(0xffff8800)
	.setColorCaptionLabel(0xffffffff)
	.setColorForeground(0xff9C8DD7)
	.setColorBackground(0xff360073)
	;

	cp5.addTextfield("VMIX OUT")
	.setValue(PORT_VMIX)
	.setPosition(57, 300)
	.setSize(inputWidth, inputHeight)
	.setFont(createFont("arial", textSize))
	.setFocus(false)
	.setAutoClear(false)
	.setColorValue(0xffffffff)
	.setColorActive(0xffff8800)
	.setColorCaptionLabel(0xffffffff)
	.setColorForeground(0xff9C8DD7)
	.setColorBackground(0xff360073)
	;

	cp5.addTextfield("DISGUISE IN")
	.setValue(PORT_DISGUISE_IN)
	.setPosition(198, 200)
	.setSize(inputWidth, inputHeight)
	.setFont(createFont("arial", textSize))
	.setFocus(false)
	.setAutoClear(false)
	.setColorValue(0xffffffff)
	.setColorActive(0xffff8800)
	.setColorCaptionLabel(0xffffffff)
	.setColorForeground(0xff9C8DD7)
	.setColorBackground(0xff360073)
	;

	cp5.addTextfield("REAPER IN")
	.setValue(PORT_REAPER_IN)
	.setPosition(198, 300)
	.setSize(inputWidth, inputHeight)
	.setFont(createFont("arial", textSize))
	.setFocus(false)
	.setAutoClear(false)
	.setColorValue(0xffffffff)
	.setColorActive(0xffff8800)
	.setColorCaptionLabel(0xffffffff)
	.setColorForeground(0xff9C8DD7)
	.setColorBackground(0xff360073)
	;

	cp5.addButton("RECORD")
	.setValue(0)
	.setPosition(345, 450)
	.setFont(createFont("arial", textSize))
	.setSize(int(inputWidth * 1.5), int(inputHeight * 1.5))
	.setSwitch(true)
	.setColorValue(0xffffffff)
	.setColorActive(0xffff8800)
	.setColorCaptionLabel(0xffffffff)
	.setColorForeground(0xff9C8DD7)
	.setColorBackground(0xff360073)
	;

	midiInputList = Arrays.asList(MidiBus.availableInputs());

	cp5.addScrollableList("dropdown")
	.setLabel("MIDI IN PORT")
	.setPosition(330, 200)
	.setSize(int(inputWidth * 2.5), int(inputHeight * 6))
	.setFont(createFont("arial", textSize / 1.25))
	.setBarHeight(inputHeight)
	.setItemHeight(inputHeight)
	.addItems(midiInputList)
	// .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
	.setValue(int(MIDI_INPUT))
	.setColorValue(0xffffffff)
	.setColorActive(0xff9C8DD7)
	.setColorCaptionLabel(0xffffffff)
	.setColorForeground(0xff9C8DD7)
	.setColorBackground(0xff360073)
	;

	cp5.hide();
}


void drawConsole() {
	int padding = 50;
	push();
	fill(50);
	stroke(255);
	translate(padding * 1.5 + width / 2, padding / 1.75);
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

	if (!log.contains("TELNET")) {
		telnetServer.write("ECHIDNA: " + log);
		telnetServer.write(carriageReturn);
	}

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
		if (theEvent.getName().equals("SERVER")) {
			PORT_HTTP = theEvent.getStringValue();
			serverStop();
			serverSetup();
			consoleLog("HTTP PORT SET TO: " + theEvent.getStringValue());
		} else if (theEvent.getName().equals("DISGUISE IN")) {
			PORT_DISGUISE_IN = theEvent.getStringValue();
			stopOSC();
			setupOSC();
			consoleLog("DISGUISE PORT SET TO: " + theEvent.getStringValue());
		} else if (theEvent.getName().equals("REAPER IN")) {
			PORT_REAPER_IN = theEvent.getStringValue();
			stopOSC();
			setupOSC();
			consoleLog("REAPER PORT SET TO: " + theEvent.getStringValue());
		} else if (theEvent.getName().equals("VMIX OUT")) {
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
