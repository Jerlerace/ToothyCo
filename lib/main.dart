import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/supabase_auth/supabase_user_provider.dart';
import 'auth/supabase_auth/auth_util.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Material(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.error_outline_rounded, color: Colors.red, size: 36.0),
                        SizedBox(width: 8.0),
                        Text(
                          'Flutter Framework Error',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      details.exceptionAsString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Stack Trace:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      details.stack.toString(),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  };

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PreloadSplashWidget());

  try {
    GoRouter.optionURLReflectsImperativeAPIs = true;
    usePathUrlStrategy();

    await SupaFlow.initialize().timeout(const Duration(seconds: 8));

    runApp(MyApp());
  } catch (e, stackTrace) {
    runApp(MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.error_outline_rounded, color: Colors.red, size: 36.0),
                        SizedBox(width: 8.0),
                        Text(
                          'App Initialization Error',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      e.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Stack Trace:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      stackTrace.toString(),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.path;
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = toothyCOSupabaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      }, onError: (e, s) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: e,
          stack: s,
          library: 'App state userStream',
        ));
      });
    jwtTokenStream.listen((_) {}, onError: (e, s) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: s,
        library: 'jwtTokenStream',
      ));
    });
    Future.delayed(
      Duration(milliseconds: 600),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ToothyCO',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class PreloadSplashWidget extends StatelessWidget {
  const PreloadSplashWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF6B4FA8),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  color: const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(40.0),
                  border: Border.all(
                    color: const Color(0x55FFFFFF),
                    width: 2.0,
                  ),
                ),
                child: const Center(
                  child: Text(
                    '🦷',
                    style: TextStyle(
                      fontSize: 64.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28.0),
              Container(
                width: 200.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: const Color(0x44FFFFFF),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Toothy & Co.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12.0),
              Container(
                width: 60.0,
                height: 3.0,
                decoration: BoxDecoration(
                  color: const Color(0xAAFFFFFF),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Smile with Confidence',
                style: TextStyle(
                  color: Color(0xDDFFFFFF),
                  fontSize: 16.0,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
