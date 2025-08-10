import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ⚠️ Replace with your real product IDs from App Store Connect / Play Console
const kProductIds = <String>{
  'ai_monthly', // subscription id
  'ai_yearly',  // subscription id
};

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});
  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final iap = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _sub;

  bool _loading = true;
  String? _error;
  bool _available = false;
  List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();
    _initIAP();
    _sub = iap.purchaseStream.listen(
      _onPurchasesUpdated,
      onDone: () => _sub.cancel(),
      onError: (e) => setState(() => _error = e.toString()),
    );
  }

  Future<void> _initIAP() async {
    try {
      _available = await iap.isAvailable();
      if (!_available) {
        setState(() {
          _loading = false;
          _error = 'Store unavailable on this device.';
        });
        return;
      }
      final resp = await iap.queryProductDetails(kProductIds);
      if (resp.error != null) {
        setState(() {
          _loading = false;
          _error = resp.error!.message;
        });
        return;
      }
      setState(() {
        _products = resp.productDetails..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _onPurchasesUpdated(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      switch (p.status) {
        case PurchaseStatus.pending:
          setState(() => _loading = true);
          break;
        case PurchaseStatus.error:
          setState(() {
            _loading = false;
            _error = p.error?.message ?? 'Purchase failed';
          });
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // (Recommended) verify on your server using p.verificationData.serverVerificationData
          await _grantEntitlementLocally();
          if (p.pendingCompletePurchase) {
            await iap.completePurchase(p);
          }
          if (mounted) {
            setState(() => _loading = false);
            _showSuccessDialog();
          }
          break;
        case PurchaseStatus.canceled:
          setState(() => _loading = false);
          break;
        default:
          break;
      }
    }
  }

  Future<void> _grantEntitlementLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ai_entitled', true);
    // Ensure the gate is cleared:
    await prefs.setBool('ai_trial_used', true);
  }

  void _buy(ProductDetails p) {
    final param = PurchaseParam(productDetails: p);
    // Subscriptions use buyNonConsumable in this plugin.
    iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> _restore() async {
    setState(() => _loading = true);
    await iap.restorePurchases();
    setState(() => _loading = false);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Mintora AI is unlocked on this device.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context); // purchase page
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unlock Mintora AI'),
        actions: [
          IconButton(
            tooltip: 'Restore',
            icon: const Icon(Icons.restore),
            onPressed: _restore,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(_error!, textAlign: TextAlign.center),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Choose a plan to continue using Mintora AI',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final p in _products)
                      Card(
                        child: ListTile(
                          title: Text(p.title),
                          subtitle: Text(p.description),
                          trailing: Text(p.price),
                          onTap: () => _buy(p),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      'Manage or cancel subscriptions in your App Store / Play Store account settings.',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
    );
  }
}
