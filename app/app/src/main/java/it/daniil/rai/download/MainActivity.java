package it.daniil.rai.download;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.method.LinkMovementMethod;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.webkit.WebView;
import android.widget.TextView;

import com.google.android.gms.analytics.GoogleAnalytics;
import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;

import java.util.HashMap;


public class MainActivity extends Activity {

    public static GoogleAnalytics analytics;
    public static Tracker tracker;
    private WebView mWebView;

    @Override
    public void onCreate(Bundle savedInstanceState) {

        Intent intent = getIntent();
        String action = intent.getAction();
        String type = intent.getType();

        String urltoload = "http://video.daniil.it/android/";


        if (Intent.ACTION_SEND.equals(action) && type != null) {
            if ("text/plain".equals(type)) {
                // Handle text being sent
                String sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
                if ((sharedText.startsWith("https://")) || (sharedText.startsWith("http://"))) {
                    urltoload = "http://video.daniil.it/?url=" + Uri.encode(sharedText);

                }
            }
        }

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mWebView = (WebView) findViewById(R.id.activity_main_webview);
        mWebView.loadUrl(urltoload);
        mWebView.setWebViewClient(new MyAppWebViewClient());
        mWebView.getSettings().setBuiltInZoomControls(true);


        // From now on google analytics code
        analytics = GoogleAnalytics.getInstance(this);
        analytics.setLocalDispatchPeriod(1800);
        tracker = analytics.newTracker("UA-50691719-8"); // Replace with actual tracker/property Id
        tracker.enableExceptionReporting(true);
        tracker.enableAdvertisingIdCollection(true);
        tracker.enableAutoActivityTracking(true);

        tracker.setScreenName("Main screen");

        tracker.send(new HitBuilders.EventBuilder()
                .setCategory("UX")
                .setAction("ACTION_VIEW")
                .setLabel("Open app")
                .build());


    }
    @Override
    public void onStart() {
        super.onStart();  // Always call the superclass method first

        Intent intent = getIntent();
        String action = intent.getAction();
        String type = intent.getType();


        if (Intent.ACTION_SEND.equals(action) && type != null) {
            if ("text/plain".equals(type)) {
                // Handle text being sent
                String sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
                if ((sharedText.startsWith("https://")) || (sharedText.startsWith("http://"))) {

                    if(mWebView != null) {
                        mWebView.clearHistory();
                        mWebView.clearCache(true);
                        mWebView.loadUrl("about:blank");
                        mWebView.pauseTimers();
                        mWebView = null;
                    }

                    setContentView(R.layout.activity_main);
                    mWebView = (WebView) findViewById(R.id.activity_main_webview);
                    mWebView.loadUrl("http://video.daniil.it/?url=" + Uri.encode(sharedText));
                    mWebView.setWebViewClient(new MyAppWebViewClient());
                    mWebView.getSettings().setBuiltInZoomControls(true);


                }
            }
        }
    }
    @Override
    public void onBackPressed() {
        if(mWebView.canGoBack()) {
            mWebView.goBack();
        } else {
            super.onBackPressed();
        }
    }
    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {
        MenuInflater inflater=getMenuInflater();
        inflater.inflate(R.menu.contact,menu);
        return true;
    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        int id=item.getItemId();
        switch(id)
        {
            case R.id.action_share:
            /*
                Codice di gestione della voce MENU_1
             */
                String share = getResources().getString(R.string.share_text);

                Intent sendIntent = new Intent();
                sendIntent.setAction(Intent.ACTION_SEND);
                sendIntent.putExtra(Intent.EXTRA_TEXT, share);
                sendIntent.setType("text/plain");
                startActivity(sendIntent);

                tracker.send(new HitBuilders.EventBuilder()
                        .setCategory("UX")
                        .setAction("click")
                        .setLabel("share")
                        .build());

                break;
            case R.id.action_not_working:
            /*
                Codice di gestione della voce MENU_2
             */
                String webUrl = mWebView.getUrl();

                if (webUrl.equals("http://video.daniil.it/android/")) {
                    webUrl = "Insert link";
                } else {
                    webUrl = webUrl.substring(webUrl.lastIndexOf("=") + 1);
                }
                webUrl = Uri.decode(webUrl);

                Intent emailIntent = new Intent(Intent.ACTION_SENDTO, Uri.fromParts(
                        "mailto", "daniil@daniil.it", null));
                emailIntent.putExtra(Intent.EXTRA_SUBJECT, "Video not working");
                emailIntent.putExtra(Intent.EXTRA_TEXT, "The video:\n" +
                        webUrl +
                        "\ndoes not work, could you please fix it?\n" +
                        "Thanks!");
                startActivity(Intent.createChooser(emailIntent, "Send email..."));

                tracker.send(new HitBuilders.EventBuilder()
                        .setCategory("UX")
                        .setAction("click")
                        .setLabel("not working")
                        .build());

                break;

            case R.id.action_credits:
                AlertDialog.Builder builder = new AlertDialog.Builder(this);
                builder.setTitle(R.string.credits_title)
                        .setMessage(R.string.credits)
                        .setCancelable(true)
                        .setNegativeButton(R.string.ok, null);

                AlertDialog welcomeAlert = builder.create();
                welcomeAlert.show();
                // Make the textview clickable. Must be called after show()
                ((TextView) welcomeAlert.findViewById(android.R.id.message)).setMovementMethod(LinkMovementMethod.getInstance());

                tracker.send(new HitBuilders.EventBuilder()
                        .setCategory("UX")
                        .setAction("click")
                        .setLabel("info popup")
                        .build());

                break;
        }
        return false;
    }



}
