String DEFAULT_PORT_HTTP = "8000";
String DEFAULT_PORT_DISGUISE_IN = "7400";
String DEFAULT_PORT_REAPER_IN = "9000";
String DEFAULT_PORT_EOS_IN = "4444";

String DEFAULT_IP_EOS_OUT = "192.168.1.202";
String DEFAULT_PORT_EOS_OUT = "3333";

String DEFAULT_PORT_VMIX = "8088";

String DEFAULT_MIDI_INPUT = "0";
String DEFAULT_MIDI_OUTPUT = "-1";

//---

String PORT_HTTP, PORT_DISGUISE_IN, PORT_REAPER_IN, PORT_EOS_IN, IP_EOS_OUT, PORT_EOS_OUT, PORT_VMIX, MIDI_INPUT, MIDI_OUTPUT;

void defaultSettings() {
	PORT_HTTP = DEFAULT_PORT_HTTP;
	PORT_DISGUISE_IN = DEFAULT_PORT_DISGUISE_IN;
	PORT_REAPER_IN = DEFAULT_PORT_REAPER_IN;
	PORT_EOS_IN = DEFAULT_PORT_EOS_IN;

	IP_EOS_OUT = DEFAULT_IP_EOS_OUT;
	PORT_EOS_OUT = DEFAULT_PORT_EOS_OUT;

	PORT_VMIX = DEFAULT_PORT_VMIX;

	MIDI_INPUT = DEFAULT_MIDI_INPUT;
	MIDI_OUTPUT = DEFAULT_MIDI_OUTPUT;
}



PrintWriter settingsOut;

void setupSettings() {
	defaultSettings();
	String[] settings = loadStrings("data/settings.txt");
	try {
		int arrayLength = settings.length;
		for (int i = 0; i < arrayLength; i++) {
			int indexStart = settings[i].indexOf(":");
			String value = settings[i].substring(indexStart + 1).trim();

			switch (i) {
			case 0:
				PORT_HTTP = value;
				break;
			case 1:
				PORT_DISGUISE_IN = value;
				break;
			case 2:
				PORT_REAPER_IN = value;
				break;
			case 3:
				MIDI_INPUT = value;
				break;
			}
		}
	} catch (Exception e) {
		settingsOut = createWriter("data/settings.txt");
		settingsOut.print("HTTP PORT: ");
		settingsOut.println(DEFAULT_PORT_HTTP);
		settingsOut.print("D3 PORT IN: ");
		settingsOut.println(DEFAULT_PORT_DISGUISE_IN);
		settingsOut.print("REAPER PORT IN: ");
		settingsOut.println(DEFAULT_PORT_REAPER_IN);
		// settingsOut.print("EOS PORT IN: ");
		// settingsOut.println(DEFAULT_PORT_EOS_IN);
		// settingsOut.println(DEFAULT_IP_EOS_OUT);
		// settingsOut.println(DEFAULT_PORT_EOS_OUT);
		settingsOut.print("MIDI INPUT: ");
		settingsOut.println(DEFAULT_MIDI_INPUT);
		// settingsOut.println(DEFAULT_MIDI_OUTPUT);

		settingsOut.flush();
		settingsOut.close();
	}
	// printArray(settings);

}