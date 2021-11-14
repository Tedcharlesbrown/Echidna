String d3Address = "/d3/showcontrol/";

String d3HeartAddress = d3Address + "heartbeat";
String d3PositionAddress = d3Address + "trackposition";
String d3NameAddress = d3Address + "trackname";
String d3IDAddress = d3Address + "trackid";
String d3CurrentCueAddress = d3Address + "currentsectionname";
String d3NextCueAddress = d3Address + "nextsectionname";
String d3HintAddress = d3Address + "sectionhint";
String d3VolumeAddress = d3Address + "volume";
String d3BrightnessAddress = d3Address + "brightness";
String d3BPMAddress = d3Address + "bpm";
String d3ModeAddress = d3Address + "playmode";

String d3Position = "";
String d3Mode = "";
String d3Hint = "";
String d3NextCue = "";
String d3CurrentTriggerType = "";
String d3CurrentTrigger = "";
String d3NextTriggerType = "";
String d3NextTrigger = "";
String d3ID = "";
String d3Name = "";
String d3OldCurrentCue = "";
String d3CurrentCue = "";

float d3Heart, d3Volume, d3Brightness, d3BPM;

void d3OSCParse(OscMessage theOscMessage) {
  if (theOscMessage.checkTypetag("s")) {
    d3StringParse(theOscMessage.addrPattern(), theOscMessage.get(0).stringValue());
  } else if (theOscMessage.checkTypetag("f")) {
    d3FloatParse(theOscMessage.addrPattern(), theOscMessage.get(0).floatValue());
  }
  d3Debug();
}

void d3StringParse(String address, String value) {
  try {
    if (address.indexOf(d3PositionAddress) != -1) {
      d3Position = value;
    } else if (address.indexOf(d3NameAddress) != -1) { //Track
      d3Name = value;
    } else if (address.indexOf(d3IDAddress) != -1) {
      d3ID = value;
    } else if (address.indexOf(d3CurrentCueAddress) != -1) {
      d3CurrentCue = value;
    } else if (address.indexOf(d3NextCueAddress) != -1) {
      d3NextCue = value;
    } else if (address.indexOf(d3HintAddress) != -1) {
      d3Hint = value;
      parseD3Hint(value);
    } else if (address.indexOf(d3ModeAddress) != -1) {
      d3Mode = value;
    }
  } 
  catch (Exception e) {
  }
}

void d3FloatParse(String address, float value) {
  try {
    if (address.indexOf(d3HeartAddress) != -1) {
      d3Heart = value;
    } else if (address.indexOf(d3VolumeAddress) != -1) {
      d3Volume = value;
    } else if (address.indexOf(d3BrightnessAddress) != -1) {
      d3Brightness = value;
    } else if (address.indexOf(d3BPMAddress) != -1) {
      d3BPM = value;
    }
  } 
  catch (Exception e) {
  }
}

void parseD3Hint(String value) {
  int indexStart;
  int indexEnd;

  try {

    value = value.trim();

    indexStart = value.indexOf(" ");
    indexEnd = value.indexOf("|");

    d3CurrentTriggerType = value.substring(0, indexStart).trim();

    if (indexEnd != -1) {
      d3CurrentTrigger = value.substring(indexStart, indexEnd).trim();
    } else {
      indexEnd = value.indexOf("+");
      d3CurrentTrigger = value.substring(indexStart, indexEnd).trim();
    }

    //------------------------

    indexStart = value.indexOf("+");
    value = value.substring(indexStart + 12).trim();

    indexStart = value.indexOf(" ");
    indexEnd = value.indexOf("|");

    d3NextTriggerType = value.substring(0, indexStart).trim();

    if (indexEnd != -1) {
      d3NextTrigger = value.substring(indexStart, indexEnd).trim();
    } else {
      indexEnd = value.indexOf("-");
      d3NextTrigger = value.substring(indexStart, indexEnd).trim();
    }
  } 
  catch (Exception e) {
  }
}

void outofordersync() {
  if (false) {
    if (int(lxMidiList1CueNumber) > 0) {
      if (int(lxMidiList1CueNumber) > int(d3CurrentTrigger)) {
        OscMessage myMessage = new OscMessage("/d3/showcontrol/cue");
        myMessage.add(int(d3NextTrigger));
        disguiseIn.send(myMessage, disguiseOut);
        consoleLog("OUT OF ORDER: MOVING FORWARD");
      }
      if (int(lxMidiList1CueNumber) < int(d3CurrentTrigger)) {
        int decrement = int(d3CurrentTrigger) - 1;
        while (int(lxMidiList1CueNumber) < int(d3CurrentTrigger)) {
          OscMessage myMessage = new OscMessage("/d3/showcontrol/cue");
          myMessage.add(decrement);
          disguiseIn.send(myMessage, disguiseOut);
          decrement--;
          consoleLog("OUT OF ORDER: MOVING BACKWARD");
          if (decrement <= 0) {
            return;
          }
        }
      }
    }
  }
}

void d3Debug() {
  if (!d3CurrentCue.equals(d3OldCurrentCue)) {
    debug += "<clock>" + clock + ": " + "</clock>";
    debug += "<d3>";
    debug += "D3:   ";
    debug += d3CurrentCue;
    debug += "   |   " + "<debug>";
    debug += "Position: " + d3Hint + ";";
    debug += " Next Trigger: " + d3NextTriggerType + ":" + d3NextTrigger;
    debug += "</d3>";
    debug += "</debug>";
    debug += ",";

    d3OldCurrentCue = d3CurrentCue;

    TableRow newRow = debugTable.addRow();
    newRow.setString("Time", clock);
    newRow.setString("RecordTime", millisToTimecode());
    newRow.setString("Trigger", "D3");
    newRow.setString("Timecode", timeCode);
    newRow.setString("D3 Time", d3Position);
    newRow.setString("LX Cue", lxMidiCueList + "/" + lxMidiCueNumber);
    newRow.setString("D3 Cue", d3NextTriggerType + ":" + d3NextTrigger);
    saveDebug();

    // consoleLog(clock + ":" + "D3:" + d3CurrentCue);
  }
}
