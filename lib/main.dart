import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:flutter/services.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: MyColors.primaryColor);

var kDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 0, 73, 136));

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify widgets to rebuild
  }
}

void main() {
  //to lock the orientation of the device
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp],
  // ).then((fn) {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData().copyWith(
                  scaffoldBackgroundColor: Colors.white,
                  colorScheme: kColorScheme,
                  appBarTheme: const AppBarTheme().copyWith(
                    backgroundColor: kColorScheme.onPrimaryContainer,
                    foregroundColor: kColorScheme.primaryContainer,
                  ),
                  textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: Colors.black,
                  ),
                  cardTheme: const CardTheme().copyWith(
                    color: kColorScheme.secondaryContainer,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kColorScheme.onPrimaryContainer),
                  ),
                  textTheme: ThemeData().textTheme.copyWith(
                        titleLarge: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: kColorScheme.onSecondaryContainer,
                        ),
                      ),
                ),
                darkTheme: ThemeData.dark().copyWith(
                  colorScheme: kDarkColorScheme,
                  cardTheme: const CardTheme().copyWith(
                    color: kDarkColorScheme.secondaryContainer,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  buttonTheme: const ButtonThemeData(
                    colorScheme: ColorScheme
                        .light(), // Use light color scheme for buttons
                  ),
                ),
                themeMode: themeProvider.themeMode,
                home: const Expenses(),
                builder: (context, child) {
                  return Theme(
                    data: themeProvider.themeMode == ThemeMode.dark
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: child!,
                  );
                },
              );
            },
          );
        },
      ),
    ),
  );

  // });
}
