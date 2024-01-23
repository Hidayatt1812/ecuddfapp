// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:math';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ECU Data Visualization',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ECUDataScreen(),
//     );
//   }
// }

// class ECUDataScreen extends StatefulWidget {
//   @override
//   _ECUDataScreenState createState() => _ECUDataScreenState();
// }

// class _ECUDataScreenState extends State<ECUDataScreen> {
//   // Initialize variables to store RPM and TPS data
//   double rpm = 0.0;
//   double tps = 0.0;

//   // Function to update RPM and TPS data (simulated)
//   void updateDataFromECU() {
//     // Simulated data update - Replace this with real ECU communication logic
//     setState(() {
//       rpm = generateRandomRPM();
//       tps = generateRandomTPS();
//     });
//   }

//   // Simulated function to generate random RPM data
//   double generateRandomRPM() {
//     // Replace this with actual RPM data retrieval logic
//     return (1000 + DateTime.now().millisecond.toDouble()) % 8000;
//   }

//   // Simulated function to generate random TPS data
//   double generateRandomTPS() {
//     // Replace this with actual TPS data retrieval logic
//     return (DateTime.now().millisecond.toDouble() % 100) / 100;
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Start updating data when the screen is loaded
//     // Replace this with your actual data update mechanism
//     Timer.periodic(Duration(milliseconds: 500), (timer) {
//       updateDataFromECU();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('RPM vs TPS Visualization'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'RPM: ${rpm.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             Text(
//               'TPS: ${tps.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             SizedBox(height: 20), // Adding space between text and visualization

//             // RPM vs TPS table visualization
//             Container(
//               width: 300, // Adjust width as needed
//               height: 300, // Adjust height as needed
//               child: CustomPaint(
//                 painter: RPMTpsVisualizer(rpm: rpm, tps: tps),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RPMTpsVisualizer extends CustomPainter {
//   final double rpm;
//   final double tps;

//   RPMTpsVisualizer({required this.rpm, required this.tps});

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Set line color and thickness
//     Paint linePaint = Paint()..color = Colors.red;
//     double lineWidth = 2.0;

//     // Calculate line positions based on RPM and TPS values
//     double rpmPositionX = (rpm / 8000) * size.width;
//     double tpsPositionY = (1 - tps) * size.height;

//     // Draw horizontal line (for TPS)
//     canvas.drawLine(
//       Offset(0, tpsPositionY),
//       Offset(size.width, tpsPositionY),
//       linePaint,
//     );

//     // Draw vertical line (for RPM)
//     canvas.drawLine(
//       Offset(rpmPositionX, 0),
//       Offset(rpmPositionX, size.height),
//       linePaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
