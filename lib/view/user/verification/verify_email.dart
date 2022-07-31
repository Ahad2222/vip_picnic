// import 'package:flutter/material.dart';
// import 'package:vip_picnic/config/routes/routes_config.dart';
// import 'package:vip_picnic/view/widget/headings.dart';
// import 'package:vip_picnic/view/widget/my_button.dart';
// import 'package:vip_picnic/view/widget/my_textfields.dart';
//
// class VerifyEmail extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 30,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: registerHeading(
//                 text: 'Verify Your E-mail',
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Center(
//               child: registerSubHeading(
//                 text:
//                     'Please enter your E-mail Address\nto receive the verify Code',
//               ),
//             ),
//             SizedBox(
//               height: 40,
//             ),
//             ETextField(
//               labelText: 'Email:',
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             MyButton(
//               onTap: () => Navigator.pushNamed(
//                 context,
//                 AppLinks.verificationCode,
//               ),
//               buttonText: 'continue',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
