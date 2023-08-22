import 'transaction.dart';

class TransactionsResponse {
  final List<Transaction>? transactions;
  final int? count;

  TransactionsResponse({this.transactions, this.count});

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['rows'] as List;
    List<Transaction>? transactions =
        list.isEmpty ? null : list.map((i) => Transaction.fromJson(i)).toList();

    return TransactionsResponse(
      transactions: transactions,
      count: json['count'],
    );
  }
}
