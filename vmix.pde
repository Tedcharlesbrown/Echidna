import http.requests.*;

String getIP = "http://127.0.0.1:";
String getFunction = "/api/?Function=";
String getPrefix = "";

boolean vMixAvailable = false;

void setupVmix() {
  getPrefix = trim(getIP + PORT_VMIX + getFunction);

  if (pingHost("127.0.0.1", int(PORT_VMIX), 1000)) {
    if (checkVmix()) {
      vMixAvailable = true;
      consoleLog("CONNECTED TO VMIX!");
    } else {
      vMixAvailable = false;
      consoleLog("COULD NOT CONNECT TO VMIX");
    }
  }
}


int checkVmixTimer = 0;
void updateVmix() {
  if (vMixAvailable) {
    screenshot();
    //Replace all non characters
    
    try {
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

    checkVmix();
    } catch (Exception e) {
      
    }
  } else if ((millis() / 100) - checkVmixTimer > 100) {
    checkVmixTimer = millis() / 100;
    checkVmix();
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

void keyPressed() {
  if (key == '/') {
    triggerScreenshot();
  }
}

void triggerScreenshot() {
  try {
    //NOTE: ADD SPECIAL SCREENSHOT - NAME SCREENSHOT THEN TAKE PICTURE
    int vMixDelay = 250;
    String function = "SnapshotInput&Input=";
    String vmixPath = sketchPath().replace('\\','/');

    GetRequest get = new GetRequest(getPrefix + function + "StageFeed-Clean" + "&Value=" + vmixPath + "/data/" + "showFeed.png"); // Screenshot Stage Feed - Web Browser
    get.send();
    delay(vMixDelay);

    get = new GetRequest(getPrefix + function + "Multiview-Clean" + "&Value=" + vmixPath + "/data/" + "multiview.png"); // Screenshot Stage Feed - Web Browser
    get.send();
    delay(vMixDelay);

    String stamp = clockFile + "_[" + lxMidiList1CueNumber + "]";

    get = new GetRequest(getPrefix + function + "StageFeed-Overlay" + "&Value=" + vmixPath + "/output/" + "ShowFeed/" + "feed_" + stamp + ".png"); // Screenshot Stage Feed - Documentation
    get.send();
    delay(vMixDelay);

    get = new GetRequest(getPrefix + function + "Multiview-Overlay" + "&Value=" + vmixPath + "/output/" + "Multiview/" + "mv_" + stamp + ".png"); // Screenshot Multiview - Documentation
    get.send();

    checkVmix();

    println("SCREENSHOT");
  } 
  catch (Exception e) {
    println(e);
  }
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

boolean checkVmix() {
  GetRequest get = new GetRequest(getPrefix + "ActivatorRefresh");
  get.send();
  try {
    if (get.getContent().indexOf("Function completed successfully") != -1) {
      vMixInput.trigger();
      return true;
    } else {
      vMixAvailable = false;
      return false;
    }
  } 
  catch (Exception e) {
    vMixAvailable = false;
    return false;
  }
}
