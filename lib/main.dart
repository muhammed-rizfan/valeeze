import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:valeeze/providers/status_provider.dart';
import 'package:valeeze/screens/home/home_page.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/screens/onboarding/onboarding_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valeeze/screens/profile/edit_profile.dart';
import 'package:valeeze/screens/profile/help.dart';
import 'package:valeeze/screens/profile/history.dart';
import 'package:valeeze/screens/profile/payment_wallet.dart';
import 'package:valeeze/screens/profile/profile_page.dart';
import 'package:valeeze/screens/profile/terms_condition.dart';
import 'package:valeeze/screens/send/booking_summary.dart';
import 'package:valeeze/screens/send/find_transporter.dart';
import 'package:valeeze/screens/send/payment.dart';
import 'package:valeeze/screens/send/send_complete.dart';
import 'package:valeeze/screens/send/send_page.dart';
import 'package:valeeze/screens/send/transporter.dart';
import 'package:valeeze/screens/send/transporter_profile.dart';
import 'package:valeeze/screens/transporter/become_transporter.dart';
import 'package:valeeze/screens/transporter/add_new_trip.dart';
import 'package:valeeze/screens/transporter/trip_done.dart';
import 'package:valeeze/screens/transporter/trips_home.dart';
import 'package:valeeze/screens/transporter/upload_doc_complete.dart';
import 'package:valeeze/screens/transporter/upload_documents.dart';
import 'package:valeeze/screens/travel_log/travel_log_home.dart';
import 'package:valeeze/utils/root_page.dart';
import 'screens/auth/login_page.dart';
import 'screens/send/ready.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MyApp());
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StatusProvider()),
      ],
      child: ScreenUtilInit(
        // designSize: Size(393, 830), // emulator
        // designSize: Size(360, 780), // my phone
        designSize: Size(360, 640), // figma size
        builder: () => MaterialApp(
          supportedLocales: [
            Locale("en"),
          ],
          localizationsDelegates: [
            CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          title: 'Valeeze',
          theme: ThemeData(
            primarySwatch: Colors.yellow,
          ),
          home: RootPage(),
          routes: {
            'done': (context) => SendComplete(),
          },
        ),
      ),
    );
  }
}
