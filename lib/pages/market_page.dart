import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:micro_cow_app/main.dart';
import 'package:provider/provider.dart';

import '../helpers/measurement_util.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  late TextEditingController controller;
  String chainID = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    chainID = context.read<CowProvider>().lineraPlayerChainID;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final double marketMenuWidth = 106;
  final double auctionMenuWidth = 120;
  final double creditMenuWidth = 106;
  final double logoutMenuWidth = 88;
  final double menuRightPadding = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                Widget marketPageTitle = Text(
                  'Micro Cow MARKET',
                  style: context.style.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                );

                Size marketPageTitleSize = MeasurementUtil.measureWidget(marketPageTitle);

                double menuTotalWidth = marketMenuWidth +
                    auctionMenuWidth +
                    creditMenuWidth +
                    logoutMenuWidth +
                    (menuRightPadding * 3);

                double titleAndMenuWidth = marketPageTitleSize.width + menuTotalWidth;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: const BoxDecoration(
                        color: menuRedBackground,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              marketPageTitle,
                              Builder(
                                builder: (BuildContext context) {
                                  double maxWidth = constraints.maxWidth + 10;
                                  double leftPad = 0;
                                  double rightPad = 0;

                                  double availableLeftSpace = maxWidth - titleAndMenuWidth;
                                  double availableRightSpace = maxWidth - menuTotalWidth;
                                  double availableMenu3 = maxWidth -
                                      (menuTotalWidth - logoutMenuWidth - menuRightPadding);
                                  double availableMenu2 = maxWidth -
                                      (menuTotalWidth -
                                          creditMenuWidth -
                                          logoutMenuWidth -
                                          (menuRightPadding * 2));

                                  WrapAlignment titleAlignment = WrapAlignment.spaceBetween;

                                  if (availableLeftSpace > 0) {
                                    leftPad = availableLeftSpace;
                                  } else if (availableRightSpace > 0) {
                                    titleAlignment = WrapAlignment.start;
                                    rightPad = availableRightSpace;
                                  } else if (availableMenu3 > 0) {
                                    titleAlignment = WrapAlignment.start;
                                    rightPad = availableMenu3;
                                  } else if (availableMenu2 > 0) {
                                    titleAlignment = WrapAlignment.start;
                                    rightPad = availableMenu2;
                                  } else {
                                    titleAlignment = WrapAlignment.start;
                                    leftPad = 0;
                                    rightPad = 0;
                                  }

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: leftPad,
                                      right: rightPad,
                                    ),
                                    child: Wrap(
                                      alignment: titleAlignment,
                                      runAlignment: WrapAlignment.spaceBetween,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      runSpacing: 16,
                                      children: barActionButtons(context),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Selector<CowProvider, double>(
                      selector: (context, cowProvider) => cowProvider.userBalance,
                      builder: (BuildContext context, double balance, Widget? child) {
                        return BalanceDisplay(balance: balance);
                      },
                    ),
                    Builder(builder: (BuildContext context) {
                      double padding = 0;
                      if (constraints.maxWidth >= 965) padding = (constraints.maxWidth - 965) / 2;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runAlignment: WrapAlignment.spaceBetween,
                          spacing: 32,
                          runSpacing: 32,
                          children: cowMarketList(context),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Contains list of Navigation button for market page.
  List<Widget> barActionButtons(BuildContext context) {
    return [
      Container(
        width: marketMenuWidth,
        padding: EdgeInsets.only(right: menuRightPadding),
        child: AppGradientButton(
          title: 'FARM',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.35, 0.5, 0.65, 0.9],
            colors: goldColorGradient,
          ),
          onTap: () async {
            context.go('/farm');
          },
        ),
      ),
      Container(
        width: auctionMenuWidth,
        padding: EdgeInsets.only(right: menuRightPadding),
        child: AppGradientButton(
          title: 'AUCTION',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.35, 0.5, 0.65, 0.9],
            colors: magentaColorGradient,
          ),
          onTap: () async {
            await DialogHelper.successes(context, "coming soon!");
          },
        ),
      ),
      Container(
        width: creditMenuWidth,
        padding: EdgeInsets.only(right: menuRightPadding),
        child: AppGradientButton(
          title: 'CREDIT',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.35, 0.5, 0.65, 0.9],
            colors: blueColorGradient,
          ),
          onTap: () async => context.go('/credit'),
        ),
      ),
      SizedBox(
        width: logoutMenuWidth,
        child: AppGradientButton(
          title: 'LOGOUT',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.35, 0.5, 0.65, 0.9],
            colors: greenColorGradient,
          ),
          onTap: () async {
            context.read<CowProvider>().userLoggedOut();
            context.go('/login');
          },
        ),
      ),
    ];
  }

  // Contains a full list of Cow's Breed that you can buy on the market.
  List<Widget> cowMarketList(BuildContext context) {
    return [
      MarketCard(
          breed: CowBreed.jersey, onBuy: () async => await buyingCow(context, CowBreed.jersey)),
      MarketCard(
          breed: CowBreed.limousin, onBuy: () async => await buyingCow(context, CowBreed.limousin)),
      MarketCard(
          breed: CowBreed.hallikar, onBuy: () async => await buyingCow(context, CowBreed.hallikar)),
      MarketCard(
          breed: CowBreed.hereford, onBuy: () async => await buyingCow(context, CowBreed.hereford)),
      MarketCard(
          breed: CowBreed.holstein, onBuy: () async => await buyingCow(context, CowBreed.holstein)),
      MarketCard(
          breed: CowBreed.simmental,
          onBuy: () async => await buyingCow(context, CowBreed.simmental)),
    ];
  }

  // A set of function for calling BuyCow operation on Micro Cow contract.
  Future<void> buyingCow(BuildContext context, CowBreed cowBreed) async {
    // * Ask for Cow's Name.
    bool? isCowNameConfirmed = await DialogHelper.forCowName(context, controller);
    // * Check to ensure Cow's name not empty.
    if (isCowNameConfirmed == null || !isCowNameConfirmed) {
      controller.clear();
      return;
    }

    // * Show waiting dialog.
    if (context.mounted) DialogHelper.waiting(context);

    // * variable setup.
    String cowName = controller.text;
    String randomStr = RandomUtil.createCryptoRandomString(25);
    List<int> bytes = utf8.encode(chainID + cowName + randomStr);
    Digest digest = sha1.convert(bytes);
    String cowID = digest.toString();

    // * perform local check before call BuyCow on contract
    if (!context.mounted) return;
    String? checkError = await _performNecessaryCheck(context, cowBreed, cowName);
    if (checkError != null) {
      controller.clear();
      if (context.mounted) await _handleError(context, checkError);
      return;
    }

    // * call BuyCow on contract.
    if (!context.mounted) return;
    String? buyCowError = await _tryBuyCow(context, cowName, cowID, cowBreed);
    if (buyCowError != null) {
      controller.clear();
      if (context.mounted) await _handleError(context, buyCowError);
      return;
    }

    // * pool buy notification
    if (!context.mounted) return;
    var (BuyNotification? notification, String? pollError) = await _pollBuyNotification(context);
    if (pollError != null) {
      controller.clear();
      if (context.mounted) await _handleError(context, pollError);
      return;
    }

    // * show dialog for failed BuyCow
    bool isBuySuccess = notification?.isSuccess ?? false;
    if (!isBuySuccess) {
      controller.clear();
      unawaited(_deleteBuyNotification(context));
      if (context.mounted) {
        await _handleError(context, "failed to buy ${notification?.cowName ?? '??'}");
      }
      return;
    }

    if (context.mounted) {
      // * load cow data from local db
      String? cowListError = await _getFullCowList(context);
      if (cowListError != null) {
        if (context.mounted) await _handleError(context, cowListError);
        return;
      }

      // * query to check balance after buying cow
      if (!context.mounted) return;
      String? checkBalanceError = await _checkBalance(context);
      if (checkBalanceError != null) {
        if (context.mounted) await _handleError(context, checkBalanceError);
        return;
      }

      // * show dialog for success BuyCow
      if (context.mounted) Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 100));
      if (!context.mounted) return;
      unawaited(_deleteBuyNotification(context));
      await DialogHelper.successes(
          context, "you have successfully bought ${notification?.cowName ?? '??'}");
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // * go back to farm
    if (context.mounted) {
      context.go('/farm');
    }
  }

  Future<String?> _tryBuyCow(
    BuildContext context,
    String cowName,
    String cowId,
    CowBreed cowBreed,
  ) async {
    String mutation = await GraphQLAssetBundle().loadString(BUY_COW);

    if (!context.mounted) return "context not mounted";

    Map<String, dynamic> variables = {
      'owner': context.read<CowProvider>().lineraOwner,
      'cowName': cowName,
      'cowId': cowId,
      'cowBreed': cowBreed.name(),
    };

    // * mutation to buy cow
    var (QueryResult? _, String? error) = await GraphQLService.performMutation(
        context.read<CowProvider>().appClient!, mutation,
        variables: variables);

    if (error != null) {
      return error;
    }

    return null;
  }

  Future<(BuyNotification?, String?)> _pollBuyNotification(BuildContext context) async {
    String query = await GraphQLAssetBundle().loadString(GET_ONE_BUY_NOTIFICATION);

    if (!context.mounted) return (null, "context not mounted");

    BuyNotification? result;
    String? error;

    // * loop query to get buy notification
    int loopNum = 0;
    while (loopNum < 40) {
      if (context.mounted) {
        var (QueryResult? loopResult, String? loopError) =
            await GraphQLService.performQuery(context.read<CowProvider>().appClient!, query);

        if (loopError != null) {
          error = loopError;
          break;
        }

        BuyNotificationList b = BuyNotificationList.fromJson(loopResult!.data!);
        if (b.getOneBuyNotification.isNotEmpty) {
          result = b.getOneBuyNotification.first;
          break;
        }
      }
      loopNum++;
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    // * handle case if both result & error is null
    if (result == null && error == null) {
      return (null, "something went wrong, BuyNotification is missing");
    }

    // * return error or result
    if (error != null) {
      return (null, error);
    }
    return (result, null);
  }

  Future<void> _deleteBuyNotification(BuildContext context) async {
    String mutation = await GraphQLAssetBundle().loadString(DELETE_BUY_NOTIFICATION);

    if (!context.mounted) return;

    // * mutation to delete buy notification
    var (QueryResult? _, String? _) =
        await GraphQLService.performMutation(context.read<CowProvider>().appClient!, mutation);

    return;
  }

  Future<String?> _getFullCowList(BuildContext context) async {
    String query = await GraphQLAssetBundle().loadString(GET_MY_COWS);

    if (!context.mounted) return "context not mounted";

    // * query to check balance
    var (QueryResult? result, String? error) =
        await GraphQLService.performQuery(context.read<CowProvider>().appClient!, query);

    if (error != null) {
      return error;
    }

    // * Update Cow List on Provider
    GetMyCows c = GetMyCows.fromJson(result!.data!);
    if (context.mounted) context.read<CowProvider>().updateCowDataList(c.myCows);

    return null;
  }

  Future<String?> _performNecessaryCheck(
      BuildContext context, CowBreed cowBreed, String cowName) async {
    String? balanceError = await _checkBalance(context);
    if (balanceError != null) return balanceError;

    // * check for sufficient balance
    if (!context.mounted) return null;
    double balance = context.read<CowProvider>().userBalance;
    double breedPrice = double.tryParse(cowBreed.price().replaceAll('LINERA', '').trim()) ?? 0;
    if (balance <= breedPrice) return AppMessages.insufficientFund;

    // // * check if Name available to buy from local DB
    String? cowAliveError = await _isCowAlive(context, cowName);
    if (cowAliveError != null) {
      return cowAliveError;
    }

    return null;
  }

  Future<String?> _checkBalance(BuildContext context) async {
    String query = await GraphQLAssetBundle().loadString(GET_BALANCE);

    if (!context.mounted) return "context not mounted";

    // * query to check balance
    var (QueryResult? result, String? error) =
        await GraphQLService.performQuery(context.read<CowProvider>().appClient!, query);

    if (error != null) {
      return error;
    }

    // * Get Balance & Update Balance on Provider
    Balance b = Balance.fromJson(result!.data!);
    if (context.mounted) context.read<CowProvider>().updateUserBalance(b.getBalance ?? '0');

    return null;
  }

  Future<String?> _checkCowOnLocalDB(BuildContext context, String cowName) async {
    String query = await GraphQLAssetBundle().loadString(GET_ONE_LOCAL_DB_COW);

    if (!context.mounted) return "context not mounted";

    Map<String, dynamic> variables = {
      'cowKey': cowName,
    };

    // * query to check cow
    var (QueryResult? result, String? error) = await GraphQLService.performQuery(
        context.read<CowProvider>().appClient!, query,
        variables: variables);

    if (error != null) {
      return error;
    }

    // * check if COW NAME is exist or their LAST FED TIME is less than 24 hours
    GetLocalCow c = GetLocalCow.fromJson(result!.data!);
    if (c.localCow.isNotEmpty) {
      CowData cow = c.localCow.first;
      DateTime lastFed = DateTime.fromMicrosecondsSinceEpoch(cow.lastFedTime);
      Duration elapsed = DateTime.now().difference(lastFed);
      if (elapsed.inSeconds < SECONDS_IN_24_HOURS) {
        return AppMessages.nameExist;
      }
    }
    return null;
  }

  Future<String?> _isCowAlive(BuildContext context, String cowName) async {
    String query = await GraphQLAssetBundle().loadString(IS_COW_ALIVE);

    if (!context.mounted) return "context not mounted";

    Map<String, dynamic> variables = {
      'cowName': cowName,
      'systemTime': DateTime.now().microsecondsSinceEpoch,
    };

    // * query to check if cow alive
    var (QueryResult? result, String? error) = await GraphQLService.performQuery(
        context.read<CowProvider>().appClient!, query,
        variables: variables);

    if (error != null) {
      return error;
    }

    // * check the cow
    IsCowAlive c = IsCowAlive.fromJson(result!.data!);
    bool isAlive = c.isAlive ?? false;
    if (isAlive) {
      return AppMessages.nameExist;
    }
    return null;
  }

  Future<void> _handleError(BuildContext context, String error) async {
    String err = error;
    if (err.length > 100) err = error.substring(0, 100);
    if (context.mounted) Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 100));
    if (context.mounted) DialogHelper.failures(context, err);
  }
}
