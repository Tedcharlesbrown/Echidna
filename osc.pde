import netP5.*;
import oscP5.*;

OscP5 disguiseIn, eosIn, reaperIn;
NetAddress disguiseOut, eosOut;


void setupOSC() {
	disguiseIn = new OscP5(this, int(PORT_DISGUISE_IN));
	
	reaperIn = new OscP5(this, int(PORT_REAPER_IN));
	// eosIn = new OscP5(this, int(PORT_EOS_IN));
	// eosOut = new NetAddress(IP_EOS_OUT, int(PORT_EOS_OUT));
	disguiseOut = new NetAddress("192.168.0.255", int(PORT_DISGUISE_IN) + 1);
}

void stopOSC() {
	disguiseIn.stop();
	reaperIn.stop();
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
	String address = theOscMessage.addrPattern();
	if (address.indexOf(d3Address) != -1) { //From D3
		d3OSCParse(theOscMessage);
	} else if (address.indexOf(eosActiveCue) != -1) { //From EOS
		eosOSCParse(theOscMessage);
	} else if (address.indexOf(reaperTime) != -1) { //From REAPER
		reaperParse(theOscMessage);
	}
}

