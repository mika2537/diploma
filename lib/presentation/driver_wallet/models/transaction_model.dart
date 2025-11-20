enum TxType { credit, debit }

class TxModel {
  final String title;
  final double amount;
  final DateTime date;
  final TxType type;

  TxModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  });
}