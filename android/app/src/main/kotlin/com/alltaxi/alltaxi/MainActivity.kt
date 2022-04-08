package com.alltaxi.alltaxi

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
         MapKitFactory.setApiKey("417c7db7-6347-4634-a49a-22d97c414949") // Your generated API key
        super.configureFlutterEngine(flutterEngine)
    }
}
