import processing.net.*;

Server telnetServer;
String carriageReturn = "\r\n";

void setupTelnet() {
  telnetServer = new Server(this, 5204);
}

void serverEvent(Server someServer, Client someClient) {
  println("We have a new client: " + someClient.ip());
  telnetServer.write("--CONNECTED TO ECHIDNA!--");
  telnetServer.write(carriageReturn);
  consoleLog("TELNET CLIENT CONNECTED!");
}

void readClient() {
  // Get the next available client
  Client thisClient = telnetServer.available();
  //// If the client is not null, and says something, display what it said
  if (thisClient != null) {
    String whatClientSaid = thisClient.readString();
    if (whatClientSaid != null) {
      println(thisClient.ip() + "\t" + whatClientSaid);
      parseResponse(whatClientSaid);
    }
  }
}

void parseResponse(String response) {
  response = response.toLowerCase().trim();


  if (response.equals("help")) {
    responseHelp();
  } else if (response.contains("help")) {
    responseCommandHelp(response);
  } else if (response.equals("settings")) {
    responseSettings();
  } else if (response.contains("set")) {
    responseSet(response);
  } else if (response.contains("status")) {
    responseStatus(response);
    //EASTER EGG-----------------------------------------------------------------------------
  } else if (response.equals("tell me a joke")) {
    telnetServer.write("You want me to tell you a joke? You gotta be Echidna me...");
    telnetServer.write(carriageReturn);
    //FINAL ELSE CATCH-----------------------------------------------------------------------
  } else {
    telnetServer.write("UNRECOGNIZED COMMAND");
    telnetServer.write(carriageReturn);
  }
}

void responseHelp() {
  telnetServer.write("For more information on a specific command, type HELP command-name");
  telnetServer.write(carriageReturn);
  telnetServer.write("SET \t\t Sets the port to the number specified");
  telnetServer.write(carriageReturn);
  telnetServer.write("SETTINGS \t Lists the current ports and port numbers");
  telnetServer.write(carriageReturn);
}

void responseCommandHelp(String help) {
  if (help.contains("settings")) {
    telnetServer.write("Lists the current ports and port numbers");
    telnetServer.write(carriageReturn);
  } else if (help.contains("set")) {
    responseSetHelp();
  }
}

void responseSetHelp() {
  telnetServer.write("Sets the port to the number specified");
  telnetServer.write(carriageReturn);
  telnetServer.write("Example: SET HTTP 8000");
  telnetServer.write(carriageReturn);
  telnetServer.write("HTTP");
  telnetServer.write(carriageReturn);
  telnetServer.write("VMIX");
  telnetServer.write(carriageReturn);
  telnetServer.write("DISGUISE_IN");
  telnetServer.write(carriageReturn);
  telnetServer.write("MIDI_IN");
  telnetServer.write(carriageReturn);
}

void responseSettings() {
  telnetServer.write("--SETTINGS--");
  telnetServer.write(carriageReturn);
  telnetServer.write("HTTP: " + PORT_HTTP);
  telnetServer.write(carriageReturn);
  telnetServer.write("VMIX: " + PORT_VMIX);
  telnetServer.write(carriageReturn);
  telnetServer.write("DISGUISE_IN: " + PORT_DISGUISE_IN);
  telnetServer.write(carriageReturn);
  telnetServer.write("REAPER: " + PORT_REAPER_IN);
  telnetServer.write(carriageReturn);
  telnetServer.write("MIDI_IN: " + MIDI_INPUT);
  telnetServer.write(carriageReturn);
  telnetServer.write("----");
  telnetServer.write(carriageReturn);
}

void responseStatus(String status) {
  if (status.equals("status")) {
    telnetServer.write("--STATUS--");
    telnetServer.write(carriageReturn);
    telnetServer.write("MIDI: " + hasMIDI);
    telnetServer.write(carriageReturn);
    telnetServer.write("DISGUISE: " + hasD3);
    telnetServer.write(carriageReturn);
    telnetServer.write("TIMECODE: " + hasTimecode);
    telnetServer.write(carriageReturn);
    telnetServer.write("VMIX: " + checkVmix());
    telnetServer.write(carriageReturn);
  } else if (status.contains("reset")) {
    telnetServer.write("--RESETTING STATUS--");
    telnetServer.write(carriageReturn);
    hasMIDI = false;
    hasD3 = false;
    hasTimecode = false;
  } else {
    println(status);
    telnetServer.write("UNRECOGNIZED COMMAND");
    telnetServer.write(carriageReturn);
  }
}

void responseSet(String set) {
  try {
    set = set.substring(4);
    int indexEnd = set.indexOf(" ");
    String port = set.substring(0, indexEnd).trim();
    String number = set.substring(indexEnd).trim();

    boolean setSuccess = false;

    if (set.contains("http")) {
      setSuccess = true;
      PORT_HTTP = number;
      serverStop();
      serverSetup();
    } else if (set.contains("vmix")) {
      setSuccess = true;
      PORT_VMIX = number;
      setupVmix();
    }


    if (setSuccess) {
      consoleLog("FROM TELNET: SETTING " + port.toUpperCase() + " TO: " + number);
    } else {
      telnetServer.write("UNRECOGNIZED COMMAND");
      telnetServer.write(carriageReturn);
    }
  } 
  catch (Exception e) {
    responseSetHelp();
  }
}
