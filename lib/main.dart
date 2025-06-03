import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zavod_test/home_page.dart';
import 'package:provider/provider.dart' as provider;
import 'package:zavod_test/tools/location.dart';

void main() {
  runApp(provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider<LocationProvider>(create:(_) => LocationProvider())
      ],
    child: MyApp(),
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        minTextAdapt: true,
        ensureScreenSize: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const HomePage(),
        );
      }
    );
  }
}
