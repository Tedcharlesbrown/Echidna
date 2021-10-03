import netP5.*;
import oscP5.*;


OscP5 oscP5;
NetAddress myRemoteLocation;

void setupOSC() {
	oscP5 = new OscP5(this, 7400);
	myRemoteLocation = new NetAddress("10.71.10.160", 3333);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkTypetag("s")) {
    oscStringParse(theOscMessage.addrPattern(), theOscMessage.get(0).stringValue());
  } else if (theOscMessage.checkTypetag("f")) {
    oscFloatParse(theOscMessage.addrPattern(), theOscMessage.get(0).floatValue());
  }
}

void oscStringParse(String address, String value) {
  if (address.indexOf(d3Address) != -1) {
    d3StringParse(address, value);
  }
}

void oscFloatParse(String address, float value) {
  if (address.indexOf(d3Address) != -1) {
    d3FloatParse(address, value);
  }
}