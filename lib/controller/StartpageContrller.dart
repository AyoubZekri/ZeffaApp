import 'package:get/get.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../LinkApi.dart';
import '../core/class/Statusrequest.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';
import '../data/datasource/Remote/Auth/logen_data.dart';

class Startpagecontrller extends GetxController {
  LoginData logenData = LoginData(Get.find());
  // List data = [];
  late int Status;
  Myservices myServices = Get.find();

  String date_experiment = "";

  Statusrequest statusrequest = Statusrequest.none;

  getUser() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await logenData.getUser();
    print("==============================$response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        var currentUser = response["data"]["data"][0];
        var user = currentUser["parent"] ?? currentUser;

        if (user['status'] != null) {
          Status = user['status'];
        }

        String imageUrl = user["image"] ?? "";
        String localPath = "";
        if (imageUrl.isNotEmpty) {
          print("==============================true");
          String fileName = imageUrl.split("/").last;
          String fullUrl = "${Applink.image}/storage/$imageUrl";
          localPath = await downloadAndCacheImage(fullUrl, fileName);
        }
        myServices.sharedPreferences!.setString("image", localPath);
        if (currentUser["email"] != null) {
          myServices.sharedPreferences!.setString(
            "email",
            currentUser["email"].toString(),
          );
        }
        if (currentUser["username"] != null) {
          myServices.sharedPreferences!.setString(
            "username",
            currentUser["username"].toString(),
          );
        }
        if (user["numperPhone"] != null) {
          myServices.sharedPreferences!.setString(
            "numperPhone",
            user["numperPhone"].toString(),
          );
        }
        if (user["hallname"] != null) {
          myServices.sharedPreferences!.setString(
            "hallname",
            user["hallname"].toString(),
          );
        }
        if (user["fieldPhone"] != null) {
          myServices.sharedPreferences!.setString(
            "fieldPhone",
            user["fieldPhone"].toString(),
          );
        }

        var roleDetails = currentUser["role_details"];
        print("===========$roleDetails");
        if (roleDetails != null) {
          if (roleDetails["type"] != null) {
            myServices.sharedPreferences!.setString(
              "type",
              roleDetails["type"].toString(),
            );
          }
          myServices.sharedPreferences!.setString(
            "permissions",
            roleDetails["permissions"],
          );
          if (roleDetails["name"] != null) {
            print("=============================${roleDetails["name"]}");
            myServices.sharedPreferences!.setString(
              "role_name",
              roleDetails["name"].toString(),
            );
          }
        }

        if (user["adresse"] != null) {
          myServices.sharedPreferences!.setString(
            "adresse",
            user["adresse"].toString(),
          );
        }
        if (user["status"] != null) {
          myServices.sharedPreferences!.setInt(
            "status",
            int.tryParse(user["status"].toString()) ?? 0,
          );
        }
        print("==================================${user["date_experiment"]}");
        if (user["date_experiment"] != null) {
          myServices.sharedPreferences!.setString(
            "date_experiment",
            user["date_experiment"].toString(),
          );
          date_experiment = user["date_experiment"].toString();
        }
      }
    }

    update();
  }

  Future<String> downloadAndCacheImage(String imageUrl, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/$fileName";

      File file = File(filePath);

      await file.parent.create(recursive: true);

      if (await file.exists()) {
        return filePath;
      }

      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }

      return "";
    } catch (e) {
      return "";
    }
  }
}
