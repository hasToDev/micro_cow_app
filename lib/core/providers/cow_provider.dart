import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../contracts/micro_cow_contract.dart';
import '../network/graphql_model/get_my_cows.dart';
import '../network/graphql_service.dart';

class CowProvider extends ChangeNotifier {
  GraphQLClient? client;
  GraphQLClient? appClient;

  String graphQLServiceAddress = '';
  String lineraChainID = '';
  String cowRootChainID = '';
  String cowApplicationID = '';
  String lineraOwner = '';

  List<CowData> cows = [];

  double userBalance = 0;

  bool isLoggedIn = false;
  Timer? periodicUpdate;
  int currentEpochTime = 0;

  void setupGraphQLClient(String serviceURI) {
    String uri = serviceURI;
    if (serviceURI.contains("localhost")) uri.replaceAll("localhost", "127.0.0.1");
    if (!serviceURI.contains("http://")) uri = 'http://$uri';
    try {
      client = GraphQLService.createGraphQlClient(uri);
    } catch (e) {
      // TODO: DELETE THIS
      print('setup GraphQL Client:\n$e');
      rethrow;
    }
  }

  void setupGraphQLAppClient() {
    String uri = '$graphQLServiceAddress/chains/$lineraChainID/applications/$applicationID';
    appClient = GraphQLService.createGraphQlClient(uri);

    try {
      appClient = GraphQLService.createGraphQlClient(uri);
    } catch (e) {
      // TODO: DELETE THIS
      print('setup GraphQL App Client:\n$e');
      rethrow;
    }
  }

  void saveGraphQLAddressAndChainID(
    String serviceURI,
    String chainID,
    String microCowRootChainID,
    String microCowApplicationID,
  ) {
    lineraChainID = chainID;
    graphQLServiceAddress = serviceURI;
    cowRootChainID = microCowRootChainID;
    cowApplicationID = microCowApplicationID;
  }

  void userLoggedIn() {
    isLoggedIn = true;
  }

  void updateUserBalance(String balance) {
    userBalance = double.tryParse(balance) ?? 0;
    notifyListeners();
  }

  void updateOwner(String owner) {
    lineraOwner = owner;
  }

  void updateCowDataList(List<CowData> cowList) {
    cows = cowList;
    notifyListeners();
  }

  bool userLoggedOut() {
    if (periodicUpdate != null) {
      periodicUpdate!.cancel();
      periodicUpdate = null;
    }
    isLoggedIn = false;
    currentEpochTime = 0;
    cows.clear();
    return true;
  }

  void updateEpochTime(int epochTime) {
    currentEpochTime = epochTime;
    notifyListeners();
  }

  void epochPeriodicUpdate() {
    if (periodicUpdate != null) return;
    periodicUpdate = Timer.periodic(const Duration(seconds: 30), (_) async {
      int epochTime = DateTime.now().microsecondsSinceEpoch;
      if (epochTime != 0) updateEpochTime(epochTime);
    });
  }
}
