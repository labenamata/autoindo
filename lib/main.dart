import 'package:auto_indo/bloc/info_bloc.dart';
import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/bloc/pair_bloc.dart';
import 'package:auto_indo/theme/tema.dart';
import 'package:auto_indo/utama.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider<JaringBloc>(
                create: (context) => JaringBloc(JaringUnitialized())),
            BlocProvider<InfoBloc>(
                create: (context) => InfoBloc(InfoUnitialized())),
            BlocProvider<PairBloc>(
                create: (context) => PairBloc(PairUnitialized())),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            theme: ThemeClass.lightTheme,
            darkTheme: ThemeClass.darkTheme,
            home: const Utama(),
          ));
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Flutter Demo',
  //     debugShowCheckedModeBanner: false,
  //     themeMode: ThemeMode.dark,
  //     theme: ThemeClass.lightTheme,
  //     darkTheme: ThemeClass.darkTheme,
  //     home: const Utama(),
  //   );
  // }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
