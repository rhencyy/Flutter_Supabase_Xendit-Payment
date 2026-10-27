import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/xendit_webview_screen.dart';

class InvoiceResult {
  final String invoiceUrl;
  final String externalId;
  const InvoiceResult(this.invoiceUrl, this.externalId);
}

class PaymentService {
  final _client = Supabase.instance.client;

  /// Calls the `create-invoice` Edge Function.
  Future<InvoiceResult> createInvoice({
    required String productName,
    required double amount,
  }) async {
    final res = await _client.functions.invoke(
      'create-invoice',
      body: {'product_name': productName, 'amount': amount},
    );
    final data = res.data;
    if (data is! Map || data['invoice_url'] == null) {
      throw Exception(data is Map ? (data['error'] ?? 'Unknown error') : 'Invalid response');
    }
    return InvoiceResult(
      data['invoice_url'].toString(),
      data['external_id'].toString(),
    );
  }

  /// Reads the order status (updated by the Xendit webhook).
  Future<String> fetchStatus(String externalId) async {
    final row = await _client
        .from('orders')
        .select('status')
        .eq('external_id', externalId)
        .maybeSingle();
    return row?['status']?.toString() ?? 'PENDING';
  }

  /// Creates the invoice, opens the payment screen, returns the final status.
  Future<String?> pay(
    BuildContext context, {
    required String productName,
    required double amount,
  }) async {
    final invoice = await createInvoice(productName: productName, amount: amount);
    if (!context.mounted) return null;
    return Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => XenditWebviewScreen(
          invoiceUrl: invoice.invoiceUrl,
          externalId: invoice.externalId,
          productName: productName,
        ),
      ),
    );
  }
}