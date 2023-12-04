import 'package:autozone/core/alert_dialogs/message_answer_dialogs/car_acident_answer.dart';
import 'package:autozone/core/alert_dialogs/message_answer_dialogs/car_closed_enterance_answer.dart';
import 'package:autozone/core/alert_dialogs/message_answer_dialogs/car_disturbing_answer.dart';
import 'package:autozone/core/alert_dialogs/message_answer_dialogs/car_evacuation_answer.dart';
import 'package:autozone/core/alert_dialogs/message_answer_dialogs/car_hit_answer.dart';
import 'package:autozone/core/alert_dialogs/message_answer_dialogs/car_number_answer.dart';
import 'package:autozone/core/alert_dialogs/message_answer_dialogs/door_is_open_answer.dart';
import 'package:autozone/core/alert_dialogs/message_answer_dialogs/light_is_on_answer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MessageAnswerFactory {
  static void getMessage(
      {required String type,
      required BuildContext context,
      required String number,
      required VoidCallback onClose,
      required VoidCallback onApprove,
      required Function(String) onNumberApprove,
      required String? phoneNumber,
      required int id,
      required DataSnapshot snapshot,
      required String key,
      required Function(int) onReport}) {
    switch (type) {
      case "open_door":
        doorIsOpenDialogAnswer(context, number, onClose, onApprove, id, onReport);
        break;
      case "disturb":
        carDisturbingAnswer(context, number, onClose, onApprove, id, onReport);
        break;
      case "acident":
        carAcidentAnswer(context, number, onClose, onApprove, id, onReport);
        break;
      case "car_number":
        carNumberAnswer(context, number, onClose, onNumberApprove, phoneNumber!, id, snapshot, key, onReport);
      case "car_hit":
        carHitAnswer(context, number, onClose, onApprove, id, onReport);
        break;
      case "light_is_on":
        lightIsOnAnswer(context, number, onClose, onApprove, id, onReport);
        break;
      case "evacuation":
        carEvaquantionAnswer(context, number, onClose, onApprove, id, onReport);
      case "closed_enterance":
        carClosedEnteranceAnswer(context, number, onClose, onApprove, id, onReport);
        break;
    }
  }
}
