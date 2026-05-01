import 'package:flutter/material.dart';

/// Widget für die Timer-Anzeige und Countdown
class TimerWidget extends StatefulWidget {
  final int duration; // in Sekunden
  final bool isRunning;
  final VoidCallback onComplete;

  const TimerWidget({
    Key? key,
    required this.duration,
    this.isRunning = false,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration;
    _setupAnimation();
    // Starte Animation sofort wenn isRunning true ist
    if (widget.isRunning) {
      _controller.forward();
    }
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller.addListener(() {
      setState(() {
        _remainingSeconds =
            (widget.duration * (1 - _controller.value)).toInt();
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
  }

  @override
  void didUpdateWidget(TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning && oldWidget.isRunning != widget.isRunning) {
      // Controller wird neu erstellt - starte neu
      if (_controller.status != AnimationStatus.forward) {
        _controller.forward();
      }
    } else if (!widget.isRunning && oldWidget.isRunning != widget.isRunning) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(
            value: _animation.value,
            strokeWidth: 8,
            valueColor: AlwaysStoppedAnimation<Color>(
              _remainingSeconds <= 3 ? Colors.red : Colors.blue,
            ),
            backgroundColor: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 30),
        Text(
          '$_remainingSeconds',
          style: TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
            color: _remainingSeconds <= 3 ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }
}
