import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopbook/app/app.dart';
import 'package:shopbook/app/components/common_methos.dart';
import 'package:shopbook/app/controller/data_controller.dart';
import 'package:shopbook/app/pages/main_home_screen.dart';
import 'package:shopbook/app/pages/notification_service.dart';
import 'package:shopbook/app/utils/colors.dart';
import 'package:shopbook/main.dart';
import 'package:shopbook/models/user_model.dart';
import 'package:shopbook/utils/process_indicator.dart';

import '../pages/authentication/login_screen.dart';

class AuthController extends GetxController {
  // final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final businessController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  static Circle processIndicator = Circle();
  Rx<UserModel> currentUser = UserModel(
          id: "",
          name: "",
          phone: "",
          createdBy: "",
          password: "",
          businessName: '',
          imageUrl: '',
          deviceToken: '',
          accessToken: '', showTotal: false)
      .obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var dataController = Get.put(DataController());
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUserUid = auth.currentUser?.uid;
      if (currentUserUid == null) {
        print('No user is currently signed in.');
        return null;
      }

      final snapshot =
          await _firestore.collection('users').doc(currentUserUid).get();
      if (!snapshot.exists) {
        print('User document with ID $currentUserUid does not exist');
        return null;
      }

      final userData = snapshot.data();
      if (userData == null) {
        print('User data is null.');
        return null;
      }

      final user = UserModel.fromJson(userData as Map<String, dynamic>);
      currentUser.value = user;
      currentUser.refresh();
      NotificationService().updateUserToken(currentUser.value.id);
      update();

      return user;
    } catch (e) {
      print('Error fetching user document: $e');
      return null;
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        return UserModel.fromJson(userData);
      } else {
        print('User document with ID $userId does not exist');
        return null; // Return null if the document doesn't exist
      }
    } catch (e) {
      print('Error fetching user document: $e');
      return null;
    }
  }

  Future<String> uploadUserImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref =
        FirebaseStorage.instance.ref().child('user_images').child(fileName);

    UploadTask uploadTask = ref.putFile(imageFile);

    TaskSnapshot storageTaskSnapshot = await uploadTask;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  // Future<void> updateUserToken() async {
  //   try {
  //     // Get the current user
  //     User? user = auth.currentUser;
  //     if (user == null) {
  //       throw Exception("No user logged in");
  //     }

  //     // Get the ID token of the user
  //     String idToken = await user.getIdToken() ?? '';

  //     // Request permission to receive notifications
  //     NotificationSettings settings =
  //         await _firebaseMessaging.requestPermission(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );

  //     if (settings.authorizationStatus != AuthorizationStatus.authorized) {
  //       throw Exception("User denied notification permission");
  //     }

  //     // Update the tokens in Firestore
  //     await _firestore.collection('users').doc(user.uid).update({
  //       'token': idToken,
  //     });

  //     print('Device token and ID token updated successfully');
  //     print('ID token: $idToken');
  //   } catch (e) {
  //     print('Failed to update device token: $e');
  //   }
  // }

  Future registerUser({
    required BuildContext context,
    required File imageFile,
  }) async {
    processIndicator.show(context);
    try {
      if (passwordController.text != confirmPasswordController.text) {
        processIndicator.hide(context);
        CommonMethod.getXSnackBar("Error", "Password do not match", red);
        return;
      }

      // Create user with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: phoneController.text.trim() + '@example.com',
        password: passwordController.text.trim(),
      );

      // Upload user image
      String imageUrl = await uploadUserImage(imageFile);

      // Construct user model
      UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        createdBy: '',
        password: passwordController.text.trim(),
        businessName: businessController.text.trim(),
        imageUrl: imageUrl,
        deviceToken: '',
        accessToken: '', showTotal: false,
      );

      // Get DocumentReference
      DocumentReference userDocRef =
          _firestore.collection('users').doc(userModel.id);

// Update user document
      await userDocRef.set(userModel.toJson()).then((_) {
        // Success, perform any additional operations if needed
      }).catchError((error) {
        // Handle error
        print("Error updating user document: $error");
      });

      await NotificationService().updateUserToken(userModel.id);

      processIndicator.hide(context);
      CommonMethod.getXSnackBar("Success",
          "Registration successful: ${userCredential.user!.uid}", success);

      print('Registration successful: ${userCredential.user!.uid}');
      reLoginAdmin(userDocRef);
    } catch (e) {
      processIndicator.hide(context);
      CommonMethod.getXSnackBar("Error", "Registration Failed: $e", red);
      print('Registration failed: $e');
    }
  }

  Future reLoginAdmin(DocumentReference? reference) async {
    await FirebaseAuth.instance.signOut().whenComplete(() async {
      UserCredential adminCredential = await auth
          .signInWithEmailAndPassword(
            email: adminPhone + '@example.com',
            password: adminPassword,
          )
          .whenComplete(() => null);

      if (reference != null) {
        await reference.update({'createdBy': adminCredential.user!.uid});
      }
      Get.off(() => MainHomeScreen());
    });
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

  Future<void> editUser(
      {required String userId,
      required BuildContext context,
      required String password,
      required String phone,
      required File? userImage,
      required String? networkUrl}) async {
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

      String imageUrl = userImage != null
          ? await uploadUserImage(userImage)
          : networkUrl.toString();

      DocumentReference userDocRef = _firestore.collection('users').doc(userId);

      await userDocRef.update({
        'name': nameController.text,
        'phone': phoneController.text,
        'password': passwordController.text,
        'businessName': businessController.text,
        'networkUrl': imageUrl,
      });

      processIndicator.hide(context);
      CommonMethod.getXSnackBar(
          "Success", "User details updated successfully", success);
      reLoginAdmin(userDocRef);

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

        reLoginAdmin(null);
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

  void signOut() async {
    try {
      await auth.signOut();
      Get.offAll(LoginScreen()); // Navigate to login screen after sign-out
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out: $e',
          snackPosition: SnackPosition.BOTTOM);
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
