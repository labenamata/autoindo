import 'package:auto_indo/bloc/bstate_bloc.dart';
import 'package:auto_indo/constants.dart';
import 'package:auto_indo/komponen/balance.dart';
import 'package:auto_indo/page/login_page.dart';
import 'package:auto_indo/page/set_keys.dart';
import 'package:auto_indo/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loader_overlay/loader_overlay.dart';

final AuthService _authService = AuthService();
Widget menuDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: backgroundColor,
    child: Column(
      children: [
        balanceWidget(),
        Expanded(
          child: ListView(padding: EdgeInsets.zero, children: [
            ListTile(
              leading: Icon(Icons.vpn_key, color: Colors.amber),
              title: Text("Key"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SetKeys(),
                  ),
                );
              },
            ),
            BlocBuilder<BstateBloc, BstateState>(builder: (context, state) {
              if (state is BstateUnitialized) {
                return ListTile(
                  leading: Icon(LineIcons.truckLoading, color: Colors.amber),
                  title: Center(
                    child: CircularProgressIndicator(),
                  ),
                  onTap: () {},
                );
              }
              if (state is BstateLoading) {
                return ListTile(
                  leading: Icon(LineIcons.truckLoading, color: Colors.amber),
                  title: Center(
                    child: CircularProgressIndicator(),
                  ),
                  onTap: () {},
                );
              }
              BstateLoaded bstateLoaded = state as BstateLoaded;
              return FutureBuilder(
                future: bstateLoaded.userBstate,
                builder: (context, snapshot) {
                  return ListTile(
                    leading: Icon(
                        snapshot.data?.state == 'off'
                            ? Icons.play_circle
                            : Icons.stop_circle,
                        color: Colors.amber),
                    title: Text(
                      snapshot.data?.state == 'off' ? 'Start Bot' : 'Stop Bot',
                    ),
                    onTap: () {
                      final stat = snapshot.data?.state == 'off' ? 'on' : 'off';
                      BstateBloc bstateBloc =
                          BlocProvider.of<BstateBloc>(context);
                      bstateBloc.add(BstateUpdate(stat));
                    },
                  );
                },
              );
            }),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () async {
              await _authService.logout();

              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.loaderOverlay.show();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
                context.loaderOverlay.hide();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Center(child: Text("Logout")),
            ),
          ),
        ),
      ],
    ),
  );
}
