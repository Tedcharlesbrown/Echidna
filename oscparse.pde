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

