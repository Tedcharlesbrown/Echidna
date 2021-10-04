import netP5.*;
import oscP5.*;

OscP5 disguiseIn, eosIn, reaperIn;
NetAddress eosOut;


void setupOSC() {
	disguiseIn = new OscP5(this, 7400);
	reaperIn = new OscP5(this, 9000);
	eosIn = new OscP5(this, 4444);
	eosOut = new NetAddress("192.168.1.202", 3333);
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

