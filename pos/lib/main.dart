import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos/controller/db_controller/dbcontroller.dart';
import 'package:pos/controller/provider_controller/categoriesitem.dart';
import 'package:pos/controller/provider_controller/salesprovider.dart';
import 'package:pos/controller/provider_controller/share_provider.dart';
import 'package:pos/layout/desktop/desktoponboarding.dart';
import 'package:pos/layout/mobile/mobileloginpage.dart';
import 'package:pos/layout/mobile/mobileonboarding.dart';
import 'package:pos/pages/onboarding_or_home.dart';
import 'package:pos/theme/theme.dart';
import 'package:provider/provider.dart';
import 'controller/provider_controller/pageprovider.dart';
import 'layout/desktop/desktoploginpage.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ShareProvider(),),
      ChangeNotifierProvider(create: (context) => Pageprovider(),),
      ChangeNotifierProvider(create: (context) => Dbcontroller(),),
      ChangeNotifierProvider(create: (context) => Categoriesitem(),),
      ChangeNotifierProvider(create: (context) => Salesprovider(),)
    ],
    child:Consumer<ShareProvider>(
      builder: (context, value, child) {
        return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              themeMode: ThemeMode.dark,
              theme:Apptheme.lighttheme,
              darkTheme: Apptheme.darktheme,
              home:OnboardingOrHome(desktopbody: const Desktoploginpage(),mobilebody: MobileLoginpage(), mobileonboarding: const MobileOnboarding(),desktoponboarding: const Desktoponboarding(),),
            );
      },
    ),
    );
  }
}
