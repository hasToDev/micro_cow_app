import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:micro_cow_app/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  final double imageSizeLimit = 436;

  @override
  void initState() {
    check();
    super.initState();
  }

  void check() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      if (kIsWeb || Platform.isWindows) {
        // try load storage
        bool firstLoad = context.read<CowProvider>().graphQLServiceAddress.isEmpty &&
            context.read<CowProvider>().lineraChainID.isEmpty;

        if (firstLoad) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          if (!mounted) return;
          String chainID = prefs.getString(storedChainID) ?? '';
          String serviceURI = prefs.getString(storedGraphQLServiceAddress) ?? '';
          bool allSettingsExist = chainID.isNotEmpty && serviceURI.isNotEmpty;

          if (allSettingsExist) {
            context.read<CowProvider>().saveGraphQLAddressAndChainID(serviceURI, chainID);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                double widthLimit =
                    constraints.maxWidth >= imageSizeLimit ? imageSizeLimit : constraints.maxWidth;
                double heightLimit = constraints.maxHeight >= imageSizeLimit
                    ? imageSizeLimit
                    : constraints.maxHeight;
                double containerSize = widthLimit <= heightLimit ? widthLimit : heightLimit;
                containerSize = containerSize - 36;
                if (containerSize < 0) containerSize = 0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Builder(builder: (context) {
                      if (containerSize == 0) return const SizedBox();

                      double titleFontSize = 42;
                      if (constraints.maxWidth < 250) titleFontSize = 32;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 48),
                        child: SizedBox(
                          height: 36,
                          child: Wrap(
                            children: [
                              Text(
                                'MICRO COW',
                                style: context.style.headlineLarge?.copyWith(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.6,
                                  fontSize: titleFontSize,
                                ),
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      width: containerSize,
                      height: containerSize,
                      child: Center(
                        child: Image.asset(
                          'assets/micro-cow-loading.png',
                          height: containerSize,
                          width: containerSize,
                          fit: BoxFit.contain,
                          gaplessPlayback: true,
                          alignment: Alignment.topCenter,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                    Builder(builder: (context) {
                      if (containerSize == 0) return const SizedBox();
                      return BlueRedGreenButton(
                        title: 'Login',
                        isBlue: false,
                        padding: const EdgeInsets.only(top: 32.0),
                        onTap: () async {
                          if (loading) return;
                          loading = true;

                          bool settingIsEmpty =
                              context.read<CowProvider>().graphQLServiceAddress.isEmpty &&
                                  context.read<CowProvider>().lineraChainID.isEmpty;
                          if (settingIsEmpty) {
                            DialogHelper.failures(
                                context, 'go to Wallet Setting to setup your wallet first.');
                            loading = false;
                            return;
                          }

                          // * show waiting dialog.
                          if (context.mounted) DialogHelper.waiting(context);

                          // * validate node service address
                          bool successValidate = await tryValidateAndLogin(context);
                          if (!successValidate) {
                            loading = false;
                            return;
                          }

                          // * check app registration of chose chain & update balance
                          if (context.mounted) {
                            bool appAvailable = await checkApplicationOnLogin(context);
                            if (!appAvailable) {
                              loading = false;
                              return;
                            }
                          }

                          // * load cow data from local db
                          if (context.mounted) {
                            String? cowListError = await _getFullCowList(context);
                            if (cowListError != null) {
                              if (context.mounted) await _handleError(context, cowListError);
                              loading = false;
                              return;
                            }
                          }

                          // * root and initialization check
                          if (context.mounted) {
                            String? rootCheckError = await _rootAndInitializationCheck(context);
                            if (rootCheckError != null) {
                              if (context.mounted) await _handleError(context, rootCheckError);
                              loading = false;
                              return;
                            }
                          }

                          // * pop loading dialog & set login status
                          if (context.mounted) Navigator.pop(context);
                          await Future.delayed(const Duration(milliseconds: 100));
                          if (context.mounted) {
                            loading = false;
                            context.read<CowProvider>().userLoggedIn();
                            context
                                .read<CowProvider>()
                                .updateEpochTime(DateTime.now().microsecondsSinceEpoch);
                            context.read<CowProvider>().epochPeriodicUpdate();
                            context.go('/farm');
                          }
                        },
                      );
                    }),
                    Builder(builder: (context) {
                      if (containerSize == 0) return const SizedBox();
                      return BlueRedGreenButton(
                        title: 'Wallet Setting',
                        width: 150,
                        padding: const EdgeInsets.only(top: 16.0),
                        onTap: () async {
                          if (loading) return;
                          context.go('/setting');
                        },
                      );
                    }),
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  /// Validate Setting and Login to Micro Cow
  Future<bool> tryValidateAndLogin(BuildContext context) async {
    // * try creating GraphQLClient
    try {
      String uri = context.read<CowProvider>().graphQLServiceAddress;
      context.read<CowProvider>().setupGraphQLClient(uri);
    } catch (_) {
      if (context.mounted) Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 100));
      if (context.mounted) {
        DialogHelper.failures(
            context, 'invalid address. go to Wallet Setting to setup your wallet.');
      }
      return false;
    }

    String query = await GraphQLAssetBundle().loadString(CHAIN_LIST);

    // * try validating
    if (context.mounted) {
      var (QueryResult? result, String? error) =
          await GraphQLService.performQuery(context.read<CowProvider>().client!, query);

      // * return if Address Invalid
      if (error != null) {
        await _handleError(context, error);
        return false;
      }

      // * Find Chain ID Index
      Chains c = Chains.fromJson(result!.data!['chains']);
      String lineraChainID = context.read<CowProvider>().lineraChainID;
      int indexOfChainID = c.list.indexOf(lineraChainID);

      // * return if Chain ID not found
      if (indexOfChainID < 0) {
        if (context.mounted) Navigator.pop(context);
        await Future.delayed(const Duration(milliseconds: 100));
        if (context.mounted) {
          DialogHelper.failures(context,
              'Chain ID not found in this node. go to Wallet Setting to setup your wallet.');
        }
        return false;
      }

      // * confirm user to use current Chain ID
      bool? confirmed;
      if (context.mounted) confirmed = await DialogHelper.forLogin(context, lineraChainID);
      if (confirmed == null || !confirmed) {
        if (context.mounted) Navigator.pop(context);
        return false;
      }
    }
    return true;
  }

  /// Check Application On Login
  Future<bool> checkApplicationOnLogin(BuildContext context) async {
    // * try creating GraphQLClient for Application
    try {
      context.read<CowProvider>().setupGraphQLAppClient();
    } catch (_) {
      if (context.mounted) Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 100));
      if (context.mounted) {
        DialogHelper.failures(
            context, 'invalid address or App ID. go to Wallet Setting to setup your wallet.');
      }
      return false;
    }

    String query = await GraphQLAssetBundle().loadString(GET_BALANCE);

    if (!context.mounted) return false;

    var (QueryResult? result, String? error) =
        await GraphQLService.performQuery(context.read<CowProvider>().appClient!, query);

    // * check if application need to request app from error message
    if (error != null && error.contains('app not registered')) {
      return await tryRegisterAppOnLogin(context);
    } else if (error != null) {
      // * show Failures dialog for other error message
      await _handleError(context, error);
      return false;
    }

    // * Get Owner
    if (!context.mounted) return false;
    String? checkOwnerError = await _checkOwner(context);
    if (checkOwnerError != null) {
      if (context.mounted) await _handleError(context, checkOwnerError);
      return false;
    }

    // * Get Balance
    Balance b = Balance.fromJson(result!.data!);
    if (context.mounted) context.read<CowProvider>().updateUserBalance(b.getBalance ?? '0');

    return true;
  }

  Future<bool> tryRegisterAppOnLogin(BuildContext context) async {
    // * waiting dialog for _requestApplication
    if (context.mounted) Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return false;
    DialogHelper.waiting(context, message: AppMessages.requestApp);

    // * request application
    String? requestAppError = await _requestApplication(context);
    if (requestAppError != null) {
      String error = requestAppError;
      if (error == 'Local node operation failed') error = 'chain must request app';
      if (context.mounted) await _handleError(context, requestAppError);
      return false;
    }

    // * waiting dialog for _initializeAccount
    if (context.mounted) Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return false;
    DialogHelper.waiting(context, message: AppMessages.initializeApp);

    // * mutation to initialize account on the requested app
    // * loop until receive definitive result
    if (!context.mounted) return false;
    String? initializeError;

    int loopNum = 0;
    while (loopNum < 40) {
      if (context.mounted) {
        initializeError = await _initializeAccount(context);
        if (initializeError == null || !initializeError.contains('app not registered')) {
          break;
        }
      }
      loopNum++;
      await Future.delayed(const Duration(milliseconds: 1500));
    }
    if (initializeError != null) {
      if (context.mounted) await _handleError(context, initializeError);
      return false;
    }

    // * query to check balance on the new initialized account
    if (!context.mounted) return false;
    String? checkBalanceError = await _checkBalance(context);
    if (checkBalanceError != null) {
      if (context.mounted) await _handleError(context, checkBalanceError);
      return false;
    }

    // * query to check owner on the new initialized account
    if (!context.mounted) return false;
    String? checkOwnerError = await _checkOwner(context);
    if (checkOwnerError != null) {
      if (context.mounted) await _handleError(context, checkOwnerError);
      return false;
    }

    return true;
  }

  Future<String?> _requestApplication(BuildContext context) async {
    String mutation = await GraphQLAssetBundle().loadString(REQUEST_APP);

    if (!context.mounted) return "context not mounted";

    Map<String, dynamic> variables = {
      'targetChainId': rootChainID,
      'applicationId': applicationID,
      'chainId': context.read<CowProvider>().lineraChainID,
    };

    // * mutation to request app from root chain
    var (QueryResult? _, String? error) = await GraphQLService.performMutation(
        context.read<CowProvider>().client!, mutation,
        variables: variables);

    if (error != null) {
      return error;
    }

    return null;
  }

  Future<String?> _initializeAccount(BuildContext context) async {
    String mutation = await GraphQLAssetBundle().loadString(INITIALIZE);

    if (!context.mounted) return "context not mounted";

    // * mutation to initialize account
    var (QueryResult? _, String? error) =
        await GraphQLService.performMutation(context.read<CowProvider>().appClient!, mutation);

    if (error != null) {
      return error;
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

  Future<String?> _checkOwner(BuildContext context) async {
    String query = await GraphQLAssetBundle().loadString(GET_OWNER);

    if (!context.mounted) return "context not mounted";

    // * query to check owner
    var (QueryResult? result, String? error) =
        await GraphQLService.performQuery(context.read<CowProvider>().appClient!, query);

    if (error != null) {
      return error;
    }

    // * Get Owner & Update Owner on Provider
    Owner o = Owner.fromJson(result!.data!);
    if (context.mounted) context.read<CowProvider>().updateOwner(o.getOwner ?? '0');

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

  Future<String?> _rootAndInitializationCheck(BuildContext context) async {
    String query = await GraphQLAssetBundle().loadString(ROOT_INITIALIZE_CHECK);

    if (!context.mounted) return "context not mounted";

    // * query to root check
    var (QueryResult? result, String? error) =
        await GraphQLService.performQuery(context.read<CowProvider>().appClient!, query);

    if (error != null) {
      return error;
    }

    // * make sure account isn't root
    RootAndInitializeCheck r = RootAndInitializeCheck.fromJson(result!.data!);
    if (r.isRoot ?? false) {
      return 'Root are not allowed to play';
    }

    // * make sure account is initialized
    bool isInitialized = r.isInitialized ?? true;
    if (!isInitialized) {
      // error being ignored, probably the account has been initialized
      String? _ = await _initializeAccount(context);
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
