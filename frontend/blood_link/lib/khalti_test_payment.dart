import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class KhaltiTestPaymentButton
    extends StatelessWidget {
  const KhaltiTestPaymentButton(
      {super.key});

  @override
  Widget
      build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          KhaltiScope.of(context).pay(
            config: PaymentConfig(
              amount: 10000, // Amount in paisa
              productIdentity: 'donation-001',
              productName: 'Test Donation',
            ),
            preferences: [
              PaymentPreference.khalti,
            ],
            onSuccess: (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment Successful. Token: ${success.token}')),
              );
            },
            onFailure: (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment Failed. Reason: ${failure.message}')),
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
          "Pay with Khalti",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
