import http.*;

SimpleHTTPServer server;

String[] serverText;

void serverSetup() {

  try {
    server = new SimpleHTTPServer(this, int(PORT_HTTP));
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

void serverStop() {
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