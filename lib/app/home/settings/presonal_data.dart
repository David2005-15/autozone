import 'package:autozone/core/factory/button_factory.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalData extends StatefulWidget {
  final String fullName;
  final String phoneNumber;
  final String? gmail;
  final VoidCallback updateState;

  const PersonalData(
      {required this.fullName,
      required this.phoneNumber,
      required this.gmail,
      required this.updateState,
      super.key});

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  String name = "";
  String email = "";
  String phone = "";

  var emailController = TextEditingController();
  var nameController = TextEditingController();

  bool isEdit = false;

  bool isValidEmail = false;

  @override
  void initState() {
    var request = getUserData();

    Future.wait([request]).then((value) {
      emailController.text = email;
      nameController.text = name;
    });

    emailController.addListener(() {
      setState(() {
        isValidEmail = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
            .hasMatch(emailController.text);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
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
              widget.updateState();
            },
            child: const Image(
              image: AssetImage("assets/Settings/BackIcon.png"),
              width: 21,
              height: 21,
            ),
          ),
        ),
        title: const Text(
          "Անձնական տվյալներ",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xff164866)),
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 25),
            child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    isEdit = !isEdit;

                    nameController.text = name;
                    emailController.text = email;
                  });
                },
                child: const Image(
                    image: AssetImage("assets/Settings/Edit.png"),
                    width: 21,
                    height: 21)),
          ),
          const SizedBox(
            width: 16,
          )
        ],
        iconTheme: const IconThemeData(color: Color(0xff164866)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              buildPersonalFullNameTile(name, "assets/Settings/ProfileIcon.png",
                  "Անուն Ազգանուն", isEdit),
              const SizedBox(
                height: 4,
              ),
              line(),
              const SizedBox(
                height: 9,
              ),
              buildPersonalDataTile(phone.replaceFirst("374", "0"),
                  "assets/Settings/PhoneNumber.png", "Հեռախոսահամար"),
              const SizedBox(
                height: 4,
              ),
              line(),
              const SizedBox(
                height: 9,
              ),
              buildPersonalDataTileEmail(
                  email, "assets/Settings/Email.png", isEdit),
              const SizedBox(
                height: 4,
              ),
              line(),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: isEdit,
                child: ButtonFactory.createButton(
                    "cta_green",
                    "Պահպանել",
                    nameController.text.isEmpty || emailController.text.isEmpty || !isValidEmail
                        ? null
                        : () async {
                            await updateEmail(
                                emailController.text, nameController.text);

                            setState(() {
                              isEdit = false;
                            });

                            getUserData();
                          },
                    double.infinity,
                    42,
                    margin:
                        const EdgeInsets.only(right: 68, left: 68, top: 37)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget line() {
    return Container(
      width: double.infinity,
      height: 1,
      margin: const EdgeInsets.only(top: 2, left: 63),
      color: const Color(0xffF5F5F5),
    );
  }

  Widget buildPersonalDataTile(String value, String path, String holder) {
    return Container(
      width: double.infinity,
      height: 52,
      color: Colors.white,
      margin: const EdgeInsets.only(
        right: 15,
        left: 15,
      ),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 12, bottom: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xffF2F2F4), width: 2),
                    borderRadius: BorderRadius.circular(6)),
                child: Image(
                  image: AssetImage(path),
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  value == "" ? holder : value,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: value == ""
                        ? const Color(0xffCCCCCC)
                        : const Color(0xff164866),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPersonalFullNameTile(
      String value, String path, String holder, bool editable) {
    return Container(
      width: double.infinity,
      height: 52,
      color: Colors.white,
      margin: const EdgeInsets.only(right: 15, left: 15),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 12, bottom: 12),
                decoration: BoxDecoration(
                    // color: const Color(0xffF2F2F4),
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xffF2F2F4), width: 2),
                    borderRadius: BorderRadius.circular(6)),
                child: Image(
                  image: AssetImage(path),
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              !editable
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value == "" ? holder : value,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: value == ""
                              ? const Color(0xffCCCCCC)
                              : const Color(0xff164866),
                        ),
                      ),
                    )
                  : Expanded(
                      child: TextField(
                      controller: nameController,
                      onChanged: (val) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                          hintText: "Անուն Ազգանուն", border: InputBorder.none),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xff164866),
                      ),
                    ))
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPersonalDataTileEmail(String value, String path, bool editable) {
    return Container(
      width: double.infinity,
      height: 52,
      color: Colors.white,
      margin: const EdgeInsets.only(right: 15, left: 15),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 12, bottom: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xffF2F2F4), width: 2),
                    borderRadius: BorderRadius.circular(6)),
                child: Image(
                  image: AssetImage(path),
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              !editable
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value == "" ? "Էլեկտրոնային հասցե" : value,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: value == ""
                              ? const Color(0xffCCCCCC)
                              : const Color(0xff164866),
                        ),
                      ),
                    )
                  : Expanded(
                      child: TextField(
                      controller: emailController,
                      onChanged: (val) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                          hintText: "էլեկտրոնային հասցե",
                          border: InputBorder.none),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xff164866),
                      ),
                    ))
            ],
          ),
        ],
      ),
    );
  }

  Future updateEmail(String mail, String fullName) async {
    Dio dio = Dio();
    var prefs = await SharedPreferences.getInstance();

    var body = {"email": mail, "fullName": fullName};

    var token = prefs.getString("token");

    await dio.patch("https://autozone.onepay.am/api/v1/users/updateUserData",
        data: body,
        options: Options(
            headers: {"Authorization": "Bearer $token"},
            validateStatus: (status) {
              return true;
            }));

    setState(() {
      email = mail;
      name = fullName;
    });

    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 1),
          content: Center(
              child: Container(
            width: double.infinity,
            height: 42,
            margin: EdgeInsets.only(
              right: 68,
              left: 68,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0xffF3F4F6)),
            child: const Center(
              child: Text(
                'Պահպանված է',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff164866)),
              ),
            ),
          )),
        ),
      );
    });
  }

  Future getUserData() async {
    Dio dio = Dio();
    var prefs = await SharedPreferences.getInstance();

    var result =
        await dio.get("https://autozone.onepay.am/api/v1/users/getData",
            options: Options(
              headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
              validateStatus: (status) {
                return true;
              },
            ));

    setState(() {
      name = result.data["User"]["fullName"];
      email = result.data["User"]["gmail"] ?? "";
      phone = result.data["User"]["phoneNumber"];
    });
  }
}
