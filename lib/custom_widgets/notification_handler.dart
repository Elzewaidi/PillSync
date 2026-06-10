import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:hive_ce/hive.dart';
import 'package:pillsync/cubit/medication/medication_cubit.dart';
import 'package:pillsync/cubit/medication/medication_state.dart';
import 'package:pillsync/model/medication_model.dart';
import 'package:pillsync/utils/app_colors.dart';

class NotificationHandler extends StatefulWidget {
  final Widget child;

  const NotificationHandler({Key? key, required this.child}) : super(key: key);

  @override
  State<NotificationHandler> createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> with SingleTickerProviderStateMixin {
  StreamSubscription? _subscription;
  Timer? _timer;
  String _lastTriggeredMinute = "";
  final Set<String> _alertedMissedDoses = {};
  
  Medication? _activeNotification;
  bool _isMissedAlert = false;
  String _customAlertMessage = "";
  String _motivationalMessage = "";
  
  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOutBack,
    ));

    // Listen to manual/simulated notification triggers from cubit
    final cubit = context.read<MedicationCubit>();
    _subscription = cubit.notificationStream.listen((med) {
      _triggerNotificationBanner(med);
    });

    // Start checking periodic timer for actual scheduled times (checks every 10 seconds)
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      _checkMedsScheduledTime();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    _dismissTimer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  void _checkMedsScheduledTime() async {
    if (!mounted) return;
    final cubit = context.read<MedicationCubit>();
    if (cubit.state is MedicationLoaded) {
      final now = DateTime.now();
      final minuteStr = DateFormat('yyyy-MM-dd HH:mm').format(now);
      final todayStr = DateFormat('yyyy-MM-dd').format(now);

      final meds = (cubit.state as MedicationLoaded).medications;

      // 1. Check for immediate medication reminder (exact match)
      if (_lastTriggeredMinute != minuteStr) {
        for (var med in meds) {
          if (med.isActive && !med.isTaken) {
            if (_isTimeMatching(med.timeTotake, now)) {
              _lastTriggeredMinute = minuteStr;
              cubit.triggerNotification(med);
              return; // Trigger only one alert at a time
            }
          }
        }
      }

      // 2. Check for missed doses
      final settingsBox = await Hive.openBox('settings');
      final bool enableMissedAlerts = settingsBox.get('enable_missed_alerts', defaultValue: true);
      if (enableMissedAlerts) {
        for (var med in meds) {
          if (med.isActive && !med.isTaken) {
            final medTime = _parseTimeString(med.timeTotake, now);
            final alertKey = "${med.id}_$todayStr";
            // If the medication scheduled time is in the past (by at least 1 minute)
            // and we haven't alerted for this medication today yet
            if (now.isAfter(medTime.add(const Duration(minutes: 1))) && !_alertedMissedDoses.contains(alertKey)) {
              _alertedMissedDoses.add(alertKey);
              _triggerMissedDoseAlert(med, settingsBox);
              return; // Trigger only one missed alert at a time
            }
          }
        }
      }
    }
  }

  DateTime _parseTimeString(String timeStr, DateTime referenceDate) {
    try {
      final clean = timeStr.trim().toUpperCase();
      int hour = 0;
      int minute = 0;

      if (clean.contains('AM') || clean.contains('PM')) {
        final parts = clean.split(RegExp(r'\s+'));
        final isPm = clean.contains('PM');
        final timeParts = parts[0].split(':');
        hour = int.parse(timeParts[0]);
        minute = int.parse(timeParts[1]);
        if (isPm && hour < 12) {
          hour += 12;
        } else if (!isPm && hour == 12) {
          hour = 0;
        }
      } else {
        final parts = clean.split(':');
        hour = int.parse(parts[0]);
        minute = int.parse(parts[1]);
      }

      return DateTime(
        referenceDate.year,
        referenceDate.month,
        referenceDate.day,
        hour,
        minute,
      );
    } catch (_) {
      return referenceDate;
    }
  }

  bool _isTimeMatching(String timeStr, DateTime now) {
    try {
      final clean = timeStr.trim().toUpperCase();
      int hour = 0;
      int minute = 0;

      if (clean.contains('AM') || clean.contains('PM')) {
        final parts = clean.split(RegExp(r'\s+'));
        final isPm = clean.contains('PM');
        final timeParts = parts[0].split(':');
        hour = int.parse(timeParts[0]);
        minute = int.parse(timeParts[1]);
        if (isPm && hour < 12) {
          hour += 12;
        } else if (!isPm && hour == 12) {
          hour = 0;
        }
      } else {
        final parts = clean.split(':');
        hour = int.parse(parts[0]);
        minute = int.parse(parts[1]);
      }

      return now.hour == hour && now.minute == minute;
    } catch (_) {
      return false;
    }
  }

  void _triggerNotificationBanner(Medication med) {
    if (!mounted) return;
    _dismissTimer?.cancel();
    setState(() {
      _activeNotification = med;
      _isMissedAlert = false;
      _customAlertMessage = "";
      _motivationalMessage = "";
    });
    _animationController!.forward();

    // Auto dismiss after 12 seconds
    _dismissTimer = Timer(const Duration(seconds: 12), () {
      _dismissBanner();
    });
  }

  void _triggerMissedDoseAlert(Medication med, Box settingsBox) {
    if (!mounted) return;
    _dismissTimer?.cancel();
    
    final customMsg = settingsBox.get('missed_alerts_message', defaultValue: "You haven't taken these medications today");
    final showMotivational = settingsBox.get('missed_alerts_motivational_enabled', defaultValue: true);
    final motivationalMsg = showMotivational 
        ? settingsBox.get('missed_alerts_motivational_message', defaultValue: "Stay strong! Your health is your wealth. 💪")
        : "";

    setState(() {
      _activeNotification = med;
      _isMissedAlert = true;
      _customAlertMessage = customMsg;
      _motivationalMessage = motivationalMsg;
    });
    _animationController!.forward();

    // Auto dismiss after 15 seconds for missed alerts
    _dismissTimer = Timer(const Duration(seconds: 15), () {
      _dismissBanner();
    });
  }

  void _dismissBanner() {
    if (!mounted) return;
    _animationController!.reverse().then((_) {
      if (mounted) {
        setState(() {
          _activeNotification = null;
          _isMissedAlert = false;
          _customAlertMessage = "";
          _motivationalMessage = "";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final isAr = languageCode == 'ar';

    return Stack(
      children: [
        widget.child,
        if (_activeNotification != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 12,
            right: 12,
            child: SlideTransition(
              position: _slideAnimation!,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isMissedAlert
                          ? Colors.redAccent.withOpacity(0.3)
                          : AppColors.primary.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _isMissedAlert
                            ? Colors.red.withOpacity(0.08)
                            : Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Shaking Icon
                      _AnimatedBellIcon(
                        icon: _isMissedAlert ? Icons.warning_amber_rounded : _activeNotification!.icon,
                        color: _isMissedAlert ? Colors.redAccent : AppColors.primary,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isMissedAlert
                                  ? (isAr ? "تنبيه جرعة فائتة! ⚠️" : "Missed Medication Alert! ⚠️")
                                  : (isAr ? "تذكير موعد الدواء! 🔔" : "Medication Reminder! 🔔"),
                              style: TextStyle(
                                fontSize: 13,
                                color: _isMissedAlert ? Colors.redAccent : AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _activeNotification!.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              _isMissedAlert
                                  ? _customAlertMessage
                                  : "${isAr ? "الجرعة:" : "Dosage:"} ${_activeNotification!.dosage}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (_isMissedAlert && _motivationalMessage.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _motivationalMessage,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Action buttons
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<MedicationCubit>().toggleMedication(_activeNotification!);
                              _dismissBanner();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isAr
                                        ? "تم تسجيل أخذ جرعة ${_activeNotification!.name} بنجاح!"
                                        : "Dose of ${_activeNotification!.name} marked as taken!",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  backgroundColor: AppColors.success,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isMissedAlert ? Colors.redAccent : AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              minimumSize: Size.zero,
                            ),
                            child: Text(
                              isAr ? "تناول الآن" : "Take Now",
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: _dismissBanner,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: Text(
                                isAr ? "تجاهل" : "Dismiss",
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Oscillating Icon Widget
class _AnimatedBellIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  const _AnimatedBellIcon({required this.icon, required this.color});

  @override
  State<_AnimatedBellIcon> createState() => _AnimatedBellIconState();
}

class _AnimatedBellIconState extends State<_AnimatedBellIcon> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _angleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _angleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.15), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.15, end: 0.15), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.15, end: -0.10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.10, end: 0.10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.10, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));

    _controller!.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _angleAnimation!,
      builder: (context, child) {
        return Transform.rotate(
          angle: _angleAnimation!.value,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.icon == Icons.access_time ? Icons.notifications_active : widget.icon,
              color: widget.color,
              size: 26,
            ),
          ),
        );
      },
    );
  }
}
