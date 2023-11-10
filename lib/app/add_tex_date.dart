import 'package:autozone/app/home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TexDateChoose extends StatefulWidget {
  final String techNumber;

  const TexDateChoose({required this.techNumber, super.key});

  @override
  State<StatefulWidget> createState() => TextDateChooseState();
}

class TextDateChooseState extends State<TexDateChoose> {
  var selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 2),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Image(
              image: AssetImage("assets/Settings/BackIcon.png"),
              width: 21,
              height: 21,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff164866)),
        title: const Text(
          'Վերջնաժամկետ',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xff164866),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 54,
              decoration: const BoxDecoration(color: Color(0xffF3F4F6)),
              child: const Center(
                child: Text(
                  "Սահմանել տեխզննման վերջնաժամկետ",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
              ),
              calendarBuilders:
                  CalendarBuilders(todayBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.only(
                      left: 7, top: 5, bottom: 5, right: 7),
                  alignment: Alignment.center,
                  child: Text(
                    date.day.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }, selectedBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.only(
                      left: 7, top: 5, bottom: 5, right: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xff164866),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Text(
                    date.day.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }),
              selectedDayPredicate: (day) {
                return isSameDay(selected, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selected = selectedDay;
                });
              },
              focusedDay: selected,
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.grey),
                weekendStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.grey),
              ),
              headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                showAcceptDialog();
              },
              child: Container(
                width: 188,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xff007200),
                ),
                child: const Center(
                  child: Text(
                    "Հաստատել",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 15),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showAcceptDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 26,
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Սահմանել տեխզննման վերջնաժամկետ",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xff164866)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 26,
                ),
                Text(
                  "Ավարտ՝ ${selected.day.toString().padLeft(2, '0')}.${selected.month.toString().padLeft(2, '0')}.${selected.year}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866)),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () async {
                    Dio dio = Dio();

                    var body = {
                      "techNumber": widget.techNumber,
                      "inspection": selected.toIso8601String()
                    };

                    await dio.patch("https://autozone.onepay.am/api/v1/cars/updateCarInspection", data: body);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HomePage(isRedirect: false)));
                  },
                  child: Container(
                    width: 188,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xff007200),
                    ),
                    child: const Center(
                      child: Text(
                        "Հաստատել",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }
}
