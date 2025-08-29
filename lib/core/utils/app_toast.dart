import 'package:flutter/material.dart';

/// Base AppToast class for showing toast messages across the app
class AppToast {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;
  static GlobalKey<NavigatorState>? _navigatorKey;

  /// Set the navigator key for the app
  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }

  /// Show success toast message
  static void showSuccess(String message) {
    _showToast(
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
      iconColor: Colors.white,
    );
  }

  /// Show error toast message
  static void showError(String message) {
    _showToast(
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error,
      iconColor: Colors.white,
    );
  }

  /// Show warning toast message
  static void showWarning(String message) {
    _showToast(
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
      iconColor: Colors.white,
    );
  }

  /// Show info toast message
  static void showInfo(String message) {
    _showToast(
      message: message,
      backgroundColor: Colors.blue,
      icon: Icons.info,
      iconColor: Colors.white,
    );
  }

  /// Show custom toast message
  static void showCustom({
    required String message,
    Color? backgroundColor,
    IconData? icon,
    Color? iconColor,
    Duration? duration,
  }) {
    _showToast(
      message: message,
      backgroundColor: backgroundColor ?? Colors.black87,
      icon: icon,
      iconColor: iconColor ?? Colors.white,
      duration: duration,
    );
  }

  /// Internal method to show toast
  static void _showToast({
    required String message,
    required Color backgroundColor,
    IconData? icon,
    Color? iconColor,
    Duration? duration,
  }) {
    if (_isShowing) {
      hide();
    }

    _overlayEntry = OverlayEntry(
      builder:
          (context) => _ToastWidget(
            message: message,
            backgroundColor: backgroundColor,
            icon: icon,
            iconColor: iconColor,
            duration: duration ?? const Duration(seconds: 3),
            onDismiss: hide,
          ),
    );

    _isShowing = true;
    Overlay.of(_getGlobalContext()).insert(_overlayEntry!);
  }

  /// Hide current toast
  static void hide() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isShowing = false;
    }
  }

  /// Get global context
  static BuildContext _getGlobalContext() {
    if (_navigatorKey?.currentContext != null) {
      return _navigatorKey!.currentContext!;
    }
    throw Exception(
      'Navigator key not set. Call AppToast.setNavigatorKey() in your MaterialApp',
    );
  }
}

/// Toast widget
class _ToastWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final IconData? icon;
  final Color? iconColor;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.backgroundColor,
    this.icon,
    this.iconColor,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _animationController.reverse().then((_) {
          widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 20,
      right: 20,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: widget.iconColor, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _animationController.reverse().then((_) {
                        widget.onDismiss();
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
