import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../browser_controller.dart';
import 'widgets/browser_app_bar.dart';
import 'widgets/browser_bottom_bar.dart';
import 'widgets/browser_home_view.dart';
import 'widgets/error_view.dart';

/// The primary full-screen browser interface for Zynth Browser on Android.
class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  late final BrowserController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BrowserController();
    _controller.addListener(_onStateChange);
  }

  void _onStateChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _controller.isHomeView && !_controller.canGoBack,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // If webview has history, go back
        if (_controller.canGoBack) {
          await _controller.goBack();
        } else if (!_controller.isHomeView) {
          // If viewing web page but can't go back, return to Zynth Home
          _controller.goHome();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BrowserAppBar(controller: _controller),
        body: Column(
          children: [
            // Loading Progress Bar
            if (_controller.isLoading)
              LinearProgressIndicator(
                value: _controller.loadingProgress > 0 ? _controller.loadingProgress : null,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 2.5,
              )
            else
              const SizedBox(height: 2.5),

            // Active Viewport
            Expanded(
              child: _buildViewport(),
            ),
          ],
        ),
        bottomNavigationBar: BrowserBottomBar(controller: _controller),
      ),
    );
  }

  Widget _buildViewport() {
    if (_controller.hasError) {
      return ErrorView(controller: _controller);
    }

    if (_controller.isHomeView) {
      return BrowserHomeView(controller: _controller);
    }

    if (_controller.webViewController != null) {
      return WebViewWidget(controller: _controller.webViewController!);
    }

    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}
