package com.battery.narmb_ls

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // FLAG_SECURE: запрет скриншотов и скрытие содержимого в списке
        // «недавних приложений» — защита персональных данных личного состава.
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
        super.onCreate(savedInstanceState)
    }
}
