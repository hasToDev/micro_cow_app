import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:micro_cow_app/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late TextEditingController addressController;
  late TextEditingController rootChainIDController;
  late TextEditingController applicationIDController;

  ValueNotifier<bool> validServiceAddress = ValueNotifier<bool>(false);
  ValueNotifier<bool> checkingAddress = ValueNotifier<bool>(false);

  final double imageSizeLimit = 636;
  List<DropdownMenuEntry<String>> chainIdEntries = [];
  String initialMenuEntry = '';
  String selectedChainID = '';
  bool tryLoadFromProvider = false;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController();
    rootChainIDController = TextEditingController();
    applicationIDController = TextEditingController();
  }

  @override
  void dispose() {
    addressController.dispose();
    rootChainIDController.dispose();
    applicationIDController.dispose();
    validServiceAddress.dispose();
    checkingAddress.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (!tryLoadFromProvider) {
      // try load service address
      addressController.text = context.read<CowProvider>().graphQLServiceAddress;
      rootChainIDController.text = context.read<CowProvider>().cowRootChainID;
      applicationIDController.text = context.read<CowProvider>().cowApplicationID;

      // try fetch and load chain id
      String storageChainID = context.read<CowProvider>().lineraChainID;
      if (storageChainID.isNotEmpty) {
        await checkOnInitState(context, addressController.text, storageChainID);
      }

      tryLoadFromProvider = true;
    }
    super.didChangeDependencies();
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
                      return SizedBox(
                        height: 36,
                        child: Wrap(
                          children: [
                            Text(
                              'Linera Service Setting',
                              style: context.style.headlineLarge?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.6,
                                // fontSize: 42,
                              ),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }),
                    Builder(builder: (context) {
                      if (containerSize == 0) return const SizedBox();
                      return Container(
                        width: containerSize,
                        margin: const EdgeInsets.symmetric(vertical: 32.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(251, 253, 251, 1),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(187, 187, 187, 0.7),
                              offset: Offset(0, 5),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.9),
                              offset: Offset(2, 2),
                              blurRadius: 7,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ? Root Chain ID
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Text(
                                'Root Chain ID:',
                                style: context.style.bodyLarge?.copyWith(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: containerSize - 24,
                              child: TextFormField(
                                controller: rootChainIDController,
                                cursorHeight: 20.0,
                                cursorColor: const Color.fromRGBO(185, 102, 185, 1),
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: const Color.fromRGBO(185, 102, 185, 1),
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 0.6,
                                    ),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: false,
                                  contentPadding: const EdgeInsets.only(
                                    top: 18.0,
                                    bottom: 18.0,
                                    left: 14.0,
                                    right: 14.0,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  labelText:
                                      'fill this with Chain ID that deploy the Micro Cow contract',
                                  labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: const Color.fromRGBO(185, 102, 185, 1),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                  errorStyle: const TextStyle(
                                    height: 0.0,
                                    fontSize: 0.0,
                                    letterSpacing: 0.0,
                                  ),
                                  border: OutlineInputBorder(
                                    gapPadding: 6.0,
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(185, 102, 185, 1),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    gapPadding: 6.0,
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(185, 102, 185, 1),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    gapPadding: 6.0,
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(185, 102, 185, 1),
                                    ),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[a-z0-9]")),
                                ],
                              ),
                            ),
                            // ? Application ID
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                'Application ID:',
                                style: context.style.bodyLarge?.copyWith(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: containerSize - 24,
                              child: TextFormField(
                                controller: applicationIDController,
                                cursorHeight: 20.0,
                                cursorColor: const Color.fromRGBO(185, 102, 185, 1),
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: const Color.fromRGBO(185, 102, 185, 1),
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 0.6,
                                    ),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: false,
                                  contentPadding: const EdgeInsets.only(
                                    top: 18.0,
                                    bottom: 18.0,
                                    left: 14.0,
                                    right: 14.0,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  labelText: 'fill this with the deployed Micro Cow Application ID',
                                  labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: const Color.fromRGBO(185, 102, 185, 1),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                  errorStyle: const TextStyle(
                                    height: 0.0,
                                    fontSize: 0.0,
                                    letterSpacing: 0.0,
                                  ),
                                  border: OutlineInputBorder(
                                    gapPadding: 6.0,
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(185, 102, 185, 1),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    gapPadding: 6.0,
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(185, 102, 185, 1),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    gapPadding: 6.0,
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(185, 102, 185, 1),
                                    ),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[a-z0-9]")),
                                ],
                              ),
                            ),
                            // ? GraphQL Service Address
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                'GraphQL service address:',
                                style: context.style.bodyLarge?.copyWith(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: containerSize - 100,
                                  child: TextFormField(
                                    controller: addressController,
                                    onFieldSubmitted: (_) async {
                                      if (checkingAddress.value) return;
                                      await tryCheck(context);
                                    },
                                    onChanged: (_) {
                                      // do nothing if text changes during address checking
                                      if (checkingAddress.value) return;
                                      // invalidate service address if text value changes
                                      if (validServiceAddress.value) {
                                        selectedChainID = "";
                                        initialMenuEntry = "";
                                        validServiceAddress.value = false;
                                        chainIdEntries.clear();
                                      }
                                    },
                                    cursorHeight: 20.0,
                                    cursorColor: const Color.fromRGBO(185, 102, 185, 1),
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                          color: const Color.fromRGBO(185, 102, 185, 1),
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: 0.6,
                                        ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      isDense: false,
                                      contentPadding: const EdgeInsets.only(
                                        top: 18.0,
                                        bottom: 18.0,
                                        left: 14.0,
                                        right: 14.0,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      labelText: 'i.e. http://127.0.0.1:8080',
                                      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                            color: const Color.fromRGBO(185, 102, 185, 1),
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.0,
                                          ),
                                      errorStyle: const TextStyle(
                                        height: 0.0,
                                        fontSize: 0.0,
                                        letterSpacing: 0.0,
                                      ),
                                      border: OutlineInputBorder(
                                        gapPadding: 6.0,
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: Color.fromRGBO(185, 102, 185, 1),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        gapPadding: 6.0,
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: Color.fromRGBO(185, 102, 185, 1),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        gapPadding: 6.0,
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: Color.fromRGBO(185, 102, 185, 1),
                                        ),
                                      ),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[a-zA-Z0-9!@#\$%&*-_./,]")),
                                    ],
                                  ),
                                ),
                                ValueListenableBuilder(
                                  valueListenable: checkingAddress,
                                  builder: (context, checking, _) {
                                    if (checking) {
                                      return const Padding(
                                        padding: EdgeInsets.only(right: 12),
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(
                                            color: Colors.green,
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      );
                                    }
                                    return Container(
                                      width: 50,
                                      margin: const EdgeInsets.only(right: 8),
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          foregroundColor: Colors.red,
                                          side: const BorderSide(color: Colors.red),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14.0),
                                          ),
                                        ),
                                        child: const Text('check'),
                                        onPressed: () async {
                                          if (checkingAddress.value) return;
                                          await tryCheck(context);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            // ? CHAIN ID
                            ValueListenableBuilder(
                              valueListenable: validServiceAddress,
                              builder: (context, validAddress, _) {
                                if (!validAddress) return const SizedBox();
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text(
                                    'Chain ID:',
                                    style: context.style.bodyLarge?.copyWith(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                            ValueListenableBuilder(
                              valueListenable: validServiceAddress,
                              builder: (context, validAddress, _) {
                                if (!validAddress) return const SizedBox();

                                return DropdownMenu(
                                  width: containerSize - 24,
                                  initialSelection: initialMenuEntry,
                                  textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: const Color.fromRGBO(185, 102, 185, 1),
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 1.0,
                                      ),
                                  menuStyle: MenuStyle(
                                    backgroundColor: WidgetStateProperty.all(Colors.white),
                                  ),
                                  inputDecorationTheme: InputDecorationTheme(
                                    contentPadding: const EdgeInsets.only(
                                      top: 18.0,
                                      bottom: 18.0,
                                      left: 14.0,
                                      right: 14.0,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    errorStyle: const TextStyle(
                                      height: 0.0,
                                      fontSize: 0.0,
                                      letterSpacing: 0.0,
                                    ),
                                    border: OutlineInputBorder(
                                      gapPadding: 6.0,
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(185, 102, 185, 1),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      gapPadding: 6.0,
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(185, 102, 185, 1),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      gapPadding: 6.0,
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(185, 102, 185, 1),
                                      ),
                                    ),
                                    suffixIconColor: const Color.fromRGBO(185, 102, 185, 1),
                                  ),
                                  onSelected: (value) {
                                    if (value != null) selectedChainID = value;
                                  },
                                  dropdownMenuEntries: chainIdEntries,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    Builder(builder: (context) {
                      if (containerSize == 0) return const SizedBox();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlueRedGreenButton(
                            title: 'Cancel',
                            isBlue: false,
                            onTap: () async {
                              if (checkingAddress.value) return;
                              context.go('/login');
                            },
                          ),
                          const SizedBox(width: 20),
                          BlueRedGreenButton(
                            title: 'Confirm',
                            onTap: () async {
                              if (checkingAddress.value) return;

                              if (!validServiceAddress.value) {
                                DialogHelper.failures(context, 'invalid service address');
                                return;
                              }

                              String serviceURI = addressController.text;
                              if (addressController.text.contains("localhost")) {
                                serviceURI.replaceAll("localhost", "127.0.0.1");
                              }
                              if (!addressController.text.contains("http://")) {
                                serviceURI = 'http://$serviceURI';
                              }

                              // Save settings to provider
                              context.read<CowProvider>().saveGraphQLAddressAndChainID(
                                    serviceURI,
                                    selectedChainID,
                                    rootChainIDController.text,
                                    applicationIDController.text,
                                  );

                              // Save settings to storage.
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setString(storedChainID, selectedChainID);
                              await prefs.setString(storedGraphQLServiceAddress, serviceURI);

                              if (context.mounted) context.go('/login');
                            },
                          ),
                        ],
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

  Future<void> checkOnInitState(BuildContext context, String uri, String storageChainID) async {
    try {
      context.read<CowProvider>().setupGraphQLClient(uri);

      String query = await GraphQLAssetBundle().loadString(CHAIN_LIST);

      // * run query
      if (!context.mounted) return;
      var (QueryResult? result, String? error) =
          await GraphQLService.performQuery(context.read<CowProvider>().client!, query);
      if (error != null) {
        return;
      }

      // * Check if ChainID from storage still exist
      Chains c = Chains.fromJson(result!.data!['chains']);
      bool isChainIDFromStorageStillExist = c.list.contains(storageChainID);
      if (!isChainIDFromStorageStillExist) return;

      // * Update Chain ID Menu entries
      for (var id in c.list) {
        chainIdEntries.add(DropdownMenuEntry(value: id, label: id));
      }
      if (chainIdEntries.isNotEmpty) {
        initialMenuEntry = storageChainID;
        selectedChainID = storageChainID;
      }

      validServiceAddress.value = true;
    } catch (_) {
      return;
    }
  }

  Future<void> tryCheck(BuildContext context) async {
    // * Check Service Address
    checkingAddress.value = true;
    if (validServiceAddress.value) {
      chainIdEntries.clear();
      validServiceAddress.value = false;
    }

    String uri = addressController.text;
    if (uri.isEmpty) {
      DialogHelper.failures(context, 'please enter the GraphQL service address');
      checkingAddress.value = false;
      validServiceAddress.value = false;
      return;
    }

    try {
      context.read<CowProvider>().setupGraphQLClient(uri);
    } catch (_) {
      DialogHelper.failures(context, 'invalid address');
      checkingAddress.value = false;
      validServiceAddress.value = false;
      return;
    }

    String query = await GraphQLAssetBundle().loadString(CHAIN_LIST);

    if (context.mounted) {
      var (QueryResult? result, String? error) =
          await GraphQLService.performQuery(context.read<CowProvider>().client!, query);

      // * Return if Address Invalid
      if (error != null) {
        String err = error;
        if (err.length > 100) err = error.substring(0, 100);
        DialogHelper.failures(context, err);
        checkingAddress.value = false;
        validServiceAddress.value = false;
        return;
      }

      // * Update Chain ID Menu entries
      Chains c = Chains.fromJson(result!.data!['chains']);
      for (var id in c.list) {
        chainIdEntries.add(DropdownMenuEntry(value: id, label: id));
      }
      if (chainIdEntries.isNotEmpty) {
        initialMenuEntry = c.chainsDefault ?? chainIdEntries.first.value;
        selectedChainID = c.chainsDefault ?? chainIdEntries.first.value;
      }

      DialogHelper.successes(
          context, 'GraphQL service address is valid, please choose your Chain ID');
      checkingAddress.value = false;
      validServiceAddress.value = true;
    }
  }
}
