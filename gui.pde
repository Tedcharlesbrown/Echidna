import controlP5.*;

ControlP5 cp5;

void setupGui() {
	cp5 = new ControlP5(this);

	cp5.addTextfield("HTTP PORT")
	.setValue(PORT_HTTP)
	.setPosition(20, 20)
	.setSize(100, 40)
	.setFont(createFont("arial",20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addTextfield("DISGUISE IN PORT")
	.setValue(PORT_DISGUISE_IN)
	.setPosition(220, 20)
	.setSize(100, 40)
	.setFont(createFont("arial",20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addTextfield("REAPER IN PORT")
	.setValue(PORT_REAPER_IN)
	.setPosition(420, 20)
	.setSize(100, 40)
	.setFont(createFont("arial",20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;

	cp5.addTextfield("MIDI IN PORT")
	.setValue(MIDI_INPUT)
	.setPosition(620, 20)
	.setSize(100, 40)
	.setFont(createFont("arial",20))
	.setFocus(false)
	.setColor(color(255, 0, 0))
	.setAutoClear(false)
	;
}

// void controlEvent(ControlEvent theEvent) {
//   if(theEvent.isAssignableFrom(Textfield.class)) {
//     println("controlEvent: accessing a string from controller '"
//             +theEvent.getName()+"': "
//             +theEvent.getStringValue()
//             );
//   }
// }

// public void input(String theText) {
//   // automatically receives results from controller input
//   println("a textfield event for controller 'input' : "+theText);
// }
