class PlayerBalance {
  final double cash;
  final double coin;
  final String currency;

  PlayerBalance(
      {required this.cash, required this.coin, required this.currency});

  factory PlayerBalance.fromJson(Map<String, dynamic> json) {
    var csh = json['cash'];
    if (csh is int) {
      csh = csh.toDouble();
    }
    if (csh is String) {
      csh = double.parse(csh);
    }

    var con = json['coin'];
    if (con is int) {
      con = con.toDouble();
    }
    if (con is String) {
      con = double.parse(con);
    }

    return PlayerBalance(cash: csh, coin: con, currency: json['currency']);
  }
}
