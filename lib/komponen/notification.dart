import 'package:auto_indo/bloc/notif_bloc.dart';
import 'package:auto_indo/model/Notif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

final f = DateFormat('yyyy-MM-dd hh:mm');

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Notif> notifs = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return notifDialog(notifs);
            });
      },
      child: Stack(
        children: [
          Icon(
            LineIcons.bell,
            size: 30,
            color: Colors.white,
          ),
          BlocBuilder<NotifBloc, NotifState>(builder: (context, state) {
            if (state is NotifUnitialized) {
              return Container();
            }
            if (state is NotifLoading) {
              return Container();
            }
            NotifLoaded notifLoaded = state as NotifLoaded;
            return FutureBuilder(
              future: notifLoaded.userNotif,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.count != 0) {
                  notifs = snapshot.data!.notif!;
                  return CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      snapshot.data!.count!.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 8),
                    ),
                  );
                }
                return Container();
              },
            );
          }),
        ],
      ),
    );
  }

  Dialog notifDialog(List<Notif> notification) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Container(
        padding: EdgeInsets.all(15),
        child: SizedBox(
          width: 600,
          height: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LOG',
                style: TextStyle(fontSize: 16),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: notification.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(f.format(
                          DateTime.parse(notification[index].date!)
                              .add(Duration(hours: 7)))),
                      subtitle: Text(notification[index].notification!),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      maximumSize: const Size(90, 50),
                      backgroundColor: Colors.red[300],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(6), // Set radius here
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
