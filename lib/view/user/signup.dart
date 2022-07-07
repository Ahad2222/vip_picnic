import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/provider/user_provider/user_provider.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, UserProvider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: myAppBar(
            title: 'Register',
            onTap: () => Navigator.pop(context),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  children: [
                    pickProfileImage(context),
                    SizedBox(
                      height: 50,
                    ),
                    ETextField(
                      labelText: 'Full Name:',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ETextField(
                      labelText: 'Phone:',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ETextField(
                      labelText: 'Email:',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ETextField(
                      labelText: 'City:',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ETextField(
                      labelText: 'State:',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ETextField(
                      labelText: 'Zip:',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ETextField(
                      labelText: 'Address:',
                    ),
                    MyText(
                      text: 'Account Type',
                      size: 16,
                      weight: FontWeight.w700,
                      color: kSecondaryColor,
                      paddingBottom: 15,
                      paddingLeft: 5,
                      paddingTop: 15,
                    ),
                    Row(
                      children: List.generate(
                        2,
                        (index) {
                          return Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: 10,
                                ),
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kPrimaryColor,
                                  border: Border.all(
                                    width: 1.0,
                                    color: kBorderColor,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => UserProvider.signupAccountType(
                                      index == 0 ? 'Private' : 'Business',
                                      index,
                                    ),
                                    splashColor:
                                        kSecondaryColor.withOpacity(0.1),
                                    highlightColor: kSecondaryColor.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                    child: Center(
                                      child: UserProvider
                                                  .selectedAccountTypeIndex ==
                                              index
                                          ? Icon(
                                              Icons.check,
                                              size: 18,
                                              color: kSecondaryColor,
                                            )
                                          : SizedBox(),
                                    ),
                                  ),
                                ),
                              ),
                              MyText(
                                text: index == 0 ? 'Private' : 'Business',
                                size: 14,
                                paddingRight: 30,
                                weight: FontWeight.w500,
                                color: kSecondaryColor,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                child: MyButton(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppLinks.verifyEmail,
                  ),
                  buttonText: 'continue',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget pickProfileImage(
    BuildContext context,
  ) {
    return Center(
      child: Stack(
        children: [
          Container(
            height: 128,
            width: 128,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kBlackColor.withOpacity(0.16),
                  blurRadius: 6,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  Assets.imagesProfileAvatar,
                  height: height(context, 1.0),
                  width: width(context, 1.0),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              Assets.imagesAdd,
              height: 37.22,
            ),
          ),
        ],
      ),
    );
  }
}
