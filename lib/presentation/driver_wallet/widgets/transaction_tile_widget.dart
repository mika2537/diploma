import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class TransactionTileWidget extends StatelessWidget {
  final TxModel tx;

  const TransactionTileWidget({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat("yyyy-MM-dd HH:mm");
    final color = tx.type == TxType.credit ? Colors.green : Colors.red;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(.1),
        child: Icon(
          tx.type == TxType.credit
              ? Icons.call_received
              : Icons.call_made,
          color: color,
        ),
      ),
      title: Text(tx.title),
      subtitle: Text(formatter.format(tx.date)),
      trailing: Text(
        "${tx.amount > 0 ? '+' : '-'}${tx.amount.abs()} ₮",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}