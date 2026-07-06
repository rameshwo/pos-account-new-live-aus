package com.coffyee.imin_cash_drawer

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.imin.library.IminSDKManager;

class IminCashDrawerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context // Added context variable

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.printer/cashDrawer")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext // Obtain context from FlutterPluginBinding
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "drawerStatus" -> {
                val isCashBoxOpen = IminSDKManager.isCashBoxOpen(context)
                result.success(isCashBoxOpen)
            }
            "openDrawer" -> {
                // val status =
                 IminSDKManager.opencashBox(context)
                result.success("functioncalled")
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
