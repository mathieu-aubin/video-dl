<?php
if(($_GET['p']) == 'websites') {
    print_r('Rai, Mediaset, Witty TV, LA7, any generic non super-protected website.');
};

if(isset($_GET['url'])) {
    $file = __FILE__;
    $url = ($_GET["url"]);
    $param = ($_GET["p"]);
    $cmd =  "bash /var/www/video/api/api.sh" .  ' ' . escapeshellarg($url) .  ' ' . escapeshellarg($param);
    $message = shell_exec("$cmd");
    print_r($message);
}
?>
