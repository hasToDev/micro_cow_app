import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:micro_cow_app/main.dart';
import 'package:provider/provider.dart';

import '../helpers/measurement_util.dart';

class FarmPage extends StatefulWidget {
  const FarmPage({super.key});

  @override
  State<FarmPage> createState() => _FarmPageState();
}

class _FarmPageState extends State<FarmPage> {
  late TextEditingController controller;
  String chainID = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    chainID = context.read<CowProvider>().microCowPlayerChainID;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final double marketMenuWidth = 116;
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
                Widget farmPageTitle = Text(
                  'Micro Cow FARM',
                  style: context.style.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                );

                Size farmPageTitleSize = MeasurementUtil.measureWidget(farmPageTitle);

                double menuTotalWidth = marketMenuWidth +
                    auctionMenuWidth +
                    creditMenuWidth +
                    logoutMenuWidth +
                    (menuRightPadding * 3);

                double titleAndMenuWidth = farmPageTitleSize.width + menuTotalWidth;

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
                              farmPageTitle,
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
                    WelcomeUser(account: chainID),
                    Selector<CowProvider, double>(
                      selector: (context, cowProvider) => cowProvider.userBalance,
                      builder: (BuildContext context, double balance, Widget? child) {
                        return BalanceDisplay(balance: balance);
                      },
                    ),
                    Selector<CowProvider, List<CowData>>(
                      selector: (context, cowProvider) => cowProvider.cows,
                      builder: (BuildContext context, List<CowData> cows, Widget? child) {
                        if (cows.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(16)),
                                border: Border.all(color: const Color.fromRGBO(139, 0, 139, 0.45)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(139, 0, 139, 0.35),
                                    offset: Offset(0, 4),
                                    blurRadius: 25,
                                    spreadRadius: 0.25,
                                  ),
                                ]),
                            child: Text(
                              'Right now you don\'t have any cow.\nYou can buy them at the MARKET.',
                              style: context.style.titleMedium?.copyWith(
                                color: magentaShadow,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 14,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        List<Widget> cowList = cows.map((CowData data) {
                          return CowCard(
                            data: data,
                            onSell: () async => await sellingCow(context, data),
                            onFeed: () async => await feedTheCow(context, data),
                          );
                        }).toList();

                        double padding = 0;
                        if (constraints.maxWidth >= 965) padding = (constraints.maxWidth - 965) / 2;

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runAlignment: WrapAlignment.spaceBetween,
                            spacing: 32,
                            runSpacing: 32,
                            children: cowList,
                          ),
                        );
                      },
                    ),
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

  // Contains list of Navigation button for farm page.
  List<Widget> barActionButtons(BuildContext context) {
    return [
      Container(
        width: marketMenuWidth,
        padding: EdgeInsets.only(right: menuRightPadding),
        child: AppGradientButton(
          title: 'MARKET',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.35, 0.5, 0.65, 0.9],
            colors: goldColorGradient,
          ),
          onTap: () async {
            context.go('/market');
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

  /// [sellingCow]
  /// A set of function for calling SellCow method on Micro Cow contract.
  Future<void> sellingCow(BuildContext context, CowData data) async {
    // * Show waiting dialog.
    if (context.mounted) DialogHelper.waiting(context);

    // * Check for cow existence
    String? existenceError = await _isCowExist(context, data.name);
    if (existenceError != null) {
      if (context.mounted) await _handleError(context, existenceError);
      return;
    }

    // * Check if cow died, you can't sell a dead one
    if (!context.mounted) return;
    String? cowDiedError = await _isCowDied(context, data.name);
    if (cowDiedError != null) {
      // * when dead cow is found, app will call BuryDeadCows method on contract
      // * after that app will update the Cow List
      if (context.mounted) await _getFullCowList(context);
      if (context.mounted) await _handleError(context, cowDiedError);
      return;
    }

    // * Check if cow too young to be sold
    if (!context.mounted) return;
    String? cowUnderageError = await _isCowUnderage(context, data.bornTime);
    if (cowUnderageError != null) {
      if (context.mounted) await _handleError(context, cowUnderageError);
      return;
    }

    // * ask user confirmation for selling price
    if (!context.mounted) return;
    var (double sellingPrice, String? sellValueError) = await _getCowSellValue(context, data.name);
    if (sellValueError != null) {
      if (context.mounted) await _handleError(context, sellValueError);
      return;
    }
    bool? isPriceApproved =
        await DialogHelper.forAppraisal(context, data.name, sellingPrice.round().toString());
    if (isPriceApproved != null && !isPriceApproved) {
      if (context.mounted) Navigator.pop(context);
      return;
    }

    // * call SellCow on contract after user approve the sell price
    if (!context.mounted) return;
    String? sellCowError = await _trySellCow(context, data.name, data.bornTime);
    if (sellCowError != null) {
      if (context.mounted) await _handleError(context, sellCowError);
      return;
    }

    // * pool sell notification
    if (!context.mounted) return;
    var (SellNotification? notification, String? pollError) = await _pollSellNotification(context);
    if (pollError != null) {
      if (context.mounted) await _handleError(context, pollError);
      return;
    }

    // * show dialog for failed SellCow
    bool isSellSuccess = notification?.isSuccess ?? false;
    if (!isSellSuccess) {
      unawaited(_deleteSellNotification(context));
      if (context.mounted) {
        await _handleError(context,
            notification?.failureReason ?? "failed to sell ${notification?.cowName ?? '??'}");
      }
      return;
    }

    // * load cow data from local db
    String? cowListError = await _getFullCowList(context);
    if (cowListError != null) {
      if (context.mounted) await _handleError(context, cowListError);
      return;
    }

    // * query to check balance after selling cow
    if (!context.mounted) return;
    String? checkBalanceError = await _checkBalance(context);
    if (checkBalanceError != null) {
      if (context.mounted) await _handleError(context, checkBalanceError);
      return;
    }

    // * show dialog for success SellCow
    if (context.mounted) Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    unawaited(_deleteSellNotification(context));
    await DialogHelper.successes(
        context, "you have successfully sold ${notification?.cowName ?? '??'}");
  }

  /// [feedTheCow]
  /// A set of function for calling FeedCow method on Micro Cow contract.
  Future<void> feedTheCow(BuildContext context, CowData data) async {
    // * Show waiting dialog.
    if (context.mounted) DialogHelper.waiting(context);

    // * Check for cow existence
    String? existenceError = await _isCowExist(context, data.name);
    if (existenceError != null) {
      if (context.mounted) await _handleError(context, existenceError);
      return;
    }

    // * Check if cow died, you can't feed a dead one
    if (!context.mounted) return;
    String? cowDiedError = await _isCowDied(context, data.name);
    if (cowDiedError != null) {
      // * when dead cow is found, app will call BuryDeadCows method on contract
      // * after that app will update the Cow List
      if (context.mounted) await _getFullCowList(context);
      if (context.mounted) await _handleError(context, cowDiedError);
      return;
    }

    // * Check if cow still full
    if (!context.mounted) return;
    String? stillFullError = await _isCowStillFull(context, data.name);
    if (stillFullError != null) {
      if (context.mounted) await _handleError(context, stillFullError);
      return;
    }

    // * Try feed the cow
    if (!context.mounted) return;
    String? feedCowError = await _tryFeedCow(context, data.name);
    if (feedCowError != null) {
      if (context.mounted) await _handleError(context, feedCowError);
      return;
    }

    // * Update cow list
    if (!context.mounted) return;
    String? updateListError = await _getFullCowList(context);
    if (updateListError != null) {
      if (context.mounted) await _handleError(context, updateListError);
      return;
    }

    // * Pop current dialog
    if (context.mounted) Navigator.pop(context);
  }

  Future<String?> _isCowExist(BuildContext context, String cowName) async {
    String query = await GraphQLAssetBundle().loadString(GET_COW_EXISTENCE);

    if (!context.mounted) return "context not mounted";

    Map<String, dynamic> variables = {
      'cowName': cowName,
    };

    // * query to check cow existence
    var (QueryResult? result, String? error) = await GraphQLService.performQuery(
        context.read<CowProvider>().appClient!, query,
        variables: variables);

    if (error != null) {
      return error;
    }

    // * check if the cow exist
    GetCowExistence c = GetCowExistence.fromJson(result!.data!);
    bool isCowExist = c.isCowExist ?? false;
    if (!isCowExist) {
      return AppMessages.cowNotFound;
    }
    return null;
  }

  Future<String?> _isCowStillFull(BuildContext context, String cowName) async {
    String query = await GraphQLAssetBundle().loadString(IS_COW_STILL_FULL);

    if (!context.mounted) return "context not mounted";

    Map<String, dynamic> variables = {
      'cowName': cowName,
      'systemTime': DateTime.now().microsecondsSinceEpoch,
    };

    // * query to check if cow able to feed
    var (QueryResult? result, String? error) = await GraphQLService.performQuery(
        context.read<CowProvider>().appClient!, query,
        variables: variables);

    if (error != null) {
      return error;
    }

    // * can we feed the cow
    IsCowStillFull i = IsCowStillFull.fromJson(result!.data!);
    bool isFull = i.isFull ?? false;
    if (isFull) {
      return AppMessages.cowStillFull;
    }
    return null;
  }

  Future<String?> _tryFeedCow(
    BuildContext context,
    String cowName,
  ) async {
    String mutation = await GraphQLAssetBundle().loadString(FEED_COW);

    if (!context.mounted) return "context not mounted";

    Map<String, dynamic> variables = {
      'owner': context.read<CowProvider>().lineraOwner,
      'cowName': cowName,
    };

    // * mutation to feed cow
    var (QueryResult? _, String? error) = await GraphQLService.performMutation(
        context.read<CowProvider>().appClient!, mutation,
        variables: variables);

    if (error != null) {
      return error;
    }

    return null;
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

  Future<String?> _isCowDied(BuildContext context, String cowName) async {
    String query = await GraphQLAssetBundle().loadString(IS_COW_ALIVE);

    if (!context.mounted) return "context not mounted";

    Map<String, dynamic> variables = {
      'cowName': cowName,
      'systemTime': DateTime.now().microsecondsSinceEpoch,
    };

    // * query to check if cow died
    var (QueryResult? result, String? error) = await GraphQLService.performQuery(
        context.read<CowProvider>().appClient!, query,
        variables: variables);

    if (error != null) {
      return error;
    }

    // * check the cow
    IsCowAlive c = IsCowAlive.fromJson(result!.data!);
    bool isAlive = c.isAlive ?? false;
    if (!isAlive) {
      await _buryDeadCows(context);
      return AppMessages.cowNotFound;
    }
    return null;
  }

  Future<String?> _isCowUnderage(BuildContext context, int cowBornTime) async {
    String query = await GraphQLAssetBundle().loadString(IS_COW_UNDERAGE);

    if (!context.mounted) return "context not mounted";

    Map<String, dynamic> variables = {
      'cowBornTime': cowBornTime,
      'systemTime': DateTime.now().microsecondsSinceEpoch,
    };

    // * query to check if cow underage
    var (QueryResult? result, String? error) = await GraphQLService.performQuery(
        context.read<CowProvider>().appClient!, query,
        variables: variables);

    if (error != null) {
      return error;
    }

    // * check the if cow too young to be sold
    IsCowUnderage c = IsCowUnderage.fromJson(result!.data!);
    bool isUnderage = c.isUnderage ?? false;
    if (isUnderage) {
      return AppMessages.underageCow;
    }
    return null;
  }

  Future<String?> _trySellCow(
    BuildContext context,
    String cowName,
    int cowBornTime,
  ) async {
    String mutation = await GraphQLAssetBundle().loadString(SELL_COW);

    if (!context.mounted) return "context not mounted";

    Map<String, dynamic> variables = {
      'owner': context.read<CowProvider>().lineraOwner,
      'cowName': cowName,
      'cowBornTime': cowBornTime,
    };

    // * mutation to sell cow
    var (QueryResult? _, String? error) = await GraphQLService.performMutation(
        context.read<CowProvider>().appClient!, mutation,
        variables: variables);

    if (error != null) {
      return error;
    }

    return null;
  }

  Future<(SellNotification?, String?)> _pollSellNotification(BuildContext context) async {
    String query = await GraphQLAssetBundle().loadString(GET_ONE_SELL_NOTIFICATION);

    if (!context.mounted) return (null, "context not mounted");

    SellNotification? result;
    String? error;

    // * loop query to get sell notification
    int loopNum = 0;
    while (loopNum < 40) {
      if (context.mounted) {
        var (QueryResult? loopResult, String? loopError) =
            await GraphQLService.performQuery(context.read<CowProvider>().appClient!, query);

        if (loopError != null) {
          error = loopError;
          break;
        }

        SellNotificationList b = SellNotificationList.fromJson(loopResult!.data!);
        if (b.getOneSellNotification.isNotEmpty) {
          result = b.getOneSellNotification.first;
          break;
        }
      }
      loopNum++;
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    // * handle case if both result & error is null
    if (result == null && error == null) {
      return (null, "something went wrong, SellNotification is missing");
    }

    // * return error or result
    if (error != null) {
      return (null, error);
    }
    return (result, null);
  }

  Future<void> _deleteSellNotification(BuildContext context) async {
    String mutation = await GraphQLAssetBundle().loadString(DELETE_SELL_NOTIFICATION);

    if (!context.mounted) return;

    // * mutation to delete sell notification
    var (QueryResult? _, String? _) =
        await GraphQLService.performMutation(context.read<CowProvider>().appClient!, mutation);

    return;
  }

  Future<void> _buryDeadCows(BuildContext context) async {
    String mutation = await GraphQLAssetBundle().loadString(BURY_DEAD_COWS);

    if (!context.mounted) return;

    // * mutation to bury all dead cows in your farm
    var (QueryResult? _, String? _) =
        await GraphQLService.performMutation(context.read<CowProvider>().appClient!, mutation);

    return;
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

  Future<(double, String?)> _getCowSellValue(BuildContext context, String cowName) async {
    String query = await GraphQLAssetBundle().loadString(GET_COW_SELL_VALUE);

    if (!context.mounted) return (0.0, "context not mounted");

    Map<String, dynamic> variables = {
      'cowName': cowName,
    };

    // * query to check sell value
    var (QueryResult? result, String? error) = await GraphQLService.performQuery(
        context.read<CowProvider>().appClient!, query,
        variables: variables);

    if (error != null) {
      return (0.0, error);
    }

    // * check sell value
    GetCowSellValue s = GetCowSellValue.fromJson(result!.data!);
    double sellValue = double.tryParse(s.value ?? '0') ?? 0;

    return (sellValue, null);
  }

  Future<void> _handleError(BuildContext context, String error) async {
    String err = error;
    if (err.length > 200) err = error.substring(0, 200);
    if (context.mounted) Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 100));
    if (context.mounted) DialogHelper.failures(context, err);
  }
}
