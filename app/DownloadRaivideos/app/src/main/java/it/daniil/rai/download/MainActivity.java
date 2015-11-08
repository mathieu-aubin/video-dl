package it.daniil.rai.download;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.DownloadManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.text.method.LinkMovementMethod;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.webkit.WebView;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.ayz4sci.androidfactory.DownloadProgressView;
import com.google.android.gms.analytics.GoogleAnalytics;
import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;
import com.winsontan520.wversionmanager.library.WVersionManager;

public class MainActivity extends Activity {

    public static GoogleAnalytics analytics;
    public static Tracker tracker;
    private WebView mWebView;

    public void dlfile (String url, String title, String sanetitle)

    {
        final String url2print = url;
        // TOAST
        final Context context = getApplicationContext();
        int duration = Toast.LENGTH_SHORT;
        Toast toaststartdl = Toast.makeText(this, getString(R.string.starting_dl), duration);
        toaststartdl.show();

        // Initial setup
        String dirPath = Environment.DIRECTORY_MOVIES+"Video";

        DownloadProgressView downloadProgressView = (DownloadProgressView) findViewById(R.id.downloadProgressView);
        DownloadManager downloadManager = (DownloadManager) getSystemService(Context.DOWNLOAD_SERVICE);
        DownloadManager.Request request = new DownloadManager.Request(Uri.parse(url));
        request.setTitle(title);
        request.setDescription("Downloading " + title + "...");
        request.setDestinationInExternalFilesDir(getApplicationContext(), dirPath, sanetitle);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
            request.allowScanningByMediaScanner();
        }
        long downloadID = downloadManager.enqueue(request);

        downloadProgressView.show(downloadID, new DownloadProgressView.DownloadStatusListener() {
            @Override
            public void downloadFailed(int reason) {
                int duration = Toast.LENGTH_SHORT;
                String message = getString(R.string.dl_error1)+url2print+getString(R.string.dl_error2)+reason;
                Toast toastdlfail = Toast.makeText(context, message, duration);
                toastdlfail.show();

            }

            @Override
            public void downloadSuccessful() {

                int duration = Toast.LENGTH_SHORT;
                Toast toastdlok = Toast.makeText(context, getString(R.string.dl_success), duration);
                toastdlok.show();
            }

            @Override
            public void downloadCancelled() {

                int duration = Toast.LENGTH_SHORT;
                Toast toastdlcanceled = Toast.makeText(context, getString(R.string.dl_cancel), duration);
                toastdlcanceled.show();
            }
        });

    };

    @Override
    public void onCreate(Bundle savedInstanceState) {
        // Needed stuff
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        /*
        int duration = Toast.LENGTH_SHORT;
        Toast toasterror = Toast.makeText(this, getString(R.string.error), duration););

        PackageManager m = getPackageManager();
        String dlfolder = getPackageName();
        try {
            PackageInfo p = m.getPackageInfo(dlfolder, 0);
            dlfolder = p.applicationInfo.dataDir;
        } catch (PackageManager.NameNotFoundException e) {
            Log.w("yourtag", "Error Package name not found ", e);
        }

        if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {

        }*/
        // Auto update

        WVersionManager versionManager = new WVersionManager(this);
        versionManager.setUpdateNowLabel(this.getString(R.string.unow));
        versionManager.setRemindMeLaterLabel(this.getString(R.string.ulater));
        versionManager.setIgnoreThisVersionLabel(this.getString(R.string.uignore));
        versionManager.setUpdateUrl("http://j.mp/rai-dl-apk");
        versionManager.setVersionContentUrl("http://j.mp/rai-dl"); // your update content url, see the response format below
        versionManager.checkVersion();

        final String PREFS_NAME = "MyPrefsFile";

        SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);

        if (settings.getBoolean("my_first_time", true)) {
            settings.edit().putBoolean("my_first_time", false).commit();
        }


        // Google analytics
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
        String urltoload = "";
        if(mWebView==null) {
            mWebView = (WebView) findViewById(R.id.activity_main_webview);
            mWebView.setWebViewClient(new MyAppWebViewClient());
            mWebView.getSettings().setBuiltInZoomControls(true);
            urltoload = "http://google.com";
        }
        // Checking external share
        Intent intent = getIntent();
        String action = intent.getAction();
        String type = intent.getType();
        String sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);


        if (Intent.ACTION_SEND.equals(action) && type != null && "text/plain".equals(type) && ((sharedText.startsWith("https://")) || (sharedText.startsWith("http://")))) {
            // Handle text being sent
            urltoload = sharedText;
        }

        if (urltoload != null && !urltoload.isEmpty() && !urltoload.equals("null")) {
            mWebView.loadUrl(urltoload);
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
            case R.id.action_download:

            case R.id.action_url:
                AlertDialog.Builder alert = new AlertDialog.Builder(this);

                // final EditText edittext = (EditText) findViewById(R.id.popup_url);
                final EditText edittext = new EditText(this);
                edittext.setText(mWebView.getUrl());

                alert.setTitle(R.string.urlprompt);
                alert.setView(edittext);
                alert.setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int whichButton) {
                        String inurl = edittext.getText().toString();
                        if(inurl != null && !inurl.isEmpty() && !inurl.equals("null") && (inurl.startsWith("https://")) || (inurl.startsWith("http://"))) {
                            mWebView.loadUrl(inurl);
                        }
                    }
                });

                alert.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int whichButton) {
                        // Canceled.
                    }
                });

                alert.show();
                break;
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

                if (webUrl.equals("http://video.daniil.it/android/") || webUrl.equals("http://google.com")) {
                    webUrl = "Insert link";
                }

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
