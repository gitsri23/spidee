import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(SpiderJarvisApp());
}

class SpiderJarvisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HudScreen(),
    );
  }
}

class HudScreen extends StatefulWidget {
  @override
  State<HudScreen> createState() => _HudScreenState();
}

class _HudScreenState extends State<HudScreen>
    with TickerProviderStateMixin {

  late AnimationController pulse;
  String time = "";

  final Color accent = Color(0xFFFF3B3B);

  @override
  void initState() {
    super.initState();

    pulse = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    Timer.periodic(Duration(seconds: 1), (_) {
      final n = DateTime.now();
      setState(() {
        time =
            "${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}:${n.second.toString().padLeft(2, '0')}";
      });
    });
  }

  @override
  void dispose() {
    pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          /// GRID BACKGROUND
          CustomPaint(
            painter: GridPainter(),
            size: Size.infinite,
          ),

          /// HEADER
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ARACHNID SYSTEM",
                    style: TextStyle(
                        color: accent,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600)),
                Text(time,
                    style: TextStyle(color: Colors.white.withOpacity(0.6))),
              ],
            ),
          ),

          /// CORE SYSTEM NODE
          Center(
            child: AnimatedBuilder(
              animation: pulse,
              builder: (_, __) {
                return Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: accent, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(0.2 + pulse.value * 0.3),
                        blurRadius: 50,
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          /// STATUS BARS
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bar("BIOMETRIC SYNC", 1.0),
                SizedBox(height: 8),
                _bar("NEURAL LINK", 0.96),
              ],
            ),
          ),

          /// CONTROL DOCK
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["SYSTEM", "THREAT", "SUIT", "NETWORK"]
                  .map((e) => Text(
                        e,
                        style: TextStyle(
                          color: accent,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.6))),
        SizedBox(height: 4),
        Container(
          height: 6,
          decoration: BoxDecoration(
            border: Border.all(color: accent.withOpacity(0.4)),
          ),
          child: FractionallySizedBox(
            widthFactor: value,
            child: Container(color: accent),
          ),
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0x22FF3B3B)
      ..strokeWidth = 0.5;

    const gap = 40.0;

    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
