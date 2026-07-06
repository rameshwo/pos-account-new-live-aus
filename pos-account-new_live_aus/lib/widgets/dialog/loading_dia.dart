import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class LoadingDialog extends StatelessWidget {
  final Widget child;
  final List<String> totalSteps;
  final int completedSteps;
  final void Function() onDone;
  final String? loadingText;
  final bool isLoading;
  const LoadingDialog({
    super.key,
    required this.child,
    required this.totalSteps,
    required this.completedSteps,
    required this.onDone,
    this.loadingText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          LoadingOverlay(
            totalSteps: totalSteps,
            completedSteps: completedSteps,
            onDone: onDone,
            loadingText: loadingText,
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  LOADING OVERLAY
// ─────────────────────────────────────────────
class LoadingOverlay extends StatefulWidget {
  /// Total number of steps (sent before API calls begin).
  final List<String> totalSteps;

  /// Number of completed steps (updated after each API call).
  final int completedSteps;

  /// Called after the 100% hold animation finishes — parent should hide the overlay.
  final VoidCallback onDone;
  final String? loadingText;

  const LoadingOverlay({
    super.key,
    required this.totalSteps,
    required this.completedSteps,
    required this.onDone,
    this.loadingText,
  });

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay>
    with SingleTickerProviderStateMixin {
  double _displayProgress = 0.0; // animated display value, never regresses
  bool _closing = false;

  @override
  void didUpdateWidget(LoadingOverlay old) {
    super.didUpdateWidget(old);

    if (widget.totalSteps.isEmpty) return;

    final double target = widget.completedSteps / widget.totalSteps.length;
    if (target > _displayProgress && !_closing) {
      _tweenTo(target);
    }
  }

  Future<void> _tweenTo(double target) async {
    final double start = _displayProgress;
    const int totalMs = 500; // smooth animation per step
    final startTime = DateTime.now();

    while (mounted) {
      final int elapsed = DateTime.now().difference(startTime).inMilliseconds;
      final double t = (elapsed / totalMs).clamp(0.0, 1.0);
      final double eased = t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
      final double next = start + (target - start) * eased;

      if (next > _displayProgress) {
        setState(() => _displayProgress = next);
      }

      if (t >= 1.0) break;
      await Future.delayed(const Duration(milliseconds: 16));
    }

    if (!mounted) return;
    setState(() => _displayProgress = target);

    // Auto-close when we hit 100%
    if (target >= 1.0 && !_closing) {
      _closing = true;
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) widget.onDone();
    }
  }

  String get _stepLabel {
    if (widget.totalSteps.isEmpty) return 'Preparing…';
    if (widget.completedSteps >= widget.totalSteps.length) return 'Done!';
    return widget.totalSteps[widget.completedSteps % widget.totalSteps.length];
  }

  @override
  Widget build(BuildContext context) {
    final int pct = (_displayProgress * 100).round().clamp(0, 100);

    return Container(
      color: Colors.black.withOpacity(0.38),
      child: Center(
        child: _LoadingCard(
          stepLabel: _stepLabel,
          progress: _displayProgress,
          percentage: pct,
          loadingText: widget.loadingText,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CARD
// ─────────────────────────────────────────────
class _LoadingCard extends StatelessWidget {
  final String stepLabel;
  final double progress;
  final int percentage;
  final String? loadingText;

  const _LoadingCard({
    required this.stepLabel,
    required this.progress,
    required this.percentage,
    this.loadingText,
  });

  static const _teal = kSecondaryColor;
  static const _tealLight = Color(0xFFDFF6F3);

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      width: size.getW(290),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(8), vertical: size.getH(32)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13),
            blurRadius: size.getS(40),
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: _teal.withOpacity(0.10),
            blurRadius: size.getS(24),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ring + percentage
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size.getS(80),
                height: size.getS(80),
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: _tealLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(_teal),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: size.getS(18),
                  fontWeight: FontWeight.w800,
                  color: _teal,
                  letterSpacing: -0.5,
                  height: 1,
                ),
              ),
            ],
          ),

          SizedBox(height: size.getH(20)),

          Text(
            loadingText ?? 'Refreshing',
            style: TextStyle(
              fontSize: size.getS(18),
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),

          SizedBox(height: size.getH(8)),

          // Current step label
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Text(
              stepLabel,
              key: ValueKey(stepLabel),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.getS(15),
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
