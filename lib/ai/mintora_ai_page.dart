import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MintoraAIPage extends StatefulWidget {
  const MintoraAIPage({Key? key}) : super(key: key);

  @override
  State<MintoraAIPage> createState() => _MintoraAIPageState();
}

class _MintoraAIPageState extends State<MintoraAIPage> {
  WebViewController? _controller;
  bool _loading = true;
  bool _forceTopOnNextLoad = false;

  static const String _aiUrl = 'https://mintora-1026988505101.us-west1.run.app';
  static const Color _bg = Color(0xFF2b2d42);

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    final c = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(_bg) // avoid white flash
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _loading = true),
          onPageFinished: (_) async {
            setState(() => _loading = false);
            // If requested (e.g., after refresh), force the page to the very top.
            if (_forceTopOnNextLoad) {
              _forceTopOnNextLoad = false;
              await _scrollToTop();
            }
          },
          onWebResourceError: (_) => setState(() => _loading = false),
        ),
      )
      ..loadRequest(Uri.parse(_aiUrl));

    setState(() => _controller = c);
  }

  /// Force the webpage to scroll to the top using JS (works for most SPAs too).
  Future<void> _scrollToTop() async {
    if (_controller == null) return;
    // Try with smooth=false (instant/auto) and set both body & documentElement.
    const js = r'''
      (function() {
        try {
          // Best-effort across browsers/engines
          window.scrollTo({top: 0, left: 0, behavior: 'auto'});
          document.documentElement.scrollTop = 0;
          document.body.scrollTop = 0;
          return true;
        } catch (e) {
          return false;
        }
      })();
    ''';
    try {
      await _controller!.runJavaScriptReturningResult(js);
    } catch (_) {
      // As a fallback, try a small delay and run again (some SPAs need a tick)
      await Future.delayed(const Duration(milliseconds: 50));
      try { await _controller!.runJavaScriptReturningResult(js); } catch (_) {}
    }
  }

  Future<void> _reload() async {
    if (_controller == null) return;
    setState(() => _loading = true);
    _forceTopOnNextLoad = true;           // ensure top after reload
    await _controller!.reload();
  }

  Future<void> _hardReload() async {
    if (_controller == null) return;
    setState(() => _loading = true);
    _forceTopOnNextLoad = true;           // ensure top after hard reload
    final uri = Uri.parse(_aiUrl);
    final busted = uri.replace(queryParameters: {
      ...uri.queryParameters,
      't': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    await _controller!.loadRequest(busted);
  }

  Future<bool> _onWillPop() async {
    if (_controller == null) return true;
    final canGoBack = await _controller!.canGoBack();
    if (canGoBack) {
      await _controller!.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          elevation: 0,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
             // Image.asset('assets/mintora.png', height: 24, width: 24),
              const SizedBox(width: 8),
              const Text('Welcome to Mintora AI', style: TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh),
              onPressed: _reload,
            ),
            PopupMenuButton<String>(
              tooltip: 'More',
              onSelected: (v) => _hardReload(),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'hard', child: Text('Hard reload')),
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            if (_controller != null)
              DecoratedBox(
                decoration: const BoxDecoration(color: _bg),
                child: WebViewWidget(controller: _controller!),
              ),
            if (_loading)
              const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(minHeight: 2),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _reload,
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh'),
        ),
      ),
    );
  }
}
