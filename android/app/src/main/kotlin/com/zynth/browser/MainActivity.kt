package com.zynth.browser

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.zynth.browser/app_icon"

    private val aliasMap = mapOf(
        1 to "com.zynth.browser.MainActivityDay1",
        2 to "com.zynth.browser.MainActivityDay2",
        3 to "com.zynth.browser.MainActivityDay3",
        4 to "com.zynth.browser.MainActivityDay4",
        5 to "com.zynth.browser.MainActivityDay5",
        6 to "com.zynth.browser.MainActivityDay6",
        7 to "com.zynth.browser.MainActivityDay7"
    )

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setAppIcon" -> {
                    val dayIndex = call.argument<Int>("dayIndex") ?: 1
                    val success = switchAppIcon(dayIndex)
                    result.success(success)
                }
                "getCurrentAppIcon" -> {
                    result.success(getCurrentActiveDayIndex())
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun switchAppIcon(targetDay: Int): Boolean {
        try {
            val pm = applicationContext.packageManager
            val targetAlias = aliasMap[targetDay] ?: aliasMap[1]!!

            // Enable target first to ensure app remains launchable at all times
            pm.setComponentEnabledSetting(
                ComponentName(applicationContext, targetAlias),
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                PackageManager.DONT_KILL_APP
            )

            // Disable all other aliases
            for ((day, alias) in aliasMap) {
                if (alias != targetAlias) {
                    pm.setComponentEnabledSetting(
                        ComponentName(applicationContext, alias),
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                }
            }
            return true
        } catch (e: Exception) {
            e.printStackTrace()
            return false
        }
    }

    private fun getCurrentActiveDayIndex(): Int {
        val pm = applicationContext.packageManager
        for ((day, alias) in aliasMap) {
            val state = pm.getComponentEnabledSetting(ComponentName(applicationContext, alias))
            if (state == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
                return day
            }
        }
        return 1
    }
}
