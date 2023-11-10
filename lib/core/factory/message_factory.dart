import 'package:autozone/core/alert_dialogs/message_dialogs/car_acident.dart';
import 'package:autozone/core/alert_dialogs/message_dialogs/car_closed_enterance.dart';
import 'package:autozone/core/alert_dialogs/message_dialogs/car_disturbing.dart';
import 'package:autozone/core/alert_dialogs/message_dialogs/car_evacuation.dart';
import 'package:autozone/core/alert_dialogs/message_dialogs/car_hit.dart';
import 'package:autozone/core/alert_dialogs/message_dialogs/car_number.dart';
import 'package:autozone/core/alert_dialogs/message_dialogs/door_is_open.dart';
import 'package:autozone/core/alert_dialogs/message_dialogs/light_is_on.dart';
import 'package:flutter/material.dart';

class MessageFactory {
  static void getMessage(
      String type, BuildContext context, String number, VoidCallback sendApi) {
    switch (type) {
      case "open_door":
        doorIsOpenDialog(context, number, sendApi);
        break;
      case "disturb":
        carDisturbing(context, number, sendApi);
        break;
      case "acident":
        carAcident(context, number, sendApi);
        break;
      case "car_number":
        carNumber(context, number, sendApi);
      case "car_hit":
        carHit(context, number, sendApi);
        break;
      case "light_is_on":
        lightIsOn(context, number, sendApi);
        break;
      case "evacuation":
        carEvaquantion(context, number, sendApi);
        break;
      case "closed_enterance":
        carClosedEnterance(context, number, sendApi);
        break;
    }
  }
}
