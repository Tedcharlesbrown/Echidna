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

String d3Position, d3Name, d3ID, d3CurrentCue, d3NextCue, d3Hint, d3Mode;
float d3Heart, d3Volume, d3Brightness, d3BPM;

void d3OSCParse(OscMessage theOscMessage) {
  if (theOscMessage.checkTypetag("s")) {
    d3StringParse(theOscMessage.addrPattern(), theOscMessage.get(0).stringValue());
  } else if (theOscMessage.checkTypetag("f")) {
    d3FloatParse(theOscMessage.addrPattern(), theOscMessage.get(0).floatValue());
  }
}

void d3StringParse(String address, String value) {
  if (address.indexOf(d3PositionAddress) != -1) {
    d3Position = value;
  } else if (address.indexOf(d3NameAddress) != -1) {
    d3Name = value;
  } else if (address.indexOf(d3IDAddress) != -1) {
    d3ID = value;
  } else if (address.indexOf(d3CurrentCueAddress) != -1) {
    d3CurrentCue = value;
  } else if (address.indexOf(d3NextCueAddress) != -1) {
    d3NextCue = value;
  } else if (address.indexOf(d3HintAddress) != -1) {
    d3Hint = value;
  } else if (address.indexOf(d3ModeAddress) != -1) {
    d3Mode = value;
  }
}

void d3FloatParse(String address, float value) {
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
