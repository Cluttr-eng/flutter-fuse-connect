package com.letsfuse.connect.fuse_connect

import androidx.annotation.NonNull

import android.app.Activity
import android.content.Intent
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.letsfuse.connect.FuseConnectActivity
import com.letsfuse.connect.FuseConnectActivity.Companion.EVENT_EXTRA
import com.letsfuse.connect.InstitutionSelect

/** FuseConnectPlugin */
class FuseConnectPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  companion object {
    const val CHANNEL = "fuse_connect"
    const val REQUEST_CODE = 928

    var institutionSelectedCallback: ((String) -> Unit)? = null
  }

  private val context: Context

  constructor(context: Context) {
    this.context = context
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
    channel.setMethodCallHandler(FuseConnectPlugin(registrar.context()))
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val args = call.arguments as List<*>
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
    val intent = Intent(this, FuseConnectActivity::class.java)
    intent.putExtra("clientSecret", clientSecret)
    startActivityForResult(intent, REQUEST_CODE)

    FuseConnectActivity.onInstitutionSelected = { institution_id, callback ->
      institutionSelectedCallback = { linkToken -> callback(linkToken) }
      channel.invokeMethod("onInstitutionSelected", mapOf("institution_id" to institution_id))
    }

    FuseConnectActivity.onSuccess = { publicToken ->
      channel.invokeMethod("onSuccess", mapOf("public_token" to publicToken))
    }
  }
}
