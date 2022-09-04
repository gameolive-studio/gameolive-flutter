// todo, needs to be fixed to match wallet report
class Transaction {
  final String? uid;
  final double? amount;
  final String? currency;
  final int? coins;
  final String? reference;
  String? transactionTypeIdentifier;
  String? productName;
  String? productId;
  String? sku;
  String? remarks;
  // String application = Platform.isAndroid? "android": Platform.isIOS? "ios" : "website";
  // String token  = "";
  // String orderBy = "";
  // int limit = 10;
  // int offset = 0;

  Transaction(
      {this.uid, this.amount, this.currency, this.coins, this.reference});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    Transaction transaction = Transaction(
        uid: json['uid'],
        amount: json['amount'] != null ? (json['amount']).toDouble() : 0.0,
        currency: json['currency'],
        coins: json['coins'],
        reference: json['reference']);
    if (json['transactionTypeIdentifier'] != null) {
      transaction.transactionTypeIdentifier = json['transactionTypeIdentifier'];
    }
    if (json['remarks'] != null) {
      transaction.remarks = json['remarks'];
    }
    if (json['productName'] != null) {
      transaction.productName = json['productName'];
    }
    if (json['productId'] != null) {
      transaction.productId = json['productId'];
    }
    if (json['sku'] != null) {
      transaction.sku = json['sku'];
    }

    return transaction;
  }
}
