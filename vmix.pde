import http.requests.*;

String getIP = "http://127.0.0.1:";
String getFunction = "/api/?Function=";
String getPrefix = "";

boolean vMixAvailable = false;

void setupVmix() {
	getPrefix = trim(getIP + PORT_VMIX + getFunction);

	if (pingHost("127.0.0.1", int(PORT_VMIX), 1000)) {
		GetRequest get = new GetRequest(getPrefix + "ActivatorRefresh"); //Check connection
		get.send();

		if (get.getContent().indexOf("Function completed successfully") != -1) {
			vMixAvailable = true;
			consoleLog("CONNECTED TO VMIX!");
		} else {
			vMixAvailable = false;
			consoleLog("COULD NOT CONNECT TO VMIX");
		}
	}
}


void updateVmix() {
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

void screenshot() {
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

void mousePressed() {
	triggerScreenshot();
}

void triggerScreenshot() {
	String function = "SnapshotInput&Input=";
	String dataPath = "&Value=C:/Users/Rkdns/Documents/GitHub/Echidna/data/";
	String desktopPath = "&Value=C:/Users/Rkdns/Desktop/ShowDocumentation/";

	GetRequest get = new GetRequest(getPrefix + function + "StageFeed-Clean" + dataPath + "showFeed.png"); // Screenshot Stage Feed - Web Browser
	get.send();
	delay(100);

	get = new GetRequest(getPrefix + function + "Multiview-Clean" + dataPath + "multiview.png"); // Screenshot Stage Feed - Web Browser
	get.send();
	delay(100);

	String stamp = clockFile + "_[" + lxMidiList1CueNumber + "]";

	get = new GetRequest(getPrefix + function + "StageFeed-Overlay" + desktopPath + "ShowFeed/" + "feed_" + stamp + ".png"); // Screenshot Stage Feed - Documentation
	get.send();
	delay(100);

	get = new GetRequest(getPrefix + function + "Multiview-Overlay" + desktopPath + "Multiview/" + "mv_" + stamp + ".png"); // Screenshot Multiview - Documentation
	get.send();

	// println(get.getContent());

	println("SCREENSHOT");
}

void startRecord() {
	if (vMixAvailable) {
		GetRequest get = new GetRequest(getPrefix + "StartMultiCorder"); //Start multicorder
		get.send();
		consoleLog("STARTING RECORD");
	} else {
		consoleLog("PLEASE CHECK VMIX CONNECTION");
	}
}

void stopRecord() {
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




