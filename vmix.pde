import http.requests.*;

String getIP = "http://127.0.0.1:";
String getFunction = "/api/?Function=";

void setupVmix() {

	// GetRequest get = new GetRequest("http://127.0.0.1:8088/api/?Function=KeyPress&Value=F4"); // Hotkey
	// GetRequest get = new GetRequest("http://127.0.0.1:8088/api/?Function=ActivatorRefresh"); //Check connection
// GetRequest get = new GetRequest("http://127.0.0.1:8088/api/?Function=SetText&Input=LXCue&SelectedName=Message&Value=Hello"); //change title
// GetRequest get = new GetRequest("http://127.0.0.1:8088/api/?Function=StartMultiCorder"); //Start multicorder
// GetRequest get = new GetRequest("http://127.0.0.1:8088/api/?Function=StopMultiCorder"); //Stop multicorder


	get.send();
	println(get.getContent());
}



