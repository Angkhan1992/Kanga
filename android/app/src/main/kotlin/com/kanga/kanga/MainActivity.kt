package com.kanga.kanga

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Bundle
import android.util.Log
import org.json.JSONObject
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {

    private var sensorManager: SensorManager? = null
    private val sensors: List<Sensor> = ArrayList()

    private var channelMethodSensor: MethodChannel? = null

    var gyroListener: SensorEventListener = object : SensorEventListener() {
        fun onAccuracyChanged(sensor: Sensor?, acc: Int) {}
        fun onSensorChanged(event: SensorEvent) {
            val type: String
            type = when (event.sensor.getType()) {
                Sensor.TYPE_ACCELEROMETER -> "accelerometer"
                Sensor.TYPE_STEP_COUNTER -> "step_counter"
                Sensor.TYPE_STEP_DETECTOR -> "step_detector"
                Sensor.TYPE_GYROSCOPE -> "gyroscope"
                Sensor.TYPE_GRAVITY -> "gravity"
                else -> "default"
            }
            val sensorMap: Map<String, FloatArray> = HashMap()
            sensorMap.put(type, event.values)
            if (channelMethodSensor != null) {
                channelMethodSensor.invokeMethod("onChanged", JSONObject(sensorMap).toString())
            }
        }
    }

    @Override
    protected fun onCreate(@Nullable savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager?
        val accelerometerSensor: Sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        if (accelerometerSensor != null) {
            Log.d("Sensor Type", "Accelerometer Sensor Added!!!")
            sensors.add(accelerometerSensor)
        }
        val stepCounterSensor: Sensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
        if (stepCounterSensor != null) {
            Log.d("Sensor Type", "Step Counter Sensor Added!!!")
            sensors.add(stepCounterSensor)
        }
        val stepDetectorSensor: Sensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_DETECTOR)
        if (stepDetectorSensor != null) {
            Log.d("Sensor Type", "Step Detector Sensor Added!!!")
            sensors.add(stepDetectorSensor)
        }
    }

    @Override
    protected fun onResume() {
        super.onResume()
        Log.d("TYPE_ALL", "Sensor Registered!!!")
        for (sensor in sensors) {
            sensorManager.registerListener(gyroListener, sensor, SensorManager.SENSOR_DELAY_GAME)
        }
    }

    @Override
    protected fun onStop() {
        super.onStop()
        sensorManager.unregisterListener(gyroListener)
    }

    @Override
    fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channelSensor = "com.kanga.measurement/sensor"
        channelMethodSensor =
            MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), channelSensor)
    }


}
