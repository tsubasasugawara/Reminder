package com.sugawara.reminder.sharedpreference

import android.content.Context
import android.content.SharedPreferences

class SharedPreference(val context: Context) {
    private val PRESS_NAME = "settings"
    val sharedPref:SharedPreferences = context.getSharedPreferences(PRESS_NAME, Context.MODE_PRIVATE)

    fun saveInt(key: String, value: Int) {
        val editor: SharedPreferences.Editor = sharedPref.edit()
        editor.putInt(key, value)
        editor.commit()
    }

    fun saveString(key: String, value: String) {
        val editor: SharedPreferences.Editor = sharedPref.edit()
        editor.putString(key, value)
        editor.commit()
    }

    fun saveBoolean(key: String, value: Boolean) {
        val editor: SharedPreferences.Editor = sharedPref.edit()
        editor.putBoolean(key, value)
        editor.commit()
    }

    fun getInt(key: String): Int {
        return sharedPref.getInt(key,0)
    }

    fun getString(key: String): String? {
        return sharedPref.getString(key,null)
    }

    fun getBoolean(key: String): Boolean {
        return sharedPref.getBoolean(key,false)
    }
}
