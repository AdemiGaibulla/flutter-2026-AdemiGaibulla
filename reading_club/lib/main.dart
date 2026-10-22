import 'package:flutter/material.dart';
import 'package:reading_club/utils/routes.dart';
import 'package:reading_club/screens/book_detail_screen.dart';
import 'package:reading_club/screens/book_form_screen.dart';
import 'package:reading_club/screens/shell_screen.dart';
import 'package:reading_club/models/book.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeThemeMode(ThemeMode mode){
    setState((){
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Reading Club',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode,
      initialRoute: Routes.shell,
      routes: {
        Routes.shell: (_) => ShellScreen(
          onChangeTheme: _changeThemeMode,
          currentThemeMode: _themeMode,
        ),
      },
      onGenerateRoute: (settings) {
        if(settings.name == Routes.detail){
          final arg = settings.arguments as DetailArguments;

          return MaterialPageRoute(
              builder: (_) => BookDetailScreen(book: arg.book, profileName: arg.profileName, onToggleName: arg.onToggleName, onOpenProfile: arg.onOpenProfile,onDelete: arg.onDelete,onBookUpdated: arg.onBookUpdated,),
              );
        }
        if(settings.name == Routes.form){
          final arg = settings.arguments as FormArguments;

          return MaterialPageRoute<Book>(
              settings: settings,
              builder: (_) => BookFormScreen(book: arg.book),
          );
        }
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                body: Center(child: Text('Not found'))));
      },
    );
  }
}