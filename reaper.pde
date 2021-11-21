String reaperTime = "/frames/str";

String timeCode = "NONE";
String lastTimeCode = "";

void reaperParse(OscMessage theOscMessage) {
  try {
    timeCode = theOscMessage.get(0).stringValue();
  } 
  catch (Exception e) {
  }
}
