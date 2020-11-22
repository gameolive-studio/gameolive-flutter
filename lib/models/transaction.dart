class Transaction {
  final String uid;
  final double amount;
  final String currency;
  final int coins;
  final String ref;
  String type;
  String remarks;
  // String application = Platform.isAndroid? "android": Platform.isIOS? "ios" : "website";
  // String token  = "";
  // String orderBy = "";
  // int limit = 10;
  // int offset = 0;


  Transaction({this.uid,this.amount,this.currency,this.coins,this.ref});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    Transaction _transaction = new Transaction(
        uid: json['name'],
        amount: (json['amount']).toDouble(),
        currency: json['currency'],
        coins: json['coins'],
        ref: json['ref']
    );
    if(json['type']!=null){
      _transaction.type = json['type'];
    }
    if(json['remarks']!=null){
      _transaction.remarks = json['remarks'];
    }
    return _transaction;
  }
}