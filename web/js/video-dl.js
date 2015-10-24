// Video download script, jquery version - Copyright (C) 2015 Daniil Gentili
// This program comes with ABSOLUTELY NO WARRANTY.
// This is free software, and you are welcome to redistribute it
// under certain conditions; see https://github.com/danog/video-dl/raw/master/LICENSE.


// Video Download function
// The title says it all
//
// inputurl is the url of the video (example: http://google.com)
// output is the output html element (example: #test)
// dlsupport enables or disables the download attribute (0 enables, anything disables)
// messageoutput is the output html element for the contact module 

function video_dl(output, inputurl, dlsupport, messageoutput) {
    // Console log for debugging
    console.log("input is "+inputurl+", output is "+output+" and messageoutput is "+messageoutput);
    // Check if output param exists. 
    if (!(output)) { console.log("Missing output parameter.");return; };
    // Clear output html element
    $(output).empty();
    // Check if URL is provided
    if (inputurl) {
        // Working...
        $(output).html("<h2>Working...</h2>");
        // Prepare URL for API request
        url = "https://api.daniil.it/?url=" + encodeURIComponent(inputurl);
        // Create XMLHttpRequest 
        var xmlhttp = new XMLHttpRequest();
        // Prepare request
        xmlhttp.onreadystatechange = function() {
            // When done,
            if (xmlhttp.readyState == 4 || xmlhttp.readyState == "complete") {
                // Get the response
                response = xmlhttp.responseText;
                // And prepare the output
                if (response) {
                    // Encode response in html characters, just in case
                    response = he.encode(response);
                    // Get the titles
                    var titles = response.substr(0, response.indexOf("\n"));
                    // Get the sanitized title
                    var title = titles.substr(0, response.indexOf(" "));
                    // Get the non sanitized title
                    var videoTitolo = titles.substring(response.indexOf(" ") + 1);
                    // Prepare first part of output
                    var result = "<h1><i>Video download script.</i></h1><br><h2><i>Created by <a href=\"http://daniil.it\">Daniil Gentili</a></i></h2><br><h1>Title:</h1> <h2>" +videoTitolo+ "</h2><br><h1>Available versions:</h1>";
                    // Remove the titles, keep urls
                    var lines = response.split('\n');
                    lines.splice(0, 1);
                    // Loop trough the lines (qualities)
                    for (var i = 0; i < lines.length; i++) {
                        // Get info
                        last = lines[i].lastIndexOf(" ");
                        info = lines[i].substring(0, last);
                        // Get url
                        splitr = lines[i].split(" ");
                        videourl = splitr[splitr.length - 1];
                        // Choose wherether or not to use the download attribute
                        if(dlsupport === "0") {
                            // Get video extension from info
                            ext = info.substring(info.indexOf('(') + 1);
                            ext = ext.substring(0, ext.indexOf(','));
                            // Create dl variable
                            dl = " download=\"" + title + "." + ext + "\"" ;
                            // Or dont.
                        } else { var dl = ""; };
                        // Append result to final result
                        result += "<h2><a"+ dl + " href=\"" + videourl + "\">" + info + "</a></h2><br>"
                    }
                    // Output the result
                    $(output).html(result);
                    // Else send error email
                } else error(output, inputurl, response);
            }
        }
        // Set request type
        xmlhttp.open("GET", url, true);
        // Send request
        xmlhttp.send();
        // Put error message
        if (messageoutput) { mailtext(messageoutput, in); };
        // If no URL was provided
    } else { $(output).html("<h1>No URL was provided!</h1>"); }
};

// First load function, used to output supported websites list, prepare mail message and,
// only on the video.daniil.it website, hide the php submit module and use javascript engine instead.
//
// supportedurls is the output html element for the supported websites list
//
// separatorstart is the first separator for the supported urls list: it will be put before every url, if empty defaults to <br>. 
// separatorend is the second separator for the supported urls list: it will be put after every url, if empty defaults to <br>. 
// Example:
// list is: a b c d
// separatorstart is <li>
// separatorend is </li>
// output printed to supportedurls is: <li>a</li><li>b</li><li>c</li><li>d</li>
// messageoutput
function firstload(supportedurls, separatorstart, separatorend, messageoutput, videodaniilit) {
    // If no st
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



