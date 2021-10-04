String reaperTime = "/frames/str";

String timeCode = "";

void reaperParse(OscMessage theOscMessage) {
	timeCode = theOscMessage.get(0).stringValue();
}