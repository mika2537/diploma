import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceCardWidget extends StatelessWidget {
  final double balance;
  final VoidCallback onWithdraw;
  final VoidCallback onTopUp;

  const BalanceCardWidget({
    super.key,
    required this.balance,
    required this.onWithdraw,
    required this.onTopUp,
  });

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.decimalPattern();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Available Balance"),
                  const SizedBox(height: 6),
                  Text(
                    "${f.format(balance)} ₮",
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                ElevatedButton(
                  onPressed: onWithdraw,
                  child: const Text("Withdraw"),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: onTopUp,
                  child: const Text("Top Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}