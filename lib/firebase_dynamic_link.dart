import 'package:autozone/app/home/texzznum.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class FirebaseDynamicLink {
  static Future<String> createDynamicLink(TexPageData data) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "https://autozone.onepay.am/pay?autoNumber=${data.autoNumber}&regNumber=${data.regNumber}&inspectionDate=${data.inspectionDate}&userId=${data.user_id}&dahk=${data.dahk}"),
      uriPrefix: "https://autozone13.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.autozone13",
        minimumVersion: 30,
      ),
      // iosParameters: const IOSParameters(
      //   bundleId: "com.example.app.ios",
      //   appStoreId: "123456789",
      //   minimumVersion: "1.0.1",
      // ),
      // googleAnalyticsParameters: const GoogleAnalyticsParameters(
      //   source: "twitter",
      //   medium: "social",
      //   campaign: "example-promo",
      // ),
      // socialMetaTagParameters: SocialMetaTagParameters(
      //   title: "Example of a Dynamic Link",
      //   imageUrl: Uri.parse("https://example.com/image.png"),
      // ),
    );

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    Uri url = dynamicLink.shortUrl;

    return url.toString();
  }

  static initDynamicLink(BuildContext context) {
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData link) {
      Uri deepLink = link.link;

      var autoNumber = deepLink.queryParameters["autoNumber"].toString();
      var regNumber = deepLink.queryParameters["regNumber"].toString();
      var inspectionDate =
          DateTime.parse(deepLink.queryParameters["inspectionDate"].toString());
      var userId = int.parse(deepLink.queryParameters["userId"].toString());
      var dahk = bool.parse(deepLink.queryParameters["dahk"].toString());

      TexPageData data = TexPageData(
          inspectionDate: inspectionDate,
          regNumber: regNumber,
          autoNumber: autoNumber,
          user_id: userId,
          dahk: dahk);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => TexPage(data: data)));
    });
  }
}
