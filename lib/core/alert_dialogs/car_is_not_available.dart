import 'package:flutter/material.dart';

void car_is_not_available(BuildContext context, String auto) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 88,
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(right: 10, top: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xff164866),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.close,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Center(
                  child: Text(
                "$auto մեքենան արդեն ավելացված է մեկ այլ օգտատիրոջ կողմից։",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xff164866)),
              )),
              const SizedBox(
                height: 88,
              ),
            ],
          ),
        );
      });
}
