<?php
// Video download script, php version - Copyright (C) 2015 Daniil Gentili
// This program comes with ABSOLUTELY NO WARRANTY.
// This is free software, and you are welcome to redistribute it
// under certain conditions; see https://github.com/danog/video-dl/raw/master/LICENSE.

ini_set("log_errors", 1);
ini_set("error_log", "/tmp/php-errorv.log");
error_log( "Hello, errors video!" );
$uacheck = preg_match_all("/Version\/[0-9]\.[0-9]\sChrome\S*\sMobile|;\swv|\sAppleWebKit\/[0-9]*\.[0-9]*\s[(]KHTML,\slike\sGecko[)]\sVersion\/[0-9]\.[0-9]\s/", $_SERVER['HTTP_USER_AGENT']);
error_log($uacheck);

$keys = file_get_contents("https://api.daniil.it/?p=allwebsites");
$keys = preg_replace('/\n/', ', ', $keys);

if(isset($_GET['url'])) {
    if($_GET['url'] == "") {
        $output = "<h1>No URL was provided. </h1>";
    } else {
        $mail = $_GET["url"];
        $url = urlencode($_GET["url"]);
        $response = file_get_contents("https://api.daniil.it/?url=$url");
        if($response != "") {
            $readyformats = '<h2>';
            $formats = preg_replace('/^.+\n/', '', $response);
            $titles = strtok($response, "\n");
            $title = preg_replace('/ .*$/', '', $titles);
            $videoTitolo = preg_replace('/(?:^)(\w+)\s/', '', $titles); 
            error_log("title is $title. and videot is $videoTitolo and titles are $titles");
            $arrfinal = explode("\n", $formats);
            foreach ($arrfinal as $key => $value) {
                $finalarrspace = explode(' ', trim($arrfinal[$key]));
                $url = htmlentities(array_pop($finalarrspace));
                $info = implode(' ',$finalarrspace);
                if("$uacheck" == "0" ) {
                    $ext = preg_replace('/,.*$/', '', preg_replace('/^.*[(]\s*/', '', $info));
                    $download = " download=\"$title.$ext\"";
                 };
                $readyformats = "$readyformats<BR><a href=\"$url\"$download>$info</a><br>";
            };
        
            $output = '<h1 style="font-style: italic;">Video download script.</h1><br><h2 style="font-style: italic;">Created by <a href="http://daniil.it">Daniil Gentili</a></h2><br><h1>Title:</h1> <h2>'.$videoTitolo."</h2><br><h1>Available versions:</h1><br>$readyformats</h2>";
        } else {
             $output = "<h1>An error occurred and it was reported.</h1>";
        }
    }
} else {
    $mail = "insert link";
};

?>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Download videos from YouTube, Rai, Rai Replay, Video Mediaset, La7, Witty TV, Dplay and lots of other websites!">
    <meta name="keywords" content="pasty.link, mediaset, mediaset.it, rai, link, download, video, Rai.tv, paste, senza Silverlight, scaricare, scaricare video rai, without Silverlight, streaming, vlc, videos, mediaset, Mediaset, il segreto, il segreto Mediaset, video mediaset, la7, la7 TV, scaricare video, youtube, download, download videos from, <?= $keys ?>">
    <meta name="author" content="Daniil Gentili">

    <title>Download Videos!</title>

    <script src="/pace/pace.min.js"></script>
    <link href="/pace/theme.css?v=32glol3d4" rel="stylesheet" />
    <!-- Begin Cookie Consent plugin by Silktide - http://silktide.com/cookieconsent -->
    <script type="text/javascript">
        window.cookieconsent_options = {
            "message": "This website uses cookies to ensure you get the best experience on our website",
            "dismiss": "Got it!",
            "learnMore": "More info",
            "link": "http://cookie.daniil.it/?w=video",
            "theme": "light-bottom"
        };
    </script>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/1.0.9/cookieconsent.min.js"></script>
    <!-- End Cookie Consent plugin -->

    <!-- Favicon -->
    <link rel="apple-touch-icon" sizes="57x57" href="/favicons/apple-touch-icon-57x57.png?v=ngg3edNEPX">
    <link rel="apple-touch-icon" sizes="60x60" href="/favicons/apple-touch-icon-60x60.png?v=ngg3edNEPX">
    <link rel="apple-touch-icon" sizes="72x72" href="/favicons/apple-touch-icon-72x72.png?v=ngg3edNEPX">
    <link rel="apple-touch-icon" sizes="76x76" href="/favicons/apple-touch-icon-76x76.png?v=ngg3edNEPX">
    <link rel="apple-touch-icon" sizes="114x114" href="/favicons/apple-touch-icon-114x114.png?v=ngg3edNEPX">
    <link rel="apple-touch-icon" sizes="120x120" href="/favicons/apple-touch-icon-120x120.png?v=ngg3edNEPX">
    <link rel="apple-touch-icon" sizes="144x144" href="/favicons/apple-touch-icon-144x144.png?v=ngg3edNEPX">
    <link rel="apple-touch-icon" sizes="152x152" href="/favicons/apple-touch-icon-152x152.png?v=ngg3edNEPX">
    <link rel="apple-touch-icon" sizes="180x180" href="/favicons/apple-touch-icon-180x180.png?v=ngg3edNEPX">
    <link rel="icon" type="image/png" href="/favicons/favicon-32x32.png?v=ngg3edNEPX" sizes="32x32">
    <link rel="icon" type="image/png" href="/favicons/android-chrome-192x192.png?v=ngg3edNEPX" sizes="192x192">
    <link rel="icon" type="image/png" href="/favicons/favicon-96x96.png?v=ngg3edNEPX" sizes="96x96">
    <link rel="icon" type="image/png" href="/favicons/favicon-16x16.png?v=ngg3edNEPX" sizes="16x16">
    <link rel="manifest" href="/favicons/manifest.json?v=ngg3edNEPX">
    <link rel="shortcut icon" href="/favicons/favicon.ico?v=ngg3edNEPX">
    <meta name="apple-mobile-web-app-title" content="Download videos">
    <meta name="application-name" content="Download videos">
    <meta name="msapplication-TileColor" content="#9f00a7">
    <meta name="msapplication-TileImage" content="/favicons/mstile-144x144.png?v=ngg3edNEPX">
    <meta name="theme-color" content="#ff66ff">


    <!-- Share -->
    <script type="text/javascript">
        var switchTo5x = true;
    </script>
    <script type="text/javascript" src="https://ws.sharethis.com/button/buttons.js"></script>
    <script type="text/javascript">
        stLight.options({
            publisher: "1b773233-532c-4931-8518-d3426890a6fc",
            doNotHash: false,
            doNotCopy: false,
            hashAddressBar: false
        });
    </script>


    <!-- Bootstrap Core CSS - Uses Bootswatch Flatly Theme: http://bootswatch.com/flatly/ -->
    <link href="css/bootstrap.min.css?v=loloolol" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="css/freelancer.css?v=omgomgomgogmglolololololool" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Lato:400,700,400italic,700italic" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>
<body id="page-top" class="index" onload='firstload("#supportedurls", "<li>", "</li>", "#message", "y");'>
    <!-- jQuery -->
    <script src="js/jquery.js"></script>

    <!-- Video download CDN version -->
    <script src="//daniil.it/video-dl/video-dl.min.js"></script>



    <!-- Google Analytics -->
    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o) [0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

      ga('create', 'UA-50691719-7', 'auto');
      ga('send', 'pageview');

    </script>

    <!-- Navigation -->
    <nav class="navbar navbar-default navbar-fixed-top">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header page-scroll">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#page-top">Download videos!</a>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-right">
                    <li class="hidden">
                        <a href="#page-top"></a>
                    </li>
                    <li>
                        <a href="#contact" class="portfolio-link" data-toggle="modal">Doesn&apos;t work?</a>
                    </li>
                    <li class="portfolio-item">
                        <a href="#support" class="portfolio-link" data-toggle="modal">Supported websites</a>
                    </li>

                    <li>
                        <a href="https://github.com/danog/video-dl/" target="_blank">Fork me on GitHub!</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container-fluid -->
    </nav>

    <!-- Header -->
    <!-- Header -->
    <header>
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <a class="page-scroll" href="#description"><img class="img-responsive img-centered" src="img/profile.png?v=2" onclick='video_dl("#result", $("input#urljs").val(), "<?= $uacheck ?>", "#message");' alt=""></a>
                    <div class="intro-text">
                        <span class="name">Download videos!</span>

                        <hr class="star-light">
                        <span class="skills giallo" id="description">Download videos from <a href="http://youtube.com" target="_blank">YouTube</a>, <a href="http://rai.tv" target="_blank">Rai</a>, <a href="http://www.rai.tv/dl/replaytv/replaytv.html#" target="_blank">Rai Replay</a>, <a href="http://video.mediaset.it" target="_blank">Video Mediaset</a>, <a href="http://la7.it" target="_blank">La7</a>, <a href="http://wittytv.it" target="_blank">Witty TV</a>, <a href="http://dplay.com" target="_blank">Dplay</a> <a href="#support" class="portfolio-link"  data-toggle="modal">and lots of other websites</a>!<br>Paste the URL of the video:<BR></span>

                        <br>
                        <br>
                        <form action="//video.daniil.it/" method="get" id="php">

                            <input type="text" name="url" class="form-control" placeholder="URL of the video" id="url" required data-validation-required-message="Please enter a URL."><button type="submit" class="btn btn-success btn-lg">Download the video!</button>
                        </form>
                        <div style="display:none" id="js">
                            <input onchange='video_dl("#result", $("input#urljs").val(), "<?= $uacheck ?>", "#message");' type="text" class="form-control" placeholder="URL of the video" id="urljs" required data-validation-required-message="Please enter a URL.">
                            <button onclick='video_dl("#result", $("input#urljs").val(), "<?= $uacheck ?>", "#message");' type="submit" class="btn btn-success btn-lg">Download the video!</button>
                            <p class="help-block text-danger"></p>
                        </div>
                        <div id="result"><?= $output ?></div>

                        <br>
                        <br>
                        <span class='st_sharethis_large'></span>
                        <span class='st_facebook_large'></span>
                        <span class='st_twitter_large'></span>
                        <span class='st_linkedin_large'></span>
                        <span class='st_pinterest_large'></span>
                        <span class='st_email_large'></span>
                        <br>
                        <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
                        <!-- Video dl -->
                        <ins class="adsbygoogle" style="display:block" data-ad-client="ca-pub-9170713829503075" data-ad-slot="7872471747" data-ad-format="auto"></ins>
                        <script>
                            (adsbygoogle = window.adsbygoogle || []).push({});
                        </script>
                        <span class="skills giallo" id="incorporation">You can incorporate this video download script in your website! Just follow <A href="//daniil.it/video-dl#incorporation" target="_blank">these instructions! </A></span>
                    </div>
                </div>
            </div>
        </div>
    </header>
    <!-- Footer -->
    <footer class="text-center">
        <div class="footer-above">
            <div class="container">
                <div class="row">
                    <div class="footer-col col-md-4 giallo">
                        <h3>Source code</h3>
                        <p><a href="https://github.com/danog/video-dl/" target="_blank">Rai, Mediaset and LA7 download engine, youtube-dl wrapper API and this website (video-dl)</a>
                            <br><a href="https://github.com/rg3/youtube-dl" target="_blank">Generic download engine (youtube-dl)</a>
                            <br><a href="https://github.com/HubSpot/pace" target="_blank">Loading animation (pace.js)</a>
                            <br><a href="https://github.com/mathiasbynens/he" target="_blank">HTML entity encoder (he.js)</a>
                            <br><a href="https://github.com/IronSummitMedia/startbootstrap-freelancer" target="_blank">Bootstrap theme (freelancer)</a>
                            <br><a href="https://github.com/soapbox/linkifyjs/" target="_blank">Linkifier (linkify.js)</a>
                        </p>
                    </div>
                    <div class="footer-col col-md-4">
                        <h3>Around the Web</h3>
                        <ul class="list-inline">
                            <li>
                                <a href="https://m.facebook.com/daniil.gentili" class="btn-social btn-outline"><i class="fa fa-fw fa-facebook"></i></a>
                            </li>
                            <li>
                                <a href="https://plus.google.com/+DaniilGentili/posts" class="btn-social btn-outline"><i class="fa fa-fw fa-google-plus"></i></a>
                            </li>
                            <li>
                                <a href="https://www.youtube.com/user/daniilgentilidg/featured" class="btn-social btn-outline"><i class="fa fa-fw fa-youtube"></i></a>
                            </li>
                            <li>
                                <a href="https://www.linkedin.com/profile/view?id=316872434&amp;trk=hp-identity-name" class="btn-social btn-outline"><i class="fa fa-fw fa-linkedin"></i></a>
                            </li>
                            <li>
                                <a href="https://www.paypal.me/danog/2" class="btn-social btn-outline"><i class="fa fa-fw fa-paypal"></i></a>
                            </li>

                        </ul>
                    </div>
                    <div class="footer-col col-md-4 giallo">
                        <h3>Other versions</h3>
                        <p><a href="http://daniil.it/video-dl/#method-1-app" target="_blank">Android version</a>
                            <br><a href="http://daniil.it/video-dl/" target="_blank">Bash script version</a>
                            <br>
                        </p><p id="jsd" style="display:none">Currently using the Jquery engine.</p><p id="phpd">Currently using the Php engine.</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-below">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <a href="https://daniil.it">Here you can find my other projects!</a><br><a href="http://privacypolicies.com/privacy/view/DbHIYG">Privacy Policy</a>
                    </div>
                </div>
            </div>
        </div>
    </footer>


    <div class="portfolio-modal modal fade" id="support" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-content">
            <div class="close-modal" data-dismiss="modal">
                <div class="lr">
                    <div class="rl">
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="row">
                    <div class="col-lg-8 col-lg-offset-2">
                        <div class="modal-body">
                            <h2>Supported websites</h2>
                            <hr class="star-primary">
                            <p ID="supportedurls" class="inverted">Rai, Mediaset, Witty TV, LA7 and all of the websites supported by youtube-dl. </p>
                            <button type="button" class="btn btn-default" data-dismiss="modal"><i class="fa fa-times"></i> Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="portfolio-modal modal fade" tabindex="-1" role="dialog" aria-hidden="true" id="contact">
        <div class="modal-content">
            <div class="close-modal" data-dismiss="modal">
                <div class="lr">
                    <div class="rl">
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-8 col-lg-offset-2">
                    <div class="modal-body">
                        <h2>Doesn&apos;t work?</h2>
                        <hr class="star-primary">
                        <form name="sentMessage" id="contactForm" novalidate>
                            <div class="row control-group">
                                <div class="form-group col-xs-12 floating-label-form-group controls">
                                    <label>Name</label>
                                    <input type="text" class="form-control" placeholder="Name" id="name" required data-validation-required-message="Please enter your name.">
                                    <p class="help-block text-danger"></p>
                                </div>
                            </div>
                            <div class="row control-group">
                                <div class="form-group col-xs-12 floating-label-form-group controls">
                                    <label>Email Address</label>
                                    <input type="email" class="form-control" placeholder="Email Address" id="email" required data-validation-required-message="Please enter your email address.">
                                    <p class="help-block text-danger"></p>
                                </div>
                            </div>
                            <div class="row control-group">
                                <div class="form-group col-xs-12 floating-label-form-group controls">
                                    <label>Subject</label>
                                    <input type="text" class="form-control" placeholder="Subject" id="phone" required data-validation-required-message="Please enter a subject for the message." value="Video not downloading!">
                                    <p class="help-block text-danger"></p>
                                </div>
                            </div>
                            <div class="row control-group">
                                <div class="form-group col-xs-12 floating-label-form-group controls">
                                    <label>Message</label>
                                    <textarea rows="5" class="form-control" placeholder="Message" id="message" required data-validation-required-message="Please enter a message.">The video:
<?= $mail ?>

does not work, could you please fix it?
Thanks!</textarea>
                                    <p class="help-block text-danger"></p>
                                </div>
                            </div>
                            <br>
                            <div id="success"></div>
                            <div class="row">
                                <div class="form-group col-xs-12">
                                    <button type="submit" class="btn btn-success btn-lg">Send</button>
                                </div>
                            </div>
                        </form>
                        <button type="button" class="btn btn-default" data-dismiss="modal"><i class="fa fa-times"></i> Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- jQuery -->
    <script src="js/jquery.js"></script>

    <!-- Video download 
    <script src="https://cdn.rawgit.com/mathiasbynens/he/master/he.js"></script>
    <script src="/js/linkify.min.js?"></script>
    <script src="/js/linkify-jquery.min.js?"></script>
    <script data-cfasync="false" src="/js/video-dl.js?v=tynixpowerlucedeidiamantimagicwinxminimondimagicimagicwinx"></script>-->

    <!-- Bootstrap Core JavaScript -->
    <script src="js/bootstrap.min.js"></script>

    <!-- Plugin JavaScript -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script>
    <script src="js/classie.js"></script>
    <script src="js/cbpAnimatedHeader.js"></script>

    <!-- Contact Form JavaScript -->
    <script src="js/jqBootstrapValidation.js"></script>
    <script src="js/contact_me.js?v=2"></script>


    <!-- Custom Theme JavaScript -->
    <script src="js/freelancer.js"></script>

</body>
</html>
