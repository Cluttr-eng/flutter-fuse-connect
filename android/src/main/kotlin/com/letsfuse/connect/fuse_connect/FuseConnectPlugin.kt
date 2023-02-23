package com.letsfuse.connect.fuse_connect

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat.startActivityForResult
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
    var activity : Activity? = null
    var institutionSelectedCallback: ((String) -> Unit)? = null
  }

  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
    activity = flutterPluginBinding.applicationContext as Activity
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val args = call.arguments as List<*>
    print("got method")
    print(call.method)

    when (call.method) {
      "open" -> open(args[0] as String)
      "institutionSelectCallBack" -> {
        if (institutionSelectedCallback != null) {
          institutionSelectedCallback!!(args[0] as String)
        }
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun open(clientSecret: String) {
    if (activity != null) {

      val intent = Intent(activity, FuseConnectActivity::class.java)
      intent.putExtra("clientSecret", clientSecret)
      startActivityForResult(activity!!, intent, REQUEST_CODE, null)

      FuseConnectActivity.onInstitutionSelected = { institution_id, callback ->
        institutionSelectedCallback = { linkToken -> callback(linkToken) }
        channel.invokeMethod("onInstitutionSelected", mapOf("institution_id" to institution_id))
      }

      FuseConnectActivity.onSuccess = { publicToken ->
        channel.invokeMethod("onSuccess", mapOf("public_token" to publicToken))
      }
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }
}
