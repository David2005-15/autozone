import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomePageControlTile extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback onTap;

  const HomePageControlTile(
      {required this.title,
      required this.date,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: 74,
        width: double.infinity,
        margin: const EdgeInsets.only(right: 13, left: 13, top: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0xffF2F2F4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    width: 72,
                    height: 42,
                    child: Row(
                      children: [
                        const SizedBox(width: 5,),
                        const Image(
                          image: AssetImage(
                              "assets/Settings/IconRightChevron.png"),
                          width: 10,
                          height: 15,
                          color: Color(0xff164866),
                        ),
                        const SizedBox(width: 5,),
                        Container(
                          padding: const EdgeInsets.only(right: 2, left: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xff164866),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          height: 22,
                          width: 42,
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              date,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Color(0xff164866),
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                ),
              ],
            ),
            Container(
                margin: const EdgeInsets.only(right: 10),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Image(
                  image: AssetImage("assets/Settings/IconRightChevron.png"),
                  width: 10,
                  height: 15,
                  color: Color(0xff164866),
                ))
          ],
        ),
      ),
    );
  }
}
