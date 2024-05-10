import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:radhe/app/components/common_methos.dart';
import 'package:radhe/app/controller/data_controller.dart';
import 'package:radhe/app/pages/main_home_screen.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/main.dart';
import 'package:radhe/models/user_model.dart';
import 'package:radhe/utils/process_indicator.dart';

import '../pages/authentication/login_screen.dart';

class AuthController extends GetxController {
  // final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final businessController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  static Circle processIndicator = Circle();
  UserModel currentUserModel = UserModel(
      id: "",
      name: "",
      phone: "",
      createdBy: "",
      password: "",
      businessName: '');
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var dataController = Get.put(DataController());
  Future getUserById(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        currentUserModel = UserModel.fromJson(userData);
      } else {
        print('User document with ID $userId does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching user document: $e');
      return null;
    }
  }

  Future regiterUser(BuildContext context) async {
    processIndicator.show(context);
    try {
      if (passwordController.text != confirmPasswordController.text) {
        processIndicator.hide(context);
        CommonMethod.getXSnackBar("Error", "Password do not match", red);
        return;
      }
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: phoneController.text.trim() + '@example.com',
        password: passwordController.text.trim(),
      );
      UserModel userModel = UserModel(
          id: userCredential.user!.uid,
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          createdBy: adminId,
          password: passwordController.text.trim(),
          businessName: businessController.text.trim());
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toJson());
      processIndicator.hide(context);

      CommonMethod.getXSnackBar("Success",
          "Registration successful: ${userCredential.user!.uid}", success);

      reLoginAdmin();

      print('Registration successful: ${userCredential.user!.uid}');
    } catch (e) {
      processIndicator.hide(context);
      CommonMethod.getXSnackBar("Error", "Registration ailed: $e", red);
      print('Registration failed: $e');
    }
  }

  Future reLoginAdmin() async {
    await FirebaseAuth.instance.signOut();
    UserCredential adminCredential = await auth
        .signInWithEmailAndPassword(
          email: adminId + '@example.com',
          password: adminPassword,
        )
        .whenComplete(() => null);

    Get.off(() => MainHomeScreen());
  }

  Future<void> loginUser(BuildContext context) async {
    processIndicator.show(context);
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: phoneController.text.trim() + '@example.com',
        password: passwordController.text.trim(),
      );

      processIndicator.hide(context);
      Get.off(() => MainHomeScreen());
      CommonMethod.getXSnackBar("Success", "Login successful", success);
      // Navigate to the home screen or perform other actions upon successful login
      print('Login successful: ${userCredential.user!.uid}');
      // Example: Get.off(() => MainHomeScreen());
    } catch (e) {
      processIndicator.hide(context);
      CommonMethod.getXSnackBar("Error", "Login failed: $e", red);
      // Display an error message to the user in case of login failure
      print('Login failed: $e');
    }
  }

  // Function to handle user logout
  Future logoutUser(BuildContext context) async {
    processIndicator.show(context);

    try {
      processIndicator.hide(context);

      await FirebaseAuth.instance.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      processIndicator.hide(context);

      print('Logout failed: $e');
    }
  }

  Future<void> editUser({
    required String userId,
    required BuildContext context,
    required String password,
    required String phone,
  }) async {
    processIndicator.show(context);

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: phone + '@example.com',
        password: password.trim(),
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(passwordController.text);
      }
      await _firestore.collection('users').doc(userId).update({
        'name': nameController.text,
        'phone': phoneController.text,
        'password': passwordController.text,
        'businessName': businessController.text,
      });

      processIndicator.hide(context);
      CommonMethod.getXSnackBar(
          "Success", "User details updated successfully", success);
      reLoginAdmin();

      print('User details updated successfully');
    } catch (e) {
      processIndicator.hide(context);
      CommonMethod.getXSnackBar(
          "Error", "Failed to update user details: $e", red);
      print('Failed to update user details: $e');
    }
  }

  Future<void> deleteAuthUser(
      {required BuildContext context,
      required String userId,
      required String phone,
      required String password}) async {
    processIndicator.show(context);
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: phone + '@example.com',
        password: password,
      );
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await dataController.deleteUserAndExpenses(userId);
        await user.delete();
        processIndicator.hide(context);

        reLoginAdmin();
        CommonMethod.getXSnackBar("Success",
            "User deleted successfully from Firebase Authentication", success);
        dataController.fetchUsers();

        // print('User deleted successfully from Firebase Authentication');
      } else {
        throw Exception('No user signed in');
      }
    } catch (e) {
      processIndicator.hide(context);

      CommonMethod.getXSnackBar("Failed",
          "Error deleting user from Firebase Authentication: $e", red);
      print('Error deleting user from Firebase Authentication: $e');
      // Handle errors
    }
  }

  @override
  void dispose() {
    // emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
