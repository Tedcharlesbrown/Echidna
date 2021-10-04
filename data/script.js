    window.setInterval('refresh()', 5000);   
    // Call a function every 1000 milliseconds 

    // Refresh or reload page.
    function refresh() {
         //window .location.reload();
    }

    setInterval(function() {
            var xhr = new XMLHttpRequest();
            var timestamp = new Date().getTime();
            xhr.open('POST', 'echo');
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.onload = function() {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    document.getElementById("image").src = "webImage.png?t=" + timestamp;

                    document.getElementById("timeText").innerHTML = "Time: "+response.clock;
                    document.getElementById("timecodeText").innerHTML = "TimeCode: "+response.timeCode;

                    document.getElementById("lxNow").innerHTML = "LX Current Cue: "+response.lxCurrentCue;

                    document.getElementById("D3Now").innerHTML = "D3 Current Cue: "+response.d3CurrentCue;
                    document.getElementById("D3Next").innerHTML = "D3 Pending Cue: "+response.d3NextCue;
                    document.getElementById("D3Time").innerHTML = response.d3Time;
                }
            };
            var randomNumber = 1;
            xhr.send('{request:'+randomNumber+'}'); 
        },1000);
