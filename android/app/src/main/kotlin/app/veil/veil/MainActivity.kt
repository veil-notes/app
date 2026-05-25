package app.veil.veil

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    companion object {
        private const val CHANNEL = "app.veil.veil/shortcuts"
        private const val METHOD_CONSUME_INITIAL_SHORTCUT = "consumeInitialShortcut"
        private const val METHOD_ON_SHORTCUT = "onShortcut"
        private const val ARG_ACTION = "action"

        private const val INTENT_ACTION_NEW_NOTE = "app.veil.veil.action.NEW_NOTE"
        private const val SHORTCUT_NEW_NOTE = "new_note"
    }

    private var shortcutChannel: MethodChannel? = null
    private var pendingInitialShortcut: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        captureShortcut(intent, notifyFlutter = false)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        shortcutChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )

        shortcutChannel?.setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when (call.method) {
                METHOD_CONSUME_INITIAL_SHORTCUT -> {
                    val initial = pendingInitialShortcut
                    pendingInitialShortcut = null
                    result.success(initial)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        captureShortcut(intent, notifyFlutter = true)
    }

    private fun captureShortcut(intent: Intent?, notifyFlutter: Boolean) {
        val shortcutAction = when (intent?.action) {
            INTENT_ACTION_NEW_NOTE -> SHORTCUT_NEW_NOTE
            else -> null
        } ?: return

        if (notifyFlutter) {
            dispatchShortcut(shortcutAction)
        } else {
            pendingInitialShortcut = shortcutAction
        }
    }

    private fun dispatchShortcut(action: String) {
        val args = hashMapOf<String, Any>(ARG_ACTION to action)
        val channel = shortcutChannel
        if (channel != null) {
            channel.invokeMethod(METHOD_ON_SHORTCUT, args)
        } else {
            pendingInitialShortcut = action
        }
    }
}