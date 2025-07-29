import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nested/nested.dart';
import 'core/services/navigation_service/app_router_service.dart';
import 'dependency_injection.dart';
import 'presentation/bloc/app/access_permission/access_permission_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<AccessPermissionBloc>(
          create: (_) => AccessPermissionBloc(),
        )
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          fontFamily: 'Inter',
          scaffoldBackgroundColor: Colors.white,
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.white
          ),
          primaryColor: Colors.black87,
          cardTheme: const CardThemeData(
            color: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            foregroundColor: Colors.black87,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config(),
        locale: const Locale('id', 'ID'),
        builder: EasyLoading.init(),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('id', 'ID'),
          Locale('en', 'US'),
        ],
      ),
    );
}
