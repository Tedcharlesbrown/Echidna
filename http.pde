import http.*;

SimpleHTTPServer server;
PrintWriter output;

String[] serverText;

void serverSetup() {
  output = createWriter("data/index.html");

  server = new SimpleHTTPServer(this);
  DynamicResponseHandler responder = new DynamicResponseHandler(new JSONEcho(), "application/json");
  server.createContext("echo", responder);

  server.serve("style.css");
  server.serve("script.js");
  server.serve("webImage.png");

  serverText = loadStrings("base.txt");

  output = createWriter("data/index.html");
  serverText = loadStrings("base.txt");

  for (int i = 0; i < serverText.length; i++) {
    output.println(serverText[i]);
  }

  output.flush();

  // printArray(serverText);
}


class JSONEcho extends ResponseBuilder {
  public  String getResponse(String requestBody) {
    JSONObject json = parseJSONObject(requestBody);
    // println(json);
    // int number = json.getInt("requestClock");
    json.setString("clock", clock);
    json.setString("timeCode", timeCode);

    json.setString("lxCurrentCue", lxMidiCueNumber);


    json.setString("d3CurrentCue", d3CurrentCue);
    json.setString("d3NextCue", d3NextCue);
    json.setString("d3Time", d3Hint);
    return json.toString();
  }
}