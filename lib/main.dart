import 'package:auto_indo/bloc/info_bloc.dart';
import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/bloc/pair_bloc.dart';
import 'package:auto_indo/utama.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
            title: 'Auto Indo',
            theme: ThemeData(
                useMaterial3: true,
                fontFamily: GoogleFonts.poppins().fontFamily),
            debugShowCheckedModeBanner: false,
            home: const Utama(),
          ));
}
