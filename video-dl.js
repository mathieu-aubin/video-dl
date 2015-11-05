/* Video download script, jquery version - Copyright (C) 2015 Daniil Gentili
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it under certain conditions; see https://github.com/danog/video-dl/raw/master/LICENSE.

Video Download function

Usage:
video_dl(output, inputurl, dlsupport, messageoutput)

Parameters:

output: output html element for the video info and the download urls. Required.
example: #result


inputurl: url of the video. Required.
example: $("input#urljs").val()

dlsupport: enables or disables the download attribute in the download links. Optional.
0 enables, anything disables

messageoutput: output html element for the contact module. Optional.
example: #message

Example: 
video_dl("#result", $("input#urljs").val(), "0", "#message");

Let's say the input#urljs text field has value "http://www.winx.rai.it/dl/RaiTV/programmi/media/ContentItem-a27ccfe8-b824-4e85-9a08-d15e57fb61a0.html#p=0".

The function will get the value of the input#urljs element, get the download links from the API, and return the following output to the #result element:

<h1 style="font-style: italic;">Video download script.</h1><br><h2 style="font-style: italic;">Created by <a href="http://daniil.it">Daniil Gentili</a></h2><br><h1>Title:</h1> <h2>26 - Il potere degli animali fatati - Winx Club VII del 03/10/2015</h2><br><h1>Available versions:</h1><br><h2><a href="http://creativemedia4.rai.it/Italy/podcastcdn/junior/Winx/Winx_7_EP_Puntate/4524680.mp4" download="26_Il_potere_degli_animali_fatati_Winx_Club_VII_del_03102015.mp4">Normal quality (mp4, 267 MiB, 720x404)</a><br></h2>

The function will then start the mailtext function with the following parameters:
mailtext(messageoutput, inputurl);

See mailtext description for the result.
*/

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
                    // Else primt error
                } else $(output).html("<h1>An error occurred and it was reported!");
            }
        }
        // Set request type
        xmlhttp.open("GET", url, true);
        // Send request
        xmlhttp.send();
        // Put url to contact module
        if (messageoutput) { mailtext(messageoutput, inputurl); };
        // If no URL was provided
    } else { $(output).html("<h1>No URL was provided!</h1>"); }
};

/*
First load function, used to output supported websites list, prepare mail message and,
only on the video.daniil.it website, hide the php submit module and use javascript engine instead.

Usage: firstload(supportedurls, separatorstart, separatorend, messageoutput, videodaniilit)

Parameters:

supportedurls: output html element for the supported websites list. Required.
Example: #supportedurls

separatorstart: first separator for the supported urls list: it will be put before every item in the supported websites list, if empty defaults to <br>.
Optional, recommended.
Example: <li>

separatorend: the second separator for the supported urls list: it will be put after every url, if empty defaults to <br>. Optional, recommended.
Example: </li>

messageoutput: output html element for default contact module text. Optional, recommended.
Example: #contact

videodaniilit: If on video.daniiil.it hides php module and unhides javascript text field. Do not use.

Example:
firstload("#supportedurls", "<li>", "</li>", "#message");

Let's say the url list is: a b c d

Output printed to #supportedurls is:
<li>a</li><li>b</li><li>c</li><li>d</li><a href=\"http://lol.daniil.it\" target=\"_blank\">&#9786;</a></li>
This will also create the default contact module text with
mailtext("#message"); 

*/

function firstload(supportedurls, separatorstart, separatorend, messageoutput, videodaniilit) {

    // If no separator is set, set them to <BR>
    if (!((separatorstart) && (separatorend))) { var separatorstart = "<br>"; var separatorstart = separatorend; };

    // Clear supportedurls element
    $(supportedurls).empty();
    // Write working... to supportedurls element
    $(supportedurls).html("<h3>Working...</h3>");

    // Set request url
    url = "https://api.daniil.it/?p=allwebsites";

    // Create request
    var xmlhttp = new XMLHttpRequest();

    // What to do after request success
    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 || xmlhttp.readyState == "complete") {
            // Set response text
            response = xmlhttp.responseText;
            // If response isn't empty
            if (response) {
                // If on video.daniiil.it hide php module and unhide javascript text field.

                if (videodaniilit) {
                    $("#js").css("display", "block");
                    $("#php").css("display", "none");
                    $("#jsd").css("display", "block");
                    $("#phpd").css("display", "none");
                };
                // Replace newlines in response with separators
                response = he.encode(response).replace(/\n/g, separatorend+separatorstart);

                // Output the result and the mail text
                $(supportedurls).html(separatorstart+response+"<a href=\"http://lol.daniil.it\" target=\"_blank\">&#9786;</a>"+separatorend);
                // Linkify output
                $(supportedurls).linkify({
                    target: "_blank"
                });
            }
        }
    }
    // Setup request
    xmlhttp.open("GET", url, true);
    // Send request
    xmlhttp.send();
    // Create default contact module text
    mailtext(messageoutput);

};

/*
Contact module function.
Prints a nice message to the contact module text field, with the url if it's provided else just With "insert link".

Usage: 
mailtext(output, url)

Parameters:

output: html entity where to print out the contact message. Required.
Example: #contact

url: url of the video to insert into the message. Not required, if not provided defaults to insert link.

Example:
mailtext("#contact", "http://google.com");

Will put "The video:
http://google.com
does not download, could you please fix it
Thanks!" to #contact.
*/
function mailtext(output, url) {
    // Check for required params.
    if (!(output)) { console.log("Missing required params.");return; };

    // If url isn't empty, put it in the message
    if (url) {
        mail = url;
    } else {
        // Else put insert link instead.
        mail = "insert link";
    }

    // Create mail message
    var mailmessage = 'The video:\n' + mail + '\ndoes not download, could you please fix it?\nThanks!';

    // Insert mail message in page
    $(output).html(mailmessage);
};





