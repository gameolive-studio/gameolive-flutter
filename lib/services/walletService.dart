import 'dart:convert';

import 'package:gameolive/models/playerBalance.dart';
import 'package:gameolive/models/transaction.dart';
import 'package:gameolive/models/transactionsResponse.dart';
import 'package:http/http.dart' as http;

import '../models/config.dart';

Future<PlayerBalance> fetchPlayerBalance(
    String playerUid, Config config) async {
  final response = await http.post(
      Uri.parse(config.server + '/api/wallet/get-player-balance'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "operator_id": config.operatorId,
        "client_secret": config.clientSecret,
        "client_id": config.clientId,
        "player_uid": playerUid,
      }));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var rb = response.body;

    // store json data into list
    var list = json.decode(rb);

    // iterate over the list and map each object in list to Img by calling Img.fromJson
    // Auth auth = new Auth(token: rb);
    return PlayerBalance.fromJson(list["balance"]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to get Player Token');
  }
}

Future<PlayerBalance> debitToPlayerAccount(
    String playerUid, Transaction transaction, Config config) async {
  final response =
      await http.post(Uri.parse(config.server + '/api/wallet/transactions'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "operator_id": config.operatorId,
            "client_secret": config.clientSecret,
            "client_id": config.clientId,
            "player_uid": playerUid,
            "amount": transaction.amount,
            "currency": transaction.currency,
            "coins": transaction.coins,
            "uid": transaction.uid,
            "ref": transaction.ref,
            "remarks": transaction.remarks,
            "type": transaction.type
          }));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var rb = response.body;
    var data = json.decode(rb);
    PlayerBalance playerBalance =
        PlayerBalance.fromJson(data["currentBalance"]);
    return playerBalance;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(
        'Failed to make deposit transaction. Make sure that you have set all the required parameters and also uid is unique (not used earlier in previous transaction)');
  }
}

Future<TransactionsResponse> fetchPlayerAccountHistory(
    String playerUid, int offset, int limit, Config config) async {
  final response =
      await http.post(Uri.parse(config.server + '/api/wallet/get-transactions'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "operator_id": config.operatorId,
            "client_secret": config.clientSecret,
            "client_id": config.clientId,
            "player_uid": playerUid,
            "offset": offset,
            "limit": limit
          }));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var rb = response.body;

    // store json data into list
    var walletResponse = json.decode(rb) as Map<String, dynamic>;

    TransactionsResponse transactionsResponse = TransactionsResponse.fromJson(
        walletResponse); // list.map((i)=>Game.fromJson(i)).toList();

    return transactionsResponse;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to account history for the player.');
  }
}
