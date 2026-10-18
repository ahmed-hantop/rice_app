import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rice_delivery/core/navigation/app_router.dart';
import 'package:rice_delivery/firerebase_option.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const ProviderScope(child: DriverApp()),
    ),
  );
}

class DriverApp extends ConsumerWidget {
  const DriverApp({super.key});

  @override
  Widget build  (BuildContext context, WidgetRef ref) {
    return 
    
    ScreenUtilInit(
           designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title:
           'Rice App',
          debugShowCheckedModeBanner: false,

          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

 
          routerConfig: ref.watch(routerProvider),
          builder: (context, appChild) {
            final location =
                ref
                    .read(routerProvider)
                    .routerDelegate
                    .currentConfiguration
                    .uri
                    .path;
            final isSplash = location == '/splash';
            final routedChild = appChild ?? const SizedBox.shrink();
            final child = isSplash
                ? routedChild
                : SafeArea(
                  top: false,
                  bottom: true,
                  child: routedChild,
                );
            if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusScope.of(context).unfocus(),
                child: child,
              );
            }
            return child;
          },
        );
      },
    );
  }
}
