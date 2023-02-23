package com.letsfuse.connect.fuse_connect

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.letsfuse.connect.FuseConnectActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FuseConnectPlugin */
class FuseConnectPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  companion object {
    const val CHANNEL = "fuse_connect"
    const val REQUEST_CODE = 928
    var institutionSelectedCallback: ((String) -> Unit)? = null
  }

  private lateinit var channel : MethodChannel
  private lateinit var activity : Activity

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, CHANNEL)
    channel.setMethodCallHandler(this)
    debugPrint("attached to engine")
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    val args = call.arguments as List<*>
    debugPrint("got method")
    debugPrint(call.method)

    when (call.method) {
      "open" -> open(args[0] as String)
      "close" -> close()
      "institutionSelectCallBack" -> {
        if (institutionSelectedCallback != null) {
          institutionSelectedCallback!!(args[0] as String)
        }
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    debugPrint("detached from engine")
  }

  private fun open(clientSecret: String) {
    val intent = Intent(activity, FuseConnectActivity::class.java)
    intent.putExtra("clientSecret", clientSecret)
    activity.startActivityForResult(intent, REQUEST_CODE)

    FuseConnectActivity.onInstitutionSelected = { institution_id, callback ->
      institutionSelectedCallback = { linkToken -> callback(linkToken) }
      channel.invokeMethod("onInstitutionSelected", mapOf("institution_id" to institution_id))
    }

    FuseConnectActivity.onSuccess = { publicToken ->
      channel.invokeMethod("onSuccess", mapOf("public_token" to publicToken))
    }
  }

  private fun close() {
    activity.finishActivity(REQUEST_CODE)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    debugPrint("attached to activity")
  }

  override fun onDetachedFromActivityForConfigChanges() {
    debugPrint("detached from activity for config changes")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    debugPrint("reattached to activity")
  }

  override fun onDetachedFromActivity() {
    debugPrint("detached from activity")
  }

  private fun debugPrint(message: String) {
    Log.d("FuseConnectPlugin", message)
  }
}
