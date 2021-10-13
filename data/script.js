var fileName = "";

document.onload = getFileName();

setInterval(function() {
    var xhr = new XMLHttpRequest();
    var timestamp = new Date().getTime();
    xhr.open('POST', 'echo');
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onload = function() {
        if (xhr.status === 200) {
            var response = JSON.parse(xhr.responseText);

            document.getElementById("timeText").innerHTML = response.clock;
            document.getElementById("timecodeText").innerHTML = response.timeCode;

            document.getElementById("D3Now").innerHTML = response.d3CurrentCue;
            document.getElementById("D3Next").innerHTML = response.d3NextCue;
            document.getElementById("D3NextTrigger").innerHTML = response.d3NextTrigger;


            if (fileName != "debug.html") {
                document.getElementById("feed").src = "showfeed.png?t=" + timestamp;
                document.getElementById("multiview").src = "multiview.png?t=" + timestamp;
                document.getElementById("lxNow").innerHTML = response.lxCurrentList1Cue;

                parseHistory(response.lxHistory);
            }

            if (fileName == "debug.html") {
                document.getElementById("D3Position").innerHTML = response.d3Position;
                document.getElementById("D3Hint").innerHTML = response.d3Hint;
                document.getElementById("D3Track").innerHTML = response.d3Name;
                document.getElementById("D3Mode").innerHTML = response.d3Mode;

                document.getElementById("lxMidiRaw").innerHTML = response.lxMidiRaw;
                document.getElementById("lxDeviceID").innerHTML = response.lxDeviceID;
                document.getElementById("lxCommandFormat").innerHTML = response.lxCommandFormat;
                document.getElementById("lxCommand").innerHTML = response.lxCommand;
                document.getElementById("lxCommandData").innerHTML = response.lxCommandData;

                document.getElementById("lxNowAll").innerHTML = response.lxNowAll;
                document.getElementById("lxCueList").innerHTML = response.lxCueList;
            }

        }
    };
    var randomNumber = 1;
    xhr.send('{request:' + randomNumber + '}');
}, 1000);

function parseHistory(response) {
    var lxHistory = [];
    var responseArray = response.split(",");
    for (var i = 0; i < responseArray.length - 1; i++) {
        if (responseArray[i].indexOf("[") != -1) {
            lxHistory.unshift("<highlight>" + responseArray[i] + "</highlight>" + "<br>");
        } else {
            lxHistory.unshift(responseArray[i] + "<br>");
        }
    }

    var output = lxHistory.join('');
    output = output.replace(',', '');

    document.getElementById("consoleText").innerHTML = output;
}

function getFileName() {
    fileName = location.pathname.split("/".slice(-1));
    fileName = fileName[1];
}