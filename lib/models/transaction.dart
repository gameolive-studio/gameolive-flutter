// todo, needs to be fixed to match wallet report
class Transaction {
  final String? uid;
  final double? amount;
  final String? currency;
  final int? coins;
  final String? reference;
  String? transactionTypeIdentifier;
  String? productName;
  String? remarks;
  // String application = Platform.isAndroid? "android": Platform.isIOS? "ios" : "website";
  // String token  = "";
  // String orderBy = "";
  // int limit = 10;
  // int offset = 0;

  Transaction(
      {this.uid, this.amount, this.currency, this.coins, this.reference});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    Transaction _transaction = new Transaction(
        uid: json['uid'],
        amount: (json['amount']).toDouble(),
        currency: json['currency'],
        coins: json['coins'],
        reference: json['reference']);
    if (json['transactionTypeIdentifier'] != null) {
      _transaction.transactionTypeIdentifier =
          json['transactionTypeIdentifier'];
    }
    if (json['remarks'] != null) {
      _transaction.remarks = json['remarks'];
    }
    if (json['productName'] != null) {
      _transaction.remarks = json['productName'];
    }
    return _transaction;
  }
}
