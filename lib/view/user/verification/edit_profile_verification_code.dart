import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/headings.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class EditProfileVerificationCode extends StatefulWidget {
  final String phoneNum;
  EditProfileVerificationCode({Key? key, required this.phoneNum}) : super(key: key);

  @override
  _EditProfileVerificationCodeState createState() => _EditProfileVerificationCodeState();
}

class _EditProfileVerificationCodeState extends State<EditProfileVerificationCode> {
  TextEditingController otpCon = TextEditingController();
  String phoneNum = "";
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
                    text: widget.phoneNum,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: kBlackColor),
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
                  autoDisposeControllers: false,
                  textStyle: GoogleFonts.openSans(
                    color: kSecondaryColor,
                    fontSize: 34,
                  ),
                  pastedTextStyle: GoogleFonts.openSans(
                    color: kSecondaryColor,
                    fontSize: 34,
                  ),
                  length: 6,
                  obscureText: false,
                  cursorWidth: 2.0,
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
                    fieldWidth: 30,
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
                  controller: signupController.otpCon,
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
              onTap: () async {
                Get.dialog(loading());
                try {
                  if (otpCon.text.trim() != "" && otpCon.text.trim().length < 6) {
                    Get.back();
                    showMsg(context: context, msg: "Please Enter a valid 6-digit OTP.", bgColor: Colors.red);
                  } else {
                    TwilioResponse verifyResponse = await twilioPhoneVerify.verifySmsCode(
                        phone: phoneNum, code: otpCon.text.trim());
                    if (verifyResponse.successful!) {
                      showMsg(context: context, msg: "OTP Verified. Updating your new number.", bgColor: Colors.green);
                      await accounts.doc(auth.currentUser?.uid ?? "").update({"phone": phoneNum});
                      Get.back();
                      Get.back();
                    } else {
                      Get.back();
                      showMsg(
                        context: context,
                        msg: "Invalid OTP. Please Enter the 6-digit OTP that was sent to your phone.",
                        bgColor: Colors.red,
                      );
                    }
                  }
                } catch (e) {
                  Get.back();
                  showMsg(context: context, msg: "Some unknown error occurred. Please try again.", bgColor: Colors.red);
                  print(e);
                }
              },
              buttonText: 'verify',
            ),
            GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return loading();
                  },
                );
                TwilioResponse twilioResponse = await twilioPhoneVerify.sendSmsCode(phoneNum);
                if (twilioResponse.successful!) {
                  Get.back();
                } else {
                  Get.back();
                  log("error is: ${twilioResponse.errorMessage}");
                  showMsg(
                    bgColor: Colors.red,
                    context: context,
                    msg: 'Something went wrong!',
                  );
                }
              },
              child: MyText(
                paddingTop: 30,
                align: TextAlign.center,
                text: 'Resend Code',
                size: 18,
                color: kTertiaryColor,
              ),
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
