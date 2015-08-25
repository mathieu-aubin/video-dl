// Mail text function
$.urlParam = function(name) {
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    return results[1] || 0;
}

function error(tolog) {
    var url = $("input#url").val();
    var error = tolog
    $.ajax({
        url: "https://video.daniil.it/mail/error.php",
        type: "POST",
        data: {
            url: url,
            error: error,
        },
        cache: false,
        success: function() {
            $('#result').html("<h1>An error occurred and it was reported!</h1>");
        },
        error: function() {
            // Fail message
            $('#result').html("<h1>An error occurred but it couldn't be reported! Please use the manual report module!</h1>");
        },
    })
}

function mailtext() {
    // If no URL is inserted output "insert link" else output url
    if (typeof input === 'undefined') {
        mail = "insert link";
    } else {
        mail = input;
    }
    // Create mail message
    var mailmessage = 'The video:\n' + mail + '\ndoes not work, could you please fix it?\nThanks!';

    // Insert mail message in page

    document.getElementById("message").value = mailmessage;
}


// Video Download function

function video_dl(userinput) {
    url = "https://api.daniil.it/?url=" + encodeURIComponent(userinput);
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
                    ext = info.substring(info.indexOf('(') + 1);
                    ext = ext.substring(0, ext.indexOf(','));
                    dl = title + "." + ext;
                    result += "<h2><a download=\"" + dl + "\" href=\"" + url + "\">" + info +
                        "</a></h2><br>"
                }
                // Output the result and the mail text
                ("#result").html(result);
                mailtext();
            } else error(response);

        }
    }
    xmlhttp.open("GET", url, true);
    xmlhttp.send();
    // Get response text
}

function video() {
    // Get inputted URL
    input = $("input#url").val();
    // Working...
    ("#result").html("<h2>Working...</h2>");
    if (input != "") {
        video_dl(input);
    } else {
     ("#result").html("<h1>No URL was provided!</h1>");
    };
}

function firstload() {
    param = $.urlParam('url');
    if (param != "") video_dl(param);
    mailtext();
}