import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../services/payment_service.dart';

/// Shows the Xendit invoice page. When the user taps "Done", we read the
/// order status from Supabase (updated by the webhook) and pop it back.
class XenditWebviewScreen extends StatefulWidget {
  final String invoiceUrl;
  final String externalId;
  final String productName;

  const XenditWebviewScreen({
    super.key,
    required this.invoiceUrl,
    required this.externalId,
    required this.productName,
  });

  @override
  State<XenditWebviewScreen> createState() => _XenditWebviewScreenState();
}

class _XenditWebviewScreenState extends State<XenditWebviewScreen> {
  final _service = PaymentService();
  late final WebViewController _controller;
  bool _loading = true;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    
    // Kung nasa Web/Browser tayo, huwag i-initialize ang WebViewController para maiwasan ang crash
    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
        ))
        ..loadRequest(Uri.parse(widget.invoiceUrl));
    } else {
      // Para sa Web, awtomatikong buksan sa bagong tab ang Xendit invoice
      _launchInBrowser(widget.invoiceUrl);
    }
  }

  Future<void> _launchInBrowser(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _done() async {
    setState(() => _checking = true);
    try {
      final status = await _service.fetchStatus(widget.externalId);
      if (!mounted) return;
      Navigator.pop(context, status);
    } catch (e) {
      if (!mounted) return;
      setState(() => _checking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not check payment status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xendit Payment - ${widget.productName}'),
        actions: [
          TextButton(
            onPressed: _checking ? null : _done,
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: _checking
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: kIsWeb
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.open_in_new, size: 64, color: Colors.brown),
                    const SizedBox(height: 16),
                    const Text(
                      'Ang Xendit Payment page ay binuksan sa isang bagong tab.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pagkatapos magbayad, bumalik dito at pindutin ang "Done" sa itaas para i-verify ang order mo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _launchInBrowser(widget.invoiceUrl),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Buksan Ulit ang Payment Link'),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_loading) const LinearProgressIndicator(),
              ],
            ),
    );
  }
}