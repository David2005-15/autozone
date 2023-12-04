import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<StatefulWidget> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 2),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child:  const Image(image: AssetImage("assets/Settings/BackIcon.png"), width: 21, height: 21,),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff164866)),
        title: const Text(
          "Հրապարակային օֆերտա",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xff164866)),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.only(left: 17, right: 17),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              getPrivacyText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPrivacyText() {
    return RichText(
      text: const TextSpan(
        text: "Ա. Ընդհանուր դրույթներ\n",
        style: TextStyle(
          fontSize: 15, 
          fontWeight: FontWeight.w700,
          color: Color(0xff164866)
        ),
        children: [
          TextSpan(text: "\n"),
          TextSpan(text: "Ստորև պայմանները հանդիսանում են AutoZone հավելվածի հեղինակ «Բիգտեխլայն» ՍՊ ընկերության (այսուհետև՝ Ընկերություն) և այդ պայմաններով AutoZone հավելվածի միջոցով ծառայություն ստանալու ցանկություն հայտնած ֆիզիկական անձանց և կազմակերպությունների (այսուհետ՝ Օգտատեր) միջև ծառայությունների մատուցման հրապարակային օֆերտայի դրույթներ։ AutoZone հավելված մուտք գործելով և հավելվածի ծառայություններից օգտվելով Օգտատերը հաստատում է, որ ամբողջությամբ ծանոթացել է ծառայություններից օգտվելու պայմաններին։\n", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xff164866))),
          TextSpan(text: "\n"),
          TextSpan(text: "Ա. Անձնական տվյալների օգտագործում\n"),
          TextSpan(text: "\n"),
          TextSpan(text: "Ընկերությունը սույնով պարտավորվում է ապահովել իր Օգտատերերի անձնական տվյալների գաղտնիությունը։ Ընդունելով սույն պայմանները՝ Օգտատերը իր համաձայնությունն է տալիս Ընկերության կողմից իր անձնական տվյալների օգտագործմանը՝ այնքանով, որքանով այն անհրաժեշտ է AutoZone հավելվածի միջոցով ծառայությունների մատուցման համար։\n", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xff164866))),
          TextSpan(text: "\n"),
          TextSpan(text: "Բ. Անձնական տվյալների պահպանում\n"),
          TextSpan(text: "\n"),
          TextSpan(text: "Օգտատիրոջ համաձայնության հիման վրա մշակվող տվյալները պահպանվում են այն ժամկետով, որն Օգտատերը AutoZone հավելվածի միջոցի իր անձնական էջում կսահմանի։ Օգտատերը ցանկացած ժամանակ կարող է անձնական էջում կատարել տվյալների ուղղում, հեռացում, ինչպես նաև տվյալների մշակման դադարեցում։ Օգտատիրոջ ցանկացած հրահանգի (գործողության) դեպքում հավելվածում ավտոմատացված կերպով կիրականացվի համապատասխան գործողություն։\n", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xff164866))),
          TextSpan(text: "\n"),
          // TextSpan(text: "Գ. Վճարումներ\n"),
          // TextSpan(text: "AutoZone հավելվածի միջոցով կատարված վճարումների գումարի վերադարձ չի նախատեսվում։ Այն հանդիսանում է գանձապետական, ինչպես նաև սպասարկող (տեխզննման ծառայություն մատուցող) տեխզննման կայանի վճարումներ, որոնք վճարում կատարելուց հետո անմիջապես փոխանցվում են։\n", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xff164866))),
          // TextSpan(text: "\n"),
          TextSpan(text: "Գ. Օգտագործման այլ կանոններ\n"),
          TextSpan(text: "\n"),
          TextSpan(text: "AutoZone հավելվածի օգտագործման այլ կանոնները սահմանվում են հավելվածի համապատասխան հրահանգներով։\n", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xff164866)))
        ]
      )
    );
  }
}
