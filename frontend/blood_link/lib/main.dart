import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

void
    main() {
  runApp(
      const MyApp());
}

class MyApp
    extends StatelessWidget {
  const MyApp(
      {super.key});

  @override
  Widget
      build(BuildContext context) {
    return KhaltiScope(
      publicKey: 'test_public_key_30e12814fed64afa9a7d4a92a2194aeb',
      enabledDebugging: true,
      builder: (context, navKey) {
        return MaterialApp(
          title: 'Khalti Test Payment',
          navigatorKey: navKey,
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            useMaterial3: true,
          ),
          home: const PaymentHomePage(),
        );
      },
    );
  }
}

class PaymentHomePage
    extends StatelessWidget {
  const PaymentHomePage(
      {super.key});

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khalti Test Payment'),
      ),
      body: const Center(
        child: KhaltiTestPaymentButton(),
      ),
    );
  }
}

class KhaltiTestPaymentButton
    extends StatelessWidget {
  const KhaltiTestPaymentButton(
      {super.key});

  @override
  Widget
      build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        KhaltiScope.of(context).pay(
          config: PaymentConfig(
            amount: 10000, // 100.00 NPR in paisa
            productIdentity: 'donation-001',
            productName: 'Test Donation',
          ),
          preferences: [
            PaymentPreference.khalti,
          ],
          onSuccess: (PaymentSuccessModel success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment Successful! Token: ${success.token}')),
            );
          },
          onFailure: (PaymentFailureModel failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment Failed: ${failure.message}')),
            );
          },
          onCancel: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment Cancelled')),
            );
          },
        );
      },
      child: const Text(
        'Pay with Khalti',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
