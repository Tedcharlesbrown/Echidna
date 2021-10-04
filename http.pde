import http.*;

SimpleHTTPServer server;
PrintWriter output;

String[] serverText;

String clock;

void serverSetup() {
  output = createWriter("data/index.html");

  server = new SimpleHTTPServer(this);
  DynamicResponseHandler responder = new DynamicResponseHandler(new JSONEcho(), "application/json");
  server.createContext("echo", responder);

  server.serve("style.css");
  server.serve("script.js");
  server.serve("webImage.png");

  serverText = loadStrings("base.txt");

  // printArray(serverText);
}

class JSONEcho extends ResponseBuilder {
  public  String getResponse(String requestBody) {
    JSONObject json = parseJSONObject(requestBody);
    // println(json);
    // int number = json.getInt("requestClock");
    json.setString("clock", clock);
    json.setString("timeCode", timeCode);

    json.setString("lxCurrentCue", cueNumber);


    json.setString("d3CurrentCue", d3CurrentCue);
    json.setString("d3NextCue", d3NextCue);
    json.setString("d3Time",d3Hint);
    return json.toString();
  }
}

void serverDraw() {
  output = createWriter("data/index.html");
  serverText = loadStrings("base.txt");

  for (int i = 0; i < serverText.length; i++) {

  //   if (serverText[i].indexOf("?TIME?") != -1) {
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

      clock = hour + ":" + minute + "." + second;

  //     serverText[i] = serverText[i].replace("?TIME?", clock);
  //   }


  //   if (serverText[i].indexOf("?TC?") != -1) {
  //     if (timeCode.equals("")) {
  //       serverText[i] = serverText[i].replace("?TC?", timeCode);
  //     } else {
  //       serverText[i] = serverText[i].replace("?TC?", "");
  //     }
      
  //   }

  //   if (serverText[i].indexOf("?LXNOW?") != -1) {
  //     if (!cueNumber.equals("")) {
  //       serverText[i] = serverText[i].replace("?LXNOW?", cueNumber);
  //     } else {
  //       serverText[i] = serverText[i].replace("?LXNOW?", "");
  //     }
  //   }

  //   if (serverText[i].indexOf("?LXNEXT?") != -1) {
  //     if (!eosPreviousCue.equals("")) {
  //       serverText[i] = serverText[i].replace("?LXNEXT?", eosPendingCue);
  //     } else {
  //       serverText[i] = serverText[i].replace("?LXNEXT?", "");
  //     }
  //   }

  //   if (serverText[i].indexOf("?D3NOW?") != -1) {
  //     if (!d3CurrentCue.equals("")) {
  //       serverText[i] = serverText[i].replace("?D3NOW?", d3CurrentCue);
  //     } else {
  //       serverText[i] = serverText[i].replace("?D3NOW?", "");
  //     }
  //   }

  //   if (serverText[i].indexOf("?D3NEXT?") != -1) {
  //     if (!d3NextCue.equals("")) {
  //       serverText[i] = serverText[i].replace("?D3NEXT?", d3NextCue);
  //     } else {
  //       serverText[i] = serverText[i].replace("?D3NEXT?", "");
  //     }
  //   }

  //   if (serverText[i].indexOf("?D3TIME?") != -1) {
  //     if (!d3Hint.equals("")) {
  //       serverText[i] = serverText[i].replace("?D3TIME?", d3Hint);
  //     } else {
  //       serverText[i] = serverText[i].replace("?D3TIME?", "");
  //     }
  //   }

  //   if (serverText[i].indexOf("?CONSOLE?") != -1) {
  //     if (!eosPreviousCue.equals("")) {
  //       //serverText[i] = serverText[i].replace("?LXNEXTTIME?", eosPendingCue);
  //     } else {
  //       serverText[i] = serverText[i].replace("?CONSOLE?", "");
  //     }
  //   }

    output.println(serverText[i]);
  }


  output.flush();
}