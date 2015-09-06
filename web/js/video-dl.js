var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;
    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

function error(error, url) {
    var domain = 3;
    console.log(error)
    $.ajax({
        url: "https://mail.daniil.it/",
        type: "POST",
        data: {
            url: url,
            error: error,
            domain: domain,
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
};

function mailtext(url) {
    // 
    if (url) {
        mail = url;
    } else {
        mail = "insert link";
    }
    // Create mail message
    var mailmessage = 'The video:\n' + mail + '\ndoes not work, could you please fix it?\nThanks!';

    // Insert mail message in page

    $("#message").html(mailmessage);
};


// Video Download function


// Video Download function
function video_dl(userinput) {
    $("#result").empty();
    if (userinput) {
        $("#result").html("<h2>Working...</h2>");
        url = "https://api.daniil.it/?url=" + encodeURIComponent(userinput);
        // Prepare and send request
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 || xmlhttp.readyState == "complete") {
                response = xmlhttp.responseText;
                if (response) {
                    response = he.encode(response);
                    // Get the titles
                    var titles = response.substr(0, response.indexOf("\n"));
                    var title = titles.substr(0, response.indexOf(" "));
                    var videoTitolo = titles.substring(response.indexOf(" ") +
                        1);
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
                    $("#result").html(result);
                    
                } else error(response, userinput);

            }
        }
        xmlhttp.open("GET", url, true);
        xmlhttp.send();
        // Get response text
        mailtext(userinput);
    } else {
        $("#result").html("<h1>No URL was provided!</h1>");
    };
};

function video() {
    input = $("input#urljs").val();
    video_dl(input);
};
function firstload() {
    mailtext();
    document.getElementById("js").style.display = "block";
    document.getElementById("php").style.display = "none";
    document.getElementById("jsd").style.display = "block";
    document.getElementById("phpd").style.display = "none";

};
