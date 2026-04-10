import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

void main() {
  runApp(const SpiderJarvisV6());
}

class SpiderJarvisV6 extends StatelessWidget {
  const SpiderJarvisV6({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HudScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────
class HudScreen extends StatefulWidget {
  const HudScreen({super.key});

  @override
  State<HudScreen> createState() => _HudScreenState();
}

class _HudScreenState extends State<HudScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanCtrl;
  late AnimationController _pulseCtrl;

  String time = "";
  Timer? clock;

  double neural = 0.96;

  @override
  void initState() {
    super.initState();

    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    clock = Timer.periodic(const Duration(seconds: 1), (_) {
      final n = DateTime.now();
      setState(() {
        time =
            "${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}:${n.second.toString().padLeft(2, '0')}";
      });
    });
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
    _pulseCtrl.dispose();
    clock?.cancel();
    super.dispose();
  }

  Color accent = const Color(0xFFFF3B3B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildGridBackground(),
          _buildMapOverlay(),
          _buildScanLine(),

          _buildHeader(),
          _buildStatusBars(),

          _buildCore(),

          _buildDock(),
          _buildStatusLog(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // GRID BACKGROUND
  // ─────────────────────────────────────────────
  Widget _buildGridBackground() {
    return CustomPaint(
      painter: GridPainter(),
      size: Size.infinite,
    );
  }

  // ─────────────────────────────────────────────
  // FAKE MAP OVERLAY (REAL FEEL)
  // ─────────────────────────────────────────────
  Widget _buildMapOverlay() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.08,
        child: Image.network(
          "https://i.imgur.com/7bKQ9Yp.png", // city grid placeholder
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SCANNING LINE
  // ─────────────────────────────────────────────
  Widget _buildScanLine() {
    return AnimatedBuilder(
      animation: _scanCtrl,
      builder: (_, __) {
        return Positioned(
          top: MediaQuery.of(context).size.height * _scanCtrl.value,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            color: accent.withOpacity(0.2),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────
  Widget _buildHeader() {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "SPIDER JARVIS",
            style: TextStyle(
              color: accent,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            time,
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // STATUS BARS
  // ─────────────────────────────────────────────
  Widget _buildStatusBars() {
    return Positioned(
      top: 90,
      left: 20,
      right: 20,
      child: Column(
        children: [
          _bar("BIOMETRIC SYNC", 1.0),
          const SizedBox(height: 6),
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, __) =>
                _bar("NEURAL LINK", neural + _pulseCtrl.value * 0.01),
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
            style: TextStyle(
                fontSize: 10, color: Colors.white.withOpacity(0.6))),
        const SizedBox(height: 3),
        Container(
          height: 6,
          decoration: BoxDecoration(
            border: Border.all(color: accent.withOpacity(0.4)),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0, 1),
            child: Container(color: accent),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // CENTER CORE (NO CARTOON)
  // ─────────────────────────────────────────────
  Widget _buildCore() {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseCtrl,
        builder: (_, __) {
          return Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: accent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: accent.withOpacity(0.2 + _pulseCtrl.value * 0.2),
                  blurRadius: 30,
                )
              ],
            ),
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM DOCK
  // ─────────────────────────────────────────────
  Widget _buildDock() {
    final items = ["SYSTEM", "THREAT", "SUIT", "NETWORK"];

    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
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
    );
  }

  // ─────────────────────────────────────────────
  // STATUS LOG
  // ─────────────────────────────────────────────
  Widget _buildStatusLog() {
    return Positioned(
      bottom: 100,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: accent.withOpacity(0.3)),
        ),
        child: Text(
          "SYSTEM ONLINE • ALL SYSTEMS STABLE",
          style: TextStyle(
            color: accent.withOpacity(0.8),
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// GRID PAINTER (REAL HUD FEEL)
// ─────────────────────────────────────────────
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x22FF3B3B)
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
