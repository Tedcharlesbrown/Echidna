import http.requests.*;

String getIP = "http://127.0.0.1:";
String getFunction = "/api/?Function=";
String getPrefix = "";

void setupVmix() {
	getPrefix = trim(getIP + PORT_VMIX + getFunction);

	// GetRequest get = new GetRequest(getPrefix); //Check connection

	GetRequest get = new GetRequest(getPrefix + "ActivatorRefresh"); //Check connection

}


void updateVmix() {
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
	// println(get.getContent());
}

int delay = 0;
Boolean trigger = false;
int videoDelay = 150;

void drawVmix() {
	updateVmix();
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

void triggerScreenshot() {
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

	println(get.getContent());

	println("SCREENSHOT");
}

void startRecord() {
	GetRequest get = new GetRequest(getPrefix + "StartMultiCorder"); //Start multicorder
	
	get.send();
	println("STARTING RECORD");
}

void stopRecord() {
	GetRequest get = new GetRequest(getPrefix + "StopMultiCorder"); //Stop multicorder

	get.send();
	println(get.getContent());
	println("STOPPING RECORD");
}




