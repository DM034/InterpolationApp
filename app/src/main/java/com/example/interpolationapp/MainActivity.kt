package com.example.interpolationapp

import android.Manifest
import android.content.ContentValues
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.util.Base64
import android.util.Log
import android.webkit.JavascriptInterface
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class MainActivity : AppCompatActivity() {

    private val REQUEST_WRITE_PERMISSION = 1001
    private lateinit var webView: WebView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Demander la permission pour Android < Q
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED
            ) {
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                    REQUEST_WRITE_PERMISSION
                )
            }
        }

        webView = findViewById(R.id.webView)
        val webSettings: WebSettings = webView.settings
        webSettings.javaScriptEnabled = true
        webSettings.allowFileAccess = true

        webView.webViewClient = WebViewClient()
        webView.addJavascriptInterface(JSBridge(), "AndroidInterface")
        webView.loadUrl("file:///android_asset/sounding.html")
    }

    // Permet à JS d'appeler AndroidInterface.captureWebView()
    inner class JSBridge {
        @JavascriptInterface
        fun captureWebView() {
            runOnUiThread {
                captureAndSaveWebView()
            }
        }
    }

    private fun captureAndSaveWebView() {
        val bitmap = Bitmap.createBitmap(webView.width, webView.height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        webView.draw(canvas)

        val formatter = java.text.SimpleDateFormat("dd-MM-yyyy_HH-mm-ss", java.util.Locale.getDefault())
        val formattedDate = formatter.format(java.util.Date())
        val filename = "sonde_du_$formattedDate.png"
        val resolver = contentResolver

        val contentValues = ContentValues().apply {
            put(MediaStore.Images.Media.DISPLAY_NAME, filename)
            put(MediaStore.Images.Media.MIME_TYPE, "image/png")
            put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_PICTURES + "/FuelSonde")
            put(MediaStore.Images.Media.IS_PENDING, 1)
        }

        val uri: Uri? = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)

        if (uri != null) {
            try {
                resolver.openOutputStream(uri)?.use { outputStream ->
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
                }

                contentValues.clear()
                contentValues.put(MediaStore.Images.Media.IS_PENDING, 0)
                resolver.update(uri, contentValues, null, null)

                Toast.makeText(this, "Capture enregistrée dans la galerie", Toast.LENGTH_LONG).show()
            } catch (e: Exception) {
                Toast.makeText(this, "Erreur de sauvegarde : ${e.message}", Toast.LENGTH_SHORT).show()
            }
        } else {
            Toast.makeText(this, "Erreur : URI null", Toast.LENGTH_SHORT).show()
        }
    }

    // Gestion de la permission WRITE_EXTERNAL_STORAGE pour Android < Q
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_WRITE_PERMISSION) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Toast.makeText(this, "Permission accordée", Toast.LENGTH_SHORT).show()
            } else {
                Toast.makeText(this, "Permission refusée", Toast.LENGTH_SHORT).show()
            }
        }
    }
}
