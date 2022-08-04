import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/view/widget/headings.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode({Key? key}) : super(key: key);

  // final String phoneNumber;
  //
  // PinCodeVerificationScreen(this.phoneNumber);

  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  TextEditingController textEditingController = TextEditingController();
  bool? cont;

  // ..text = "123456";

  // ignore: close_sinks
  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  // snackBar Widget
  // snackBar(String message) {
  //   return ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         message,
  //         style: const TextStyle(fontFamily: 'Poppins'),
  //       ),
  //       duration: const Duration(seconds: 2),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: registerHeading(
                text: 'Verification Code',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: kDarkBlueColor,
                  decoration: TextDecoration.none,
                  height: 1.4,
                  fontFamily: GoogleFonts.openSans().fontFamily,
                ),
                children: [
                  TextSpan(
                    text: 'We have sent the verification code to\n',
                  ),
                  TextSpan(
                    text: '+00000000',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kBlackColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.zero,
                child: PinCodeTextField(
                  appContext: context,
                  enablePinAutofill: true,

                  textStyle: GoogleFonts.openSans(
                    color: kSecondaryColor,
                    fontSize: 34,
                  ),
                  pastedTextStyle: GoogleFonts.openSans(
                    color: kSecondaryColor,
                    fontSize: 34,
                  ),
                  length: 4,
                  obscureText: false,
                  cursorWidth: 5.0,
                  obscuringCharacter: '*',
                  blinkWhenObscuring: true,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v!.length < 4) {
                      return " ";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: 67,
                    fieldWidth: 67,
                    borderWidth: 5.0,
                    activeColor: kSecondaryColor,
                    inactiveFillColor: kSecondaryColor.withOpacity(0.30),
                    selectedColor: kSecondaryColor,
                    inactiveColor: kSecondaryColor.withOpacity(0.30),
                    selectedFillColor: kSecondaryColor.withOpacity(0.30),
                    activeFillColor: hasError ? Colors.red : kSecondaryColor,
                  ),
                  cursorColor: kSecondaryColor,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: false,
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) {
                    if (kDebugMode) {
                      print("Completed");
                    }
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    if (kDebugMode) {
                      print(value);
                    }
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    if (kDebugMode) {
                      print("Allowing to paste $text");
                    }
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              // onTap: () => Navigator.pushNamed(
              //   context,
              //   AppLinks.createPassword,
              // ),
              onTap: () {

              },
              buttonText: 'verify',
            ),
            MyText(
              paddingTop: 30,
              align: TextAlign.center,
              text: 'Resend Code',
              size: 18,
              color: kTertiaryColor,
            ),
            // // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
            //   child: Center(
            //     child: Text(
            //       hasError ? "Please provide correct verification code" : "",
            //       style: TextStyle(
            //         color: KRedColor,
            //         fontSize: 12,
            //       ),
            //     ),
            //   ),
            // ),
            // MaterialButton(
            //   height: 50,
            //   minWidth: Get.width,
            //   elevation: 0,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(6),
            //   ),
            //   highlightElevation: 0,
            //   color: kSecondaryColor,
            //   onPressed: () {
            //     // Get.to(() => PatientBottomNavBar());
            //     formKey.currentState!.validate();
            //     // conditions for validating
            //     if (currentText.length != 4 || currentText != "1234") {
            //       errorController.add(ErrorAnimationType
            //           .shake); // Triggering error shake animation
            //       setState(() {
            //         hasError = true;
            //       });
            //     } else {
            //       setState(
            //         () {
            //           hasError = false;
            //           snackBar("Code has been verified!",);
            //           Get.off(() => PatientBottomNavBar());
            //         },
            //       );
            //     }
            //   },
            //   child: MyText(
            //     size: 14,
            //     weight: FontWeight.bold,
            //     color: kSecondaryColor,
            //     text: "Verify",
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
