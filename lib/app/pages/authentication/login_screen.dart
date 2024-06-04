import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radhe/app/app.dart';
import 'package:radhe/app/components/buttons/text_button.dart';
import 'package:radhe/app/components/common_methos.dart';
import 'package:radhe/app/components/input_text_field_widget.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/app/utils/static_decoration.dart';
import 'package:radhe/app/utils/validator.dart';
import 'package:radhe/app/widget/auth_title_widget.dart';
import 'package:radhe/app/controller/auth_controller.dart'; // Import your AuthController
import 'package:radhe/app/widget/shodow_container_widget.dart';
import '../../../main.dart';
import '../../components/custom_dialog.dart';
import '../../utils/ui.dart';
import 'create_account_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.put(AuthController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Scaffold(
          // backgroundColor: backgroundColor1,
          appBar: UiInterface.commonAppBar(leadingWidget: const SizedBox()),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  height15,
                  const AuthTitleWidget(
                    title: "Login to your Account",
                  ),
                  customHeight(40),
                  TextFormFieldWidget(
                    controller: authController.phoneController,
                    prefixIcon: Icon(
                      Icons.phone_rounded,
                      color: hintGrey,
                    ),
                    // validator: (value) {
                    //   return Validators.validateMobile(value!);
                    // },
                    hintText: "Phone number",
                    keyboardType: TextInputType.phone,
                  ),

                  height16,
                  PasswordWidget(
                    controller: authController.passwordController,
                    validator: CommonMethod().passwordValidator,
                    hintText: "Password",
                  ),
                  customHeight(50),
                  PrimaryTextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // authController.signInWithEmailAndPassword(context);
                        authController.loginUser(context);
                      }
                      // authController.loginUserWithEmailPassword(
                      //     context, _formKey);
                    },
                    title: "Log in",
                  ),
                  customHeight(25),
                  // OrWidget(),
                  // customHeight(25),
                  // TextFormFieldWidget(
                  //   controller: authController.phoneController,
                  //   prefixIcon: Icon(
                  //     Icons.phone_rounded,
                  //     color: hintGrey,
                  //   ),
                  //   // validator: (value) {
                  //   //   return Validators.validateMobile(value!);
                  //   // },
                  //   hintText: "Phone number",
                  //   keyboardType: TextInputType.phone,
                  // ),

                  // height16,
                  // PrimaryTextButton(
                  //   onPressed: () {
                  //     var value = Validators.validateMobile(
                  //         authController.phoneController.text);
                  //     if (value != null) {
                  //       CommonMethod.getXSnackBar("Failed", value, red);
                  //     } else {
                  //       authController.loginWithPhone(context);
                  //     }
                  //   },
                  //   title: "Log in with Phone",
                  // ),
                  // customHeight(30),

                  AuthDontHaveAccountWidget(
                    buttonText: "Sign up",
                    title: "Don't have an account?",
                    onTap: () {
                      TextEditingController passwordController =
                          TextEditingController();
                      CommonDialog.showSimpleDialog(
                          title: "Please Enter Password",
                          child: ShadowContainerWidget(
                            widget: Column(
                              children: [
                                height20,
                                PasswordWidget(
                                  autofocus: true,
                                  controller: passwordController,
                                  hintText: "Password",
                                ),
                                height20,
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: PrimaryTextButton(
                                    title: "Submit",
                                    onPressed: () {
                                      if (passwordController.text ==
                                          adminPassword) {
                                        // Navigate to the next screen if the password is correct

                                        Get.back();
                                        Get.to(() => CreateAccountScreen(
                                              userModel: null,
                                            ));
                                      } else {
                                        CommonMethod.getXSnackBar(
                                            "Error",
                                            "Incorrect password. Please try again.",
                                            red);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          context: context);
                      // Get.to(() => PasswordScreen());
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
