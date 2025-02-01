import 'package:auto_indo/bloc/bstate_bloc.dart';
import 'package:auto_indo/bloc/info_bloc.dart';
import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/bloc/pair_bloc.dart';
import 'package:auto_indo/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
            BlocProvider<BstateBloc>(
                create: (context) => BstateBloc(BstateUnitialized())),
          ],
          child: GlobalLoaderOverlay(
            duration: Durations.medium4,
            reverseDuration: Durations.medium4,
            overlayColor: Colors.grey.withValues(alpha: 0.8),
            overlayWidgetBuilder: (_) {
              //ignored progress for the moment
              return const Center(child: CircularProgressIndicator());
            },
            child: MaterialApp(
              title: 'Auto Indo',
              theme: ThemeData(
                  useMaterial3: true,
                  fontFamily: GoogleFonts.poppins().fontFamily),
              debugShowCheckedModeBanner: false,
              home: const LoginScreen(),
            ),
          ));
}
