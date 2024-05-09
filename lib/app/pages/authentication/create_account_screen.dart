import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:radhe/app/components/buttons/text_button.dart';
import 'package:radhe/app/components/input_text_field_widget.dart';
import 'package:radhe/app/controller/auth_controller.dart';
import 'package:radhe/app/utils/app_asset.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/app/utils/static_decoration.dart';
import 'package:radhe/app/utils/validator.dart';
import 'package:radhe/app/widget/auth_title_widget.dart';
import '../../components/common_methos.dart';
import '../../utils/ui.dart';
import 'login_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);
  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
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
          appBar: UiInterface.commonAppBar(
              leadingWidget: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back)),
              leadingOnTap: () {
                Get.back();
              }),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  height15,
                  const AuthTitleWidget(
                    title: "Create User Account",
                  ),
                  customHeight(40),
                  height16,
                  TextFormFieldWidget(
                    controller: authController.nameController,
                    prefixIcon: Icon(
                      Icons.person,
                      color: hintGrey,
                    ),
                    validator: (value) {
                      return Validators.validateName(value!, "Customer name");
                    },
                    hintText: "Customer name",
                    keyboardType: TextInputType.name,
                  ),
                  height16,
                  TextFormFieldWidget(
                    controller: authController.phoneController,
                    prefixIcon: Icon(
                      Icons.phone_rounded,
                      color: hintGrey,
                    ),
                    validator: (value) {
                      return Validators.validateMobile(value!);
                    },
                    hintText: "Phone number",
                    keyboardType: TextInputType.phone,
                  ),

                  height16,
                  PasswordWidget(
                    controller: authController.passwordController,
                    validator: CommonMethod().passwordValidator,
                    hintText: "Password",
                  ),
                  height16,
                  PasswordWidget(
                    controller: authController.confirmPasswordController,
                    validator: CommonMethod().passwordValidator,
                    hintText: "Confirm Password",
                  ),
                  height16,

                  PrimaryTextButton(
                    onPressed: () {
                      // if(authController.emailController.text)
                      if (_formKey.currentState!.validate()) {
                        authController.regiterUser(context);
                        // authController.registerWithEmailAndPassword(context);
                      }
                      // authController.registerUserWithEmailPassword(
                      //     context, _formKey);
                    },
                    title: "Sign Up",
                  ),
                  // height20,
                  // Platform.isIOS
                  //     ? Column(
                  //         children: [
                  //           height15,
                  //           ImageButton(
                  //             onPressed: () {},
                  //             buttonName: 'Login With Apple',
                  //             imageLink: AppAsset.icApple,
                  //           ),
                  //         ],
                  //       )
                  //     : const SizedBox(),
                  customHeight(30),
                  // AuthDontHaveAccountWidget(
                  //   buttonText: "Log in",
                  //   title: "Already have an account?",
                  //   onTap: () {
                  //     // CommonMethod().goToLoginScreen();
                  //     Get.to(() => const LoginScreen());
                  //   },
                  // ),
                  height20,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
