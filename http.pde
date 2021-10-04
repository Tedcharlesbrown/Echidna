import http.*;

SimpleHTTPServer server;
PrintWriter output;

String[] serverText;

void serverSetup() {
  output = createWriter("data/index.html");
  server = new SimpleHTTPServer(this);
  server.serve("style.css");
  server.serve("script.js");
  server.serve("webImage.png");

  serverText = loadStrings("base.txt");

  // printArray(serverText);
}

void serverDraw() {
  output = createWriter("data/index.html");
  serverText = loadStrings("base.txt");

  for (int i = 0; i < serverText.length; i++) {

    if (serverText[i].indexOf("?TIME") != -1) {
      String hour = "";
      String minute = "";
      String second = "";

      if (hour() < 10) {
        hour = "0" + str(hour());
      } else {
        hour = str(hour());
      }
      if (minute() < 10) {
        minute = "0" + str(minute());
      } else {
        minute = str(minute());
      }
      if (second() < 10) {
        second = "0" + str(second());
      } else {
        second = str(second());
      }

      serverText[i] = serverText[i].replace("?TIME", hour + ":" + minute + "." + second);
    }


    if (serverText[i].indexOf("?TC?") != -1) {
      serverText[i] = serverText[i].replace("?TC?", timeCode);
    }

    if (serverText[i].indexOf("?LXLAST?") != -1) {
      if (!eosPreviousCue.equals("")) {
        serverText[i] = serverText[i].replace("?LXLAST?", eosPreviousCue);
      } else {
        serverText[i] = serverText[i].replace("?LXLAST?", "");
      }
    }

    if (serverText[i].indexOf("?LXCURRENT?") != -1) {
      if (!eosPreviousCue.equals("")) {
        serverText[i] = serverText[i].replace("?LXCURRENT?", eosCurrentCue);
      } else {
        serverText[i] = serverText[i].replace("?LXCURRENT?", "");
      }
    }

    if (serverText[i].indexOf("?LXNEXT?") != -1) {
      if (!eosPreviousCue.equals("")) {
        serverText[i] = serverText[i].replace("?LXNEXT?", eosPendingCue);
      } else {
        serverText[i] = serverText[i].replace("?LXNEXT?", "");
      }
    }

    output.println(serverText[i]);
  }


  output.flush();
}