import 'package:flutter/material.dart';
import 'widgets/balance_card_widget.dart';
import 'widgets/transaction_list_widget.dart';
import 'widgets/withdraw_sheet_widget.dart';
import 'models/transaction_model.dart';

class DriverWalletScreen extends StatefulWidget {
  const DriverWalletScreen({super.key});

  @override
  State<DriverWalletScreen> createState() => _DriverWalletScreenState();
}

class _DriverWalletScreenState extends State<DriverWalletScreen> {
  double balance = 124500;

  List<TxModel> transactions = [
    TxModel(
      title: "Completed ride",
      amount: 6500,
      date: DateTime.now().subtract(const Duration(hours: 1)),
      type: TxType.credit,
    ),
    TxModel(
      title: "Platform fee",
      amount: -600,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TxType.debit,
    ),
  ];

  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {});
  }

  void onWithdraw() {
    showModalBottomSheet(
      context: context,
      builder: (_) => WithdrawSheetWidget(
        balance: balance,
        onConfirm: (amount) {
          setState(() {
            balance -= amount;
            transactions.insert(
              0,
              TxModel(
                title: "Withdrawal",
                amount: -amount,
                date: DateTime.now(),
                type: TxType.debit,
              ),
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Driver Wallet")),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            BalanceCardWidget(
              balance: balance,
              onWithdraw: onWithdraw,
              onTopUp: () {},
            ),
            const SizedBox(height: 20),

            TransactionListWidget(transactions: transactions),
          ],
        ),
      ),
    );
  }
}