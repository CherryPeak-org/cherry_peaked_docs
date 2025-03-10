package eu.cherrypeak.plugins.cherry_peaked_docs

import android.app.Activity
import android.content.Intent
import android.net.Uri
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions.RESULT_FORMAT_JPEG
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions.SCANNER_MODE_FULL
import com.google.mlkit.vision.documentscanner.GmsDocumentScanning
import com.google.mlkit.vision.documentscanner.GmsDocumentScanningResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.io.File
import java.io.FileOutputStream
import java.util.UUID

class CherryPeakedDocsPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  companion object {
    private const val SCANNER_REQUEST_CODE = 12345
  }

  private lateinit var channel: MethodChannel
  private var result: Result? = null
  private var outputDirPath: String? = null
  private var activity: Activity? = null

  // ---------------------------
  // Bridge
  // ---------------------------

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "cherry_peaked_docs")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    result = null
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    this.result = result

    when (call.method) {
      "startScanning" -> startScanning(call)
      "stopScanning" -> stopScanning()
      else -> result.notImplemented()
    }
  }

  // ---------------------------
  // Native
  // ---------------------------

  private fun startScanning(call: MethodCall) {
    outputDirPath = call.argument<String>("path")
    val pageLimit = call.argument<Int>("androidPageLimit")
    val isGalleryImportAllowed = call.argument<Boolean>("isAndroidGalleryImportAllowed")

    if (outputDirPath == null || pageLimit == null || isGalleryImportAllowed == null) {
      result?.error("INVALID_ARGUMENTS",  "Missing or malformed arguments", null)
      return
    }

    val optionsBuilder = GmsDocumentScannerOptions.Builder()
      .setScannerMode(SCANNER_MODE_FULL)
      .setResultFormats(RESULT_FORMAT_JPEG)
      .setGalleryImportAllowed(isGalleryImportAllowed)

    if (pageLimit > 0) {
      optionsBuilder.setPageLimit(pageLimit)
    }

    GmsDocumentScanning
      .getClient(optionsBuilder.build())
      .getStartScanIntent(activity!!)
      .addOnSuccessListener { intent ->
        activity?.startIntentSenderForResult(intent, SCANNER_REQUEST_CODE, null, 0, 0, 0)
      }
      .addOnFailureListener { e ->
        result?.error("SCANNER_FAILED", e.localizedMessage, e.cause?.localizedMessage)
      }
  }

  private fun stopScanning() {
    activity?.finishActivity(SCANNER_REQUEST_CODE)
  }

  private fun savePageFromUri(uri: Uri): String? {
    try {
      val inputStream = activity?.contentResolver?.openInputStream(uri)
      if (inputStream == null) {
        return null
      }

      val directory = File(outputDirPath!!)

      if (!directory.exists()) {
        directory.mkdirs()
      }

      val fileName = "${UUID.randomUUID()}.jpg"
      val file = File(directory, fileName)
      val outputStream = FileOutputStream(file)

      inputStream.use { input ->
        outputStream.use { output ->
          input.copyTo(output)
        }
      }

      inputStream.close()
      outputStream.close()

      return file.absolutePath
    } catch (e: Exception) {
      e.printStackTrace()
      return null
    }
  }

  // ---------------------------
  // Scanner activity
  // ---------------------------

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addActivityResultListener(this)
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if (requestCode != SCANNER_REQUEST_CODE) {
      return false
    }

    if (resultCode != Activity.RESULT_OK || data == null) {
      result?.success(emptyList<String>())
      return true
    }

    val scanningResult = GmsDocumentScanningResult.fromActivityResultIntent(data)
    if (scanningResult == null) {
      result?.error("SCANNER_FAILED", "Scan result is null", null)
      return true
    }

    val pages = scanningResult.pages
    if (pages == null || pages.isEmpty()) {
      result?.success(emptyList<String>())
      return true
    }

    val filePaths = pages
      .mapNotNull { page -> page.imageUri }
      .mapNotNull { uri -> savePageFromUri(uri) }

    result?.success(filePaths)
    return true
  }
}
