import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:radhe/app/components/common_methos.dart';
import 'package:radhe/app/pages/authentication/login_screen.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/utils/app_constants.dart';
import 'package:radhe/utils/network_dio/network_dio.dart';
import 'package:radhe/utils/process_indicator.dart';

import '../../app/app.dart';

NetworkRepository networkRepository = NetworkRepository();

class NetworkRepository {
  static final NetworkRepository _networkRepository =
      NetworkRepository._internal();
  static final dataStorage = GetStorage();

  factory NetworkRepository() {
    return _networkRepository;
  }

  NetworkRepository._internal();

  ///Authentication
  userLogin(context, authUserData) async {
    try {
      final authUserResponse = await NetworkDioHttp.postDioHttpMethod(
        context: context,
        url: AppConstants.apiEndPoint + AppConstants.login,
        data: authUserData,
      );
      return authUserResponse['body'];
    } catch (e) {
      CommonMethod.getXSnackBar("Error", e.toString(), red);
    }
  }

  Future<void> checkResponse(
    response,
    modelResponse,
  ) async {
    if (response["error"] == null || response["error"] == 'null') {
      if (response['body']['status'] == 200 ||
          response['body']['status'] == "200") {
        return modelResponse;
      } else if (response['body']['status'] == 400 ||
          response['body']['status'] == "400") {
        return response['body'];
      } else if (response['body']['status'] == 403 ||
          response['body']['status'] == "403") {
        return response['body'];
      } else if (response['body']['status'] == 500 ||
          response['body']['status'] == "500") {
        return modelResponse;
      } else {
        showErrorDialog(message: response['body']['message']);
      }
    } else {
      if (response['body']['status'] == 401 ||
          response['body']['status'] == '401') {
        showErrorDialog(message: response['body']['message']);
        // Future.delayed(const Duration(seconds: 2), () {
        //   Get.to(const LoginScreen());
        // });
      } else {
        showErrorDialog(message: response['body']['message']);
      }
    }
  }

  Future<void> checkResponse2({BuildContext? context, response}) async {
    if (response["error_description"] == null ||
        response["error_description"] == 'null') {
      if (response['body']['status'] == 200 ||
          response['body']['status'] == "200") {
        return response['body'];
      } else if (response['body']['status'] == 400 ||
          response['body']['status'] == "400") {
        return response['body'];
      } else if (response['body']['status'] == 403 ||
          response['body']['status'] == "403") {
        showErrorDialog(message: response['body']['message']);
        return response['body'];
      } else if (response['body']['status'] == 500 ||
          response['body']['status'] == "500") {
        showErrorDialog(message: response['body']['message']);
        return response['body'];
      } else {
        showErrorDialog(message: response['body']['message']);
      }
    } else {
      if (response['error_description'] != null) {
        if (context != null) {
          showErrorDialog(message: response['error_description']);
        }
      } else if (response['error'] != null) {
        showErrorDialog(message: response['error']);
      } else {
        showErrorDialog(message: response['body']['message']);
      }
    }
  }

  Future uploadImage({context, selectedImage, uploadType}) async {
    String url = '${AppConstants.apiEndPoint}/upload/compress/$uploadType';
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(url),
    );
    final token = await NetworkDioHttp.getHeaders();
    request.headers.addAll(token);
    request.files.add(
        await http.MultipartFile.fromPath("image", selectedImage.toString()));
    if (context != null) Circle().show(context);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var parsedJson = await json.decode(responseString);
    if (context != null) Circle().hide(context);
    if (response.statusCode == 200) {
    } else {
      return '';
    }
  }

  void showErrorDialog({required String message}) {
    if (message == "We can't find tokens in header!") {
      return;
    }
    CommonMethod.getXSnackBar("Error", message.toString(), red);
  }
}
