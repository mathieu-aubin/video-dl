// Mail text function
function mailtext() {
    // If no URL is inserted output "insert link" else output url
    if (typeof input === 'undefined') {
        mail = "insert link";
    } else {
        mail = input;
    }
    // Create mail message
    var mailmessage =
        '<a href=\'mailto:daniil.gentili.dg@gmail.com?subject=Video not working&body=The video:%0D%0A' +
        mail +
        '%0D%0Adoes not work, could you please fix it?%0D%0AThanks!\'>Not working?</a>'
        // Insert mail message in page
    document.getElementById("mail").innerHTML = mailmessage;
}

function sites() {
    var xmlHttpw = new XMLHttpRequest();
    xmlHttpw.onreadystatechange = function() {
        if (xmlHttpw.readyState == 4 || xmlHttpw.readyState == "complete") {
            websites = xmlHttpw.responseText;
            if (websites) {
                // Get the titles
                console.log(websites);
                space = "                            ";
                websitesout = "                        <ul>\n"
                var lines = websites.split('\n');
                for (var i = 0; i < lines.length; i++) {
                    websitesout += space + "<li>" + lines[i] + "</li>\n";
                }
                websitesout += "                        </ul>\n"
                // Output the result and the mail text
                document.getElementById("websites").innerHTML = websitesout;
            } else document.getElementById("websites").innerHTML = "<h1>Error!</h1>";

        }
        xmlHttpw.open("GET", "http://api.daniil.it/?p=allwebsites", true);
        xmlHttpw.send();

    }
}

// Video Download function
function video() {
    // Get inputted URL
    input = document.getElementsByTagName("input")[0].value;
    // Working...
    document.getElementById("result").innerHTML = "<h2>Working...</h2>";
    if (input != "") {
        // Prepare URL
        url = "https://api.daniil.it/?url=" + encodeURIComponent(input);
        // Prepare and send request
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 || xmlhttp.readyState == "complete") {
                response = xmlhttp.responseText;
                if (response) {
                    // Get the titles
                    var titles = response.substr(0, response.indexOf("\n"));
                    var title = titles.substr(0, response.indexOf(" "));
                    var videoTitolo = he.encode(titles.substring(response.indexOf(" ") +
                        1));
                    // Prepare first part of output
                    var result =
                        "<h1><i>Video download script.</i></h1><br><h2><i>Created by <a href=\"http://daniil.it\">Daniil Gentili</a></i></h2><br><h1>Title:</h1> <h2>" +
                        videoTitolo + "</h2><br><h1>Available versions:</h1>";
                    // Remove the titles
                    var lines = response.split('\n');
                    lines.splice(0, 1);
                    for (var i = 0; i < lines.length; i++) {
                        last = lines[i].lastIndexOf(" ");
                        info = lines[i].substring(0, last);
                        splitr = lines[i].split(" ");
                        url = splitr[splitr.length - 1];
                        dl = title;
                        result += "<h2><a download=\"\" href=\"" + url + "\">" + info +
                            "</a></h2><br>"
                    }
                    // Output the result and the mail text
                    document.getElementById("result").innerHTML = result;
                    mailtext();
                } else document.getElementById("result").innerHTML = "<h1>Error!</h1>";

            }
        }
        xmlhttp.open("GET", url, true);
        xmlhttp.send();
        // Get response text
    } else document.getElementById("result").innerHTML = "<h1>No URL was provided!</h1>";
}
mailtext();
sites();
