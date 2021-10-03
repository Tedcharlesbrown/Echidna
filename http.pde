SimpleHTTPServer server;
PrintWriter output;

String[] serverText;

void serverSetup() {
  output = createWriter("data/index.html");
  server = new SimpleHTTPServer(this); 

  output.println("<!DOCTYPE html>");
  output.println("<html>");
  output.println("<head>");
  output.println("<title>Page Title</title>");
  output.println("<body>");

  output.println("<h1>");
  output.println("<h1>LX Cue Number: ");

  output.println("</body>");
  output.println("</html>");
  output.flush();

  serverText = loadStrings("index.html");
  printArray(serverText);
}

void serverDraw() {
      output = createWriter("data/index.html");

  for (int i = 0; i < serverText.length; i++) {
    if (i == 5) {
      output.print("<h1>");
      output.print(hour() + ":" + minute() + "." + second());
      output.println("</h1>");
    } else if (i == 6) {
      output.print("<h1>LX Cue Number: ");
      output.print(millis());
      output.println("</h1>");
    } else {
      //output.println(serverText[i]);
    }
  }
  output.flush();
}