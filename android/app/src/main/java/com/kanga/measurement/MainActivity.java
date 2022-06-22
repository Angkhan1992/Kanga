package com.kanga.measurement;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {

    private SensorManager sensorManager;
    private final List<Sensor> sensors = new ArrayList<>();

    private MethodChannel channelMethodSensor;

    public SensorEventListener gyroListener = new SensorEventListener() {
        public void onAccuracyChanged(Sensor sensor, int acc) {
        }

        public void onSensorChanged(SensorEvent event) {
            String type;

            switch (event.sensor.getType()) {
                case Sensor.TYPE_ACCELEROMETER:
                    type = "accelerometer";
                    break;
                case Sensor.TYPE_STEP_COUNTER:
                    type = "step_counter";
                    break;
                case Sensor.TYPE_STEP_DETECTOR:
                    type = "step_detector";
                    break;
                case Sensor.TYPE_GYROSCOPE:
                    type = "gyroscope";
                    break;
                case Sensor.TYPE_GRAVITY:
                    type = "gravity";
                    break;
                default:
                    type = "default";
                    break;
            }

            Map<String, float[]> sensorMap = new HashMap<>();
            sensorMap.put(type, event.values);
            if (channelMethodSensor != null) {
                channelMethodSensor.invokeMethod("onChanged", new JSONObject(sensorMap).toString());
            }
        }
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        Sensor accelerometerSensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        if (accelerometerSensor != null) {
            Log.d("Sensor Type", "Accelerometer Sensor Added!!!");
            sensors.add(accelerometerSensor);
        }
        Sensor stepCounterSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER);
        if (stepCounterSensor != null) {
            Log.d("Sensor Type", "Step Counter Sensor Added!!!");
            sensors.add(stepCounterSensor);
        }
        Sensor stepDetectorSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_DETECTOR);
        if (stepDetectorSensor != null) {
            Log.d("Sensor Type", "Step Detector Sensor Added!!!");
            sensors.add(stepDetectorSensor);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();

        Log.d("TYPE_ALL", "Sensor Registered!!!");
        for (Sensor sensor : sensors) {
            sensorManager.registerListener(gyroListener, sensor, SensorManager.SENSOR_DELAY_GAME);
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        sensorManager.unregisterListener(gyroListener);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        String channelSensor = "com.kanga.measurement/sensor";
        channelMethodSensor = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), channelSensor);
    }
}
