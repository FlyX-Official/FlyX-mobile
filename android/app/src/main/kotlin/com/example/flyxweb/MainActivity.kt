<<<<<<< HEAD:android/app/src/main/kotlin/com/example/FlyXWebSource/MainActivity.kt
package com.example.FlyXWebSource
=======
package com.example.flyxweb
>>>>>>> 42aa53c25962b24e009aa456f0f3dafd73fc754f:android/app/src/main/kotlin/com/example/flyxweb/MainActivity.kt

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
