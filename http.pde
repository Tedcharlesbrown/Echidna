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

void serverDraw() 