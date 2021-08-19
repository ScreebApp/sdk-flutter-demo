package app.screeb.flutter.flutter_demo_app.application

import android.app.Application
import app.screeb.sdk.Screeb

class DemoApplication : Application(){
    override fun onCreate() {
        super.onCreate()
        screeb = Screeb.Builder()
                .withContext(this)
                // Set your channel id here
                .withChannelId("082b7590-1621-4f72-8030-731a98cd1448")
                // Optional settings :
                /*
                .withVisitorId("<user-id>")
                .withVisitorProperties(VisitorProperties().apply {
                    this["email"] = "<user-email>"
                    this["age"] = 32
                    this["company"] = "<My company>"
                    this["logged_at"] = Date()
                })
                 */
                .build()
    }

    companion object {
        lateinit var screeb: Screeb
            private set
    }
}