package com.volgai.pos_account

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.provider.Settings

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.cashbox"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openCashBox" -> {
                        openCashBox()
                        result.success(null)
                    }
                    "getAndroidID" -> {
                        val androidId = Settings.Secure.getString(
                            contentResolver, Settings.Secure.ANDROID_ID
                        )
                        if (androidId != null) {
                            result.success(androidId)
                        } else {
                            result.error("UNAVAILABLE", "Android ID not available.", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun openCashBox() {
        val intent = Intent("android.intent.action.CASHBOX")
        intent.putExtra("cashbox_open", true)
        sendBroadcast(intent)
    }
}