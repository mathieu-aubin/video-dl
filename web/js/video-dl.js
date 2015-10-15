/*
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
*/

function error(output, url, error) {
    if (!((url) && (output))) { console.log("Missing required params.");return; };
    var domain = 3;
    console.log(error);
    if (!(error)) { var error = "Empty Response"; };
    $.ajax({
        url: "https://mail.daniil.it/",
        type: "POST",
        data: {
            url: url,
            error: error,
            domain: domain
        },
        cache: false,
        success: function() {
            $(output).html("<h1>An error occurred and it was reported!</h1>");
        },
        error: function() {
            // Fail message
            $(output).html("<h1>An error occurred but it couldn't be reported! Please use the manual report module!</h1>");
        },
    })
};

function mailtext(output, url) {
    if (!(output)) { console.log("Missing required params.");return; };

    // Create mail message
    if (url) {
        mail = url;
    } else {
        mail = "insert link";
    }
    var mailmessage = 'The video:\n' + mail + '\ndoes not work, could you please fix it?\nThanks!';

    // Insert mail message in page
    $(output).html(mailmessage);
};


// Video Download function

function video_dl(userinput, output, asupport, messageoutput) {
    console.log("input is "+userinput+", output is "+output+" and messageoutput is "+messageoutput);
    $(output).empty();
    if (!(output)) { console.log("Missing output parameter.");return; };

    if (userinput) {
        $(output).html("<h2>Working...</h2>");
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
                    var videoTitolo = titles.substring(response.indexOf(" ") + 1);
                    // Prepare first part of output
                    var result = "<h1><i>Video download script.</i></h1><br><h2><i>Created by <a href=\"http://daniil.it\">Daniil Gentili</a></i></h2><br><h1>Title:</h1> <h2>" +videoTitolo+ "</h2><br><h1>Available versions:</h1>";
                    // Remove the titles
                    var lines = response.split('\n');
                    lines.splice(0, 1);
                    for (var i = 0; i < lines.length; i++) {
                        last = lines[i].lastIndexOf(" ");
                        info = lines[i].substring(0, last);
                        splitr = lines[i].split(" ");
                        url = splitr[splitr.length - 1];
                        if(asupport === "0") {
                            ext = info.substring(info.indexOf('(') + 1);
                            ext = ext.substring(0, ext.indexOf(','));
                            dl = " download=\"" + title + "." + ext + "\"" ;
                        } else { var dl = ""; };
                        result += "<h2><a"+ dl + " href=\"" + url + "\">" + info + "</a></h2><br>"
                    }
                    // Output the result and the mail text
                    $(output).html(result);
                    
                } else error(output, userinput, response);

            }
        }
        xmlhttp.open("GET", url, true);
        xmlhttp.send();
        // Put error message
        if (messageoutput) { mailtext(messageoutput, userinput); };
    } else { $(output).html("<h1>No URL was provided!</h1>"); }
};

function firstload(supportedurls, separatorstart, separatorend, messageoutput, videodaniilit) {
    if (!((separatorstart) && (separatorend))) { var separatorstart = "<br>"; var separatorstart = separatorend; };
    $(supportedurls).empty();
    $(supportedurls).html("<h3>Working...</h3>");

    url = "https://api.daniil.it/?p=allwebsites";
    // Prepare and send request
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 || xmlhttp.readyState == "complete") {
            response = xmlhttp.responseText;
            if (response) {
                if (videodaniilit) {
                    $("#js").css("display", "block");
                    $("#php").css("display", "none");
                    $("#jsd").css("display", "block");
                    $("#phpd").css("display", "none");
                };
                response = he.encode(response).replace(/\n/g, separatorend+separatorstart);
                // Output the result and the mail text
                $(supportedurls).html(separatorstart+response+"<a href=\"http://lol.daniil.it\" target=\"_blank\">&#9786;</a>"+separatorend);
                $(supportedurls).linkify({
                    target: "_blank"
                });
            }
        }
    }
    xmlhttp.open("GET", url, true);
    xmlhttp.send();
    mailtext(messageoutput);

};
