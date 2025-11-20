import 'package:flutter/material.dart';

class WithdrawSheetWidget extends StatefulWidget {
  final double balance;
  final Function(double) onConfirm;

  const WithdrawSheetWidget({
    super.key,
    required this.balance,
    required this.onConfirm,
  });

  @override
  State<WithdrawSheetWidget> createState() => _WithdrawSheetWidgetState();
}

class _WithdrawSheetWidgetState extends State<WithdrawSheetWidget> {
  final controller = TextEditingController();
  String? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Withdraw", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 14),

          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Amount",
              errorText: error,
              border: const OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount == null || amount <= 0) {
                setState(() => error = "Enter valid amount");
                return;
              }
              if (amount > widget.balance) {
                setState(() => error = "Exceeds balance");
                return;
              }
              widget.onConfirm(amount);
              Navigator.pop(context);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}