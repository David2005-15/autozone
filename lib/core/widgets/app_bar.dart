import 'package:autozone/app/home/notifications.dart';
import 'package:flutter/material.dart';

class AutozoneAppBar extends StatelessWidget {
  final int userId;
  final int notificationCount;
  final VoidCallback onLogo;
  final VoidCallback? onNotification;

  const AutozoneAppBar(
      {required this.userId,
      required this.notificationCount,
      required this.onLogo,
      this.onNotification,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: Colors.grey[100],
          height: 1.0,
        ),
      ),
      backgroundColor: Colors.white,
      centerTitle: false,
      leadingWidth: 129,
      leading: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          onLogo();
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Image(
            image: AssetImage("assets/Settings/Logo4x.png"),
            width: 129,
            height: 30,
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: InkWell(
            onTap: () {
              if (onNotification != null) {
                onNotification!();
              }

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsPage(userId: userId)));
            },
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.notifications,
                    color: Color(0xff164866),
                    weight: 25,
                    size: 30,
                  ),
                ),
                notificationCount != 0
                    ? Positioned(
                        right: 0,
                        top: 3,
                        child: Container(
                          width: 15,
                          height: 15,
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.red,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            notificationCount.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        )
      ],
    );
  }
}
