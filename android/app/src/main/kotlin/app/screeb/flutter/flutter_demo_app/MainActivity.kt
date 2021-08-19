package app.screeb.flutter.flutter_demo_app

import app.screeb.flutter.flutter_demo_app.application.DemoApplication
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "screeb/commands"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "setIdentity" -> {
                    val userId = call.argument<String>("userId")
                    userId?.let {
                        DemoApplication.screeb.setIdentity(it)
                        result.success(true)
                    } ?: result.error(
                        "MISSING_ARGUMENT",
                        "setIdentity function needs a userId parameter",
                        null
                    )
                }
                "sendTrackingEvent" -> {
                    val eventId = call.argument<String>("eventId")
                    eventId?.let {
                        DemoApplication.screeb.trackEvent(eventId)
                        result.success(true)
                    } ?: result.error(
                        "MISSING_ARGUMENT",
                        "sendTrackingEvent function needs a eventId parameter",
                        null
                    )
                }
                "sendTrackingScreen" -> {
                    val screen = call.argument<String>("screen")
                    screen?.let {
                        DemoApplication.screeb.trackScreen(screen)
                        result.success(true)
                    } ?: result.error(
                        "MISSING_ARGUMENT",
                        "sendTrackingScreen function needs a screen parameter",
                        null
                    )
                }
                "visitorProperty" -> {
                    if (call.arguments is Map<*, *>) {
                        val map = (call.arguments as Map<*, *>).toVisitorProperty()
                        DemoApplication.screeb.setVisitorProperties(map)
                        result.success(true)
                    } else {
                        result.error(
                            "MISSING_ARGUMENT",
                            "visitorProperty function needs a map of data",
                            null
                        )
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}

private fun <K, V> Map<K, V>.toVisitorProperty(): HashMap<String, Any?> {
    return HashMap<String, Any?>().apply {
        this@toVisitorProperty.forEach {
            this[it.key as String] = it.value
        }
    }
}
