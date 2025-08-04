import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerPage extends StatefulWidget {
  const AccelerometerPage({super.key});

  @override
  State<AccelerometerPage> createState() => _AccelerometerPageState();
}

class _AccelerometerPageState extends State<AccelerometerPage> {
  double x = 0.0, y = 0.0, z = 0.0;
  String status = "Waiting...";

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;

        // Manual shake detection
        double magnitude = sqrt(x * x + y * y + z * z);
        if (magnitude > 15) {
          status = "🚨 Shake Detected!";
        } else {
          status = "📱 Not Shaking";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accelerometer Sensor")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("X: ${x.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20)),
            Text("Y: ${y.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20)),
            Text("Z: ${z.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text(status, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
