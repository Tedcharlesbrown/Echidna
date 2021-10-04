String eosActiveCue = "/eos/out/";

String eosCurrentCue = "";
String eosPreviousCue = "";
String eosPendingCue = "";
String eosPendingCueTime = "";
String eosCurrentCuePercentage = "";
String eosCurrentCueTime = "";

void eosOSCParse(OscMessage theOscMessage) {
	String address = theOscMessage.addrPattern();

	if (theOscMessage.checkTypetag("s")) {
		String argumentZero = theOscMessage.get(0).stringValue();
		if (address.equals("/eos/out/previous/cue/text") && argumentZero.length() != 0) {
			eosPreviousCue = eosCueParse(argumentZero).get(0);
		} else if (address.equals("/eos/out/active/cue/text") && argumentZero.length() != 0) {
			eosCurrentCue = eosCueParse(argumentZero).get(0);
		} else if (address.equals("/eos/out/pending/cue/text") && argumentZero.length() != 0) {
			eosPendingCue = eosCueParse(argumentZero).get(0);
			eosPendingCueTime = eosCueParse(argumentZero).get(1);
		}
	}
}


StringList eosCueParse(String argument) {

	StringList returnArgument;
	returnArgument = new StringList();

	String cue = "";
	String time = "";
	String percentage = "";

	int index = argument.indexOf(" ");
	cue = argument.substring(0, index);
	returnArgument.set(0, cue);

	argument = argument.substring(index + 1);
	index = argument.indexOf(" ");

	if (index == -1) { //If end of message, no percentage...
		returnArgument.set(1, time);
	} else if (argument.indexOf("100%") != -1) {
		time = argument.substring(0, index);
		percentage = "100%";
		returnArgument.set(1, time);
		returnArgument.set(2, percentage);
	} else {
		percentage = argument.substring(index + 1);
		returnArgument.set(2, percentage);
	}

	return returnArgument;

}