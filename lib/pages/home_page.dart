import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:micro_cow_app/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double imageSizeLimit = 436;

  @override
  void initState() {
    super.initState();
    check();
  }

  // * check for LOGIN status
  void check() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      if (kIsWeb || Platform.isWindows) {
        // try load storage
        bool firstLoad = context.read<CowProvider>().graphQLServiceAddress.isEmpty &&
            context.read<CowProvider>().lineraPlayerChainID.isEmpty;

        if (firstLoad) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          if (!mounted) return;
          String chainID = prefs.getString(storedChainID) ?? '';
          String serviceURI = prefs.getString(storedGraphQLServiceAddress) ?? '';
          String microCowRootChainID = prefs.getString(storedRootChainID) ?? rootChainID;
          String microCowApplicationID = prefs.getString(storedApplicationID) ?? applicationID;
          context.read<CowProvider>().saveGraphQLAddressAndChainID(
              serviceURI, chainID, microCowRootChainID, microCowApplicationID);
        }

        // check login state
        bool? loggedIn = context.read<CowProvider>().isLoggedIn;
        if (!loggedIn) return context.go('/login');
        if (loggedIn) return context.go('/farm');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: const Color.fromRGBO(255, 255, 255, 0.001),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double widthLimit = constraints.maxWidth >= imageSizeLimit
                        ? imageSizeLimit
                        : constraints.maxWidth;
                    double heightLimit = constraints.maxHeight >= imageSizeLimit
                        ? imageSizeLimit
                        : constraints.maxHeight;
                    double containerSize = widthLimit <= heightLimit ? widthLimit : heightLimit;
                    containerSize = containerSize - 36;
                    if (containerSize < 0) containerSize = 0;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32.0),
                          child: SizedBox(
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
                        ),
                        Builder(builder: (context) {
                          if (containerSize == 0) return const SizedBox();

                          double titleFontSize = 42;
                          if (constraints.maxWidth < 250) titleFontSize = 32;
                          return SizedBox(
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
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
