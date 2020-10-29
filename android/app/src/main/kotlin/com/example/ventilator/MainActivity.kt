package com.example.ventilator

import android.Manifest
import android.annotation.SuppressLint
import android.app.admin.DevicePolicyManager
import android.app.admin.SystemUpdatePolicy
import android.content.*
import android.media.AudioManager
import android.media.MediaPlayer
import android.os.BatteryManager
import android.os.Build
import android.os.PowerManager
import android.os.UserManager
import android.provider.Settings
import android.util.Log
import android.view.View
import android.view.WindowManager
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import androidx.annotation.RequiresApi
import com.example.ventilator.util.DownloadController
import com.nabinbhandari.android.permissions.PermissionHandler
import com.nabinbhandari.android.permissions.Permissions
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


import android.view.ViewTreeObserver
class MainActivity: FlutterActivity() {

    private lateinit var mAdminComponentName: ComponentName
    private lateinit var mDevicePolicyManager: DevicePolicyManager
    var mp: MediaPlayer? = null
    private val mPowerManager: PowerManager? = null
    private var mWakeLock: PowerManager.WakeLock? = null
    val RESULT_ENABLE = 1

    companion object {
        const val LOCK_ACTIVITY_KEY = "MainActivity"
        const val CHANNEL = "shutdown"
        const val PERMISSION_REQUEST_STORAGE = 0
    }
    lateinit var downloadController: DownloadController

    @SuppressLint("InvalidWakeLockTag")
    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        window.setStatusBarColor(0x00000000);
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_HIDE_NAVIGATION);
//        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);

        mAdminComponentName = MyDeviceAdminReceiver.getComponentName(this)
        mDevicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager

        MethodChannel(flutterEngine.getDartExecutor(), CHANNEL).setMethodCallHandler { call, result ->
            val params = call.arguments as? Map<String, Any>

            if(call.method == "sendPlayAudioStartH"){
                try {
                    mp= MediaPlayer.create(getApplicationContext(), R.raw.high);// the song is a filename which i have pasted inside a folder **raw** created under the **res** folder.//

                    if(mp?.isPlaying()!!){
//                        mp?.stop();
//                        mp?.reset();
//                        mp?.release();
                    }
                    else{
                        mp?.start()
                        mp?.setLooping(true)
                        mp!!.setOnCompletionListener(object : MediaPlayer.OnCompletionListener {
                            override fun onCompletion(mp: MediaPlayer) {
                                mp?.release()

                            }
                        })
                    }
                } catch (ex: Exception) {
                    ex.printStackTrace()
                }
                result.success(true)//sendPlayAudioStartvH
            }else if(call.method == "sendPlayAudioStartvH"){
                try {
                    mp= MediaPlayer.create(getApplicationContext(), R.raw.ealarm);// the song is a filename which i have pasted inside a folder **raw** created under the **res** folder.//

                    if(mp?.isPlaying()!!){
//                        mp?.stop();
//                        mp?.reset();
//                        mp?.release();
                    }
                    else{
                        mp?.start()
                        mp?.setLooping(true)
                        mp!!.setOnCompletionListener(object : MediaPlayer.OnCompletionListener {
                            override fun onCompletion(mp: MediaPlayer) {
                                mp?.release()

                            }
                        })
                    }
                } catch (ex: Exception) {
                    ex.printStackTrace()
                }
                result.success(true)//sendPlayAudioStartvH
            }  else if(call.method == "sendPlayAudioStartM"){
                try {
                    mp= MediaPlayer.create(getApplicationContext(), R.raw.medium);// the song is a filename which i have pasted inside a folder **raw** created under the **res** folder.//

                    if(mp?.isPlaying()!!){
//                        mp?.stop();
//                        mp?.reset();
//                        mp?.release();
                    }
                    else{
                        mp?.start()
                        mp?.setLooping(true)
                        mp!!.setOnCompletionListener(object : MediaPlayer.OnCompletionListener {
                            override fun onCompletion(mp: MediaPlayer) {
                                mp?.release()

                            }
                        })
                    }
                } catch (ex: Exception) {
                    ex.printStackTrace()
                }
                result.success(true)
            }else  if (call.method == "clearRam") {
                try {
//                    Log.v("ProximityActivity", "ON!")
                    System.runFinalization();
                    Runtime.getRuntime().gc();
                    System.gc();
//                    getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);


                } catch (ex: Exception) {
                    ex.printStackTrace()
                }
                result.success(true)
            }
            else if(call.method == "sendPlayAudioStartL"){
                try {
                    mp= MediaPlayer.create(getApplicationContext(), R.raw.low);// the song is a filename which i have pasted inside a folder **raw** created under the **res** folder.//

                    if(mp?.isPlaying()!!){
//                        mp?.stop();
//                        mp?.reset();
//                        mp?.release();
                    }
                    else{
                        mp?.start()
                        mp?.setLooping(true)
                        mp!!.setOnCompletionListener(object : MediaPlayer.OnCompletionListener {
                            override fun onCompletion(mp: MediaPlayer) {
                                mp?.release()

                            }
                        })
                    }
                } catch (ex: Exception) {
                    ex.printStackTrace()
                }
                result.success(true)
            }else  if (call.method == "turnOnScreen") {
                try {
                    Log.v("ProximityActivity", "ON!")
                    mWakeLock = mPowerManager?.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP or PowerManager.FULL_WAKE_LOCK, "tag")
                    mWakeLock?.acquire()
//                    getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);


                } catch (ex: Exception) {
                    ex.printStackTrace()
                }
                result.success(true)
            }
            else  if (call.method == "turnOffScreen") {
                try {
//                    val proc = Runtime.getRuntime().exec(arrayOf("su", "-c", "reboot -p"))
//                    proc.waitFor()
                    Log.v("ProximityActivity", "OFF!");
                    if(mDevicePolicyManager.isAdminActive(mAdminComponentName)){
                        mDevicePolicyManager.lockNow()
                    }else{
                        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN)
                        intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, mAdminComponentName)
                        intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "Please Click On Activate")
                        startActivityForResult(intent, RESULT_ENABLE)
                    }
                    finish()
                } catch (ex: Exception) {
                    ex.printStackTrace()
                }
                result.success(true)
            }
            else if(call.method == "checkforUpdates"){
//                print(params?.get("from")as String);
                try {
                    downloadController = DownloadController(this, params?.get("urlFlutter") as String)
//                    downloadController = DownloadController(this, apkUrl)
                    // check storage permission granted if yes then start downloading file
                    Permissions.check(this /*context*/, Manifest.permission.WRITE_EXTERNAL_STORAGE, null, object : PermissionHandler() {
                        override fun onGranted() {
                            downloadController.enqueueDownload()
                        }
                    })
                    Log.d("esko_checkData","true");
                } catch (ex: Exception) {
                    Log.d("esko_checkData","false");
                    ex.printStackTrace()
                }
                result.success(true)
            }

            else if(call.method == "sendPlayAudioStop"){
                try {
//                    mp= MediaPlayer.create(getApplicationContext(),R.raw.ealarm);// the song is a filename which i have pasted inside a folder **raw** created under the **res** folder.//
                    if(mp?.isPlaying()!!){
                        mp?.stop();
//                        mp?.reset();
//                        mp?.release();
                    }
                } catch (ex: Exception) {
                    ex.printStackTrace()
                }
                result.success(true)
            } else if(call.method == "sendsoundoff"){
                try {
//                  //mute audio
                    val amanager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                    // Change the stream to your stream of choice.
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){
                        amanager.adjustStreamVolume(AudioManager.STREAM_MUSIC, AudioManager.ADJUST_MUTE, 0);
                        amanager.adjustStreamVolume(AudioManager.STREAM_NOTIFICATION, AudioManager.ADJUST_MUTE, 0)
                        amanager.adjustStreamVolume(AudioManager.STREAM_ALARM, AudioManager.ADJUST_MUTE, 0)
                        amanager.adjustStreamVolume(AudioManager.STREAM_RING, AudioManager.ADJUST_MUTE, 0)
                        amanager.adjustStreamVolume(AudioManager.STREAM_SYSTEM, AudioManager.ADJUST_MUTE, 0)
                    } else {
                        amanager.setStreamMute(AudioManager.STREAM_MUSIC, true);
                        amanager.setStreamMute(AudioManager.STREAM_NOTIFICATION, true)
                        amanager.setStreamMute(AudioManager.STREAM_ALARM, true)
                        amanager.setStreamMute(AudioManager.STREAM_RING, true)
                        amanager.setStreamMute(AudioManager.STREAM_SYSTEM, true)
                    }
                } catch (ex: Exception) {
                    ex.printStackTrace()
                }
                result.success(true)
            }else if(call.method == "sendsoundon"){
                try {
//                  // unmute audio
                    val amanager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                    amanager.setStreamVolume(AudioManager.STREAM_MUSIC, amanager.getStreamMaxVolume(AudioManager.STREAM_MUSIC), 0)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){
                        amanager.adjustStreamVolume(AudioManager.STREAM_MUSIC, AudioManager.ADJUST_UNMUTE, 0);
                        amanager.adjustStreamVolume(AudioManager.STREAM_NOTIFICATION, AudioManager.ADJUST_UNMUTE, 0)
                        amanager.adjustStreamVolume(AudioManager.STREAM_ALARM, AudioManager.ADJUST_UNMUTE, 0)
                        amanager.adjustStreamVolume(AudioManager.STREAM_RING, AudioManager.ADJUST_UNMUTE, 0)
                        amanager.adjustStreamVolume(AudioManager.STREAM_SYSTEM, AudioManager.ADJUST_UNMUTE, 0)
                    } else {
                        amanager.setStreamMute(AudioManager.STREAM_MUSIC, false);
                        amanager.setStreamMute(AudioManager.STREAM_NOTIFICATION, false)
                        amanager.setStreamMute(AudioManager.STREAM_ALARM, false)
                        amanager.setStreamMute(AudioManager.STREAM_RING, false)
                        amanager.setStreamMute(AudioManager.STREAM_SYSTEM, false)
                    }
                } catch (ex: Exception) {
                    ex.printStackTrace()
                }
                result.success(true)
            }else if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        var isAdmin = false
        if (mDevicePolicyManager.isDeviceOwnerApp(packageName)) {
//            Toast.makeText(applicationContext, R.string.device_owner, Toast.LENGTH_SHORT).show()
            isAdmin = true

        } else {
//            Toast.makeText(applicationContext, R.string.not_device_owner, Toast.LENGTH_SHORT).show()
        }
        setKioskPolicies(true, isAdmin)

    }

    private fun getBatteryLevel(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, @Nullable data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == RESULT_ENABLE) {
//            if (resultCode == Activity.RESULT_OK) {
//
//            } else {
            finish()
//            android.os.Process.killProcess(android.os.Process.myPid());
            System.exit(0)
            //            }
            return
        }
    }

    @SuppressLint("NewApi")
    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun setKioskPolicies(enable: Boolean, isAdmin: Boolean) {
        if (isAdmin) {
            setRestrictions(enable)
            enableStayOnWhilePluggedIn(enable)
            setUpdatePolicy(enable)
            setAsHomeApp(enable)
            setKeyGuardEnabled(enable)
        }
//        setLockTask(true, isAdmin)
        setImmersiveMode(enable)
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun setRestrictions(disallow: Boolean) {
        setUserRestriction(UserManager.DISALLOW_SAFE_BOOT, disallow)
        setUserRestriction(UserManager.DISALLOW_FACTORY_RESET, disallow)
        setUserRestriction(UserManager.DISALLOW_ADD_USER, disallow)
//        setUserRestriction(UserManager.DISALLOW_USB_FILE_TRANSFER,disallow)
//        setUserRestriction(UserManager.DISALLOW_MOUNT_PHYSICAL_MEDIA, disallow)
        setUserRestriction(UserManager.DISALLOW_ADJUST_VOLUME, disallow)
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun setUserRestriction(restriction: String, disallow: Boolean) = if (disallow) {
        mDevicePolicyManager.addUserRestriction(mAdminComponentName, restriction)
    } else {
        mDevicePolicyManager.clearUserRestriction(mAdminComponentName, restriction)
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun enableStayOnWhilePluggedIn(active: Boolean) = if (active) {
        mDevicePolicyManager.setGlobalSetting(mAdminComponentName,
                Settings.Global.STAY_ON_WHILE_PLUGGED_IN,
                Integer.toString(BatteryManager.BATTERY_PLUGGED_AC
                        or BatteryManager.BATTERY_PLUGGED_WIRELESS))
    } else {
        mDevicePolicyManager.setGlobalSetting(mAdminComponentName, Settings.Global.STAY_ON_WHILE_PLUGGED_IN, "0")
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun setLockTask(start: Boolean, isAdmin: Boolean) {
        if (isAdmin) {
            mDevicePolicyManager.setLockTaskPackages(mAdminComponentName, if (start) arrayOf(packageName) else arrayOf())
        }
        if (start) {
            startLockTask()
        } else {
            stopLockTask()
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun setUpdatePolicy(enable: Boolean) {
        if (enable) {
            mDevicePolicyManager.setSystemUpdatePolicy(mAdminComponentName,
                    SystemUpdatePolicy.createWindowedInstallPolicy(60, 120))
        } else {
            mDevicePolicyManager.setSystemUpdatePolicy(mAdminComponentName, null)
        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun setAsHomeApp(enable: Boolean) {
        if (enable) {
            val intentFilter = IntentFilter(Intent.ACTION_MAIN).apply {
                addCategory(Intent.CATEGORY_HOME)
                addCategory(Intent.CATEGORY_DEFAULT)
            }
            mDevicePolicyManager.addPersistentPreferredActivity(
                    mAdminComponentName, intentFilter, ComponentName(packageName, MainActivity::class.java.name))
        } else {
            mDevicePolicyManager.clearPackagePersistentPreferredActivities(
                    mAdminComponentName, packageName)
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun setKeyGuardEnabled(enable: Boolean) {
        mDevicePolicyManager.setKeyguardDisabled(mAdminComponentName, !enable)
    }

    private fun setImmersiveMode(enable: Boolean) {
        if (enable) {
            val flags = (View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                    or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                    or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                    or View.SYSTEM_UI_FLAG_FULLSCREEN
                    or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY)
            window.decorView.systemUiVisibility = flags
        } else {
            val flags = (View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                    or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                    or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN)
            window.decorView.systemUiVisibility = flags
        }
    }


}