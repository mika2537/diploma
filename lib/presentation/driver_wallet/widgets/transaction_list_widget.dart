import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'transaction_tile_widget.dart';

class TransactionListWidget extends StatelessWidget {
  final List<TxModel> transactions;

  const TransactionListWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: Text("No transactions yet")),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Transactions",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        ...transactions.map((tx) => TransactionTileWidget(tx: tx)),
      ],
    );
  }
}