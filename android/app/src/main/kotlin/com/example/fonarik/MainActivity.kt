package com.example.fonarik

import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraManager
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.flashlight/flashlight"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "toggleFlashlight") {
                val isOn = call.argument<Boolean>("isOn") ?: false
                toggleFlashlight(isOn)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun toggleFlashlight(isOn: Boolean) {
        val cameraManager = getSystemService(CAMERA_SERVICE) as CameraManager
        try {
            val cameraId = cameraManager.cameraIdList[0]
            cameraManager.setTorchMode(cameraId, isOn)
        } catch (e: CameraAccessException) {
            e.printStackTrace()
        }
    }
}

