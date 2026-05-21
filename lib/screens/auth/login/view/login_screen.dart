// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import '../../../../core/utils/custom_widgets/custom_app_button.dart';
// import '../../../../core/utils/custom_widgets/custom_image_view.dart';
// import '../../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
// import '../../../../core/utils/helper_functions/helpers_methods.dart';
//
// import '../../../../core/utils/navigation_helper.dart';
// import '../../../../core/utils/theams/color_resource.dart';
// import '../../otp/view/otp_screen.dart';
// import '../../registration/view/registration_screen.dart';
// import '../repo/login_repository.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import '../../otp/view/otp_screen.dart';
// import '../repo/login_repository.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String fullPhoneNumber = '';
//   String? countryCode = '+91';
//   String? isoCode = 'IN';
//   String? phoneNumber = '';
//   bool isAgreed = false;
//   bool isSending = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor:ColorResource.white,
//       resizeToAvoidBottomInset: true,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: ConstrainedBox(
//           constraints: BoxConstraints(minHeight: height),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 SizedBox(height: height * 0.15),
//
//                 // Logo
//                 CustomImageView(
//                   imagePath: 'assets/images/appLogoUpdated1.png',
//                   height: height * 0.18,
//                   width: width * 0.4,
//                   fit: BoxFit.contain,
//                 ),
//
//                 SizedBox(height: height * 0.05),
//
//                 // Title
//                 Text(
//                   'Please Enter Your Mobile Number',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: width * 0.05,
//                     color: ColorResource.primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//
//                 const SizedBox(height: 25),
//
//                 // Phone Input
//                 Container(
//                   padding:EdgeInsets.all(4) ,
//                   // margin: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: ColorResource.primaryColor,),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: IntlPhoneField(
//                     initialCountryCode: 'IN',
//                     showDropdownIcon: true,
//                     showCountryFlag: false,
//                     dropdownIcon: const Icon(Icons.arrow_drop_down, color: ColorResource.primaryColor),
//                     style: const TextStyle(color: Colors.black),
//                     dropdownTextStyle: const TextStyle(color: Colors.black),
//                     cursorColor: ColorResource.primaryColor,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       fillColor: ColorResource.white,
//                       hintText: 'Mobile Number',
//                       hintStyle: TextStyle(color: Colors.grey),
//                       border: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       focusedBorder: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
//                       counterText: '',
//                     ),
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     disableLengthCheck: false,
//                     // validator: (value) {
//                     //   if (value == null || value.number.isEmpty) {
//                     //     return 'Mobile number is required';
//                     //   }
//                     //   if (value.number.length < 6) {
//                     //     return 'Enter a valid number';
//                     //   }
//                     //   return null;
//                     // },
//                     onChanged: (phone) {
//                       fullPhoneNumber = phone.completeNumber;
//                       phoneNumber = phone.number;
//                       countryCode = phone.countryCode;
//                       isoCode = phone.countryISOCode;
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 // Send OTP Button with Gradient
//                 CustomAppButton(
//                   label: 'Send OTP',
//                   useGradient: true,
//                   onPressed: isSending
//                       ?(){
//                     const ThreeDotsLoader(color: ColorResource.primaryColor);
//                           }
//                       :() async {
//                     if (_formKey.currentState?.validate() == true) {
//                       if (fullPhoneNumber.isEmpty) {
//                         HelperMethods.showFloatingToast(context, message: 'Please Enter Your Mobile Number');
//                         return;
//                       }
//                       setState(() => isSending = true);
//                       var payload = {
//                         "mobile": phoneNumber,
//                         "countryCode": countryCode,
//                       };
//
//                       try {
//                         var response = await LoginRepository().getOtpApi(payload);
//                         bool isSuccess = response['success'] == true || response['sucess'] == true;
//                           // print(isoCode);
//                         if (isSuccess) {
//                           navSlideFromRight(
//                             context,
//                             OtpScreen(
//                               mobileNumber: phoneNumber ?? '',
//                               countryCode: countryCode ?? '',
//                               isoCode: isoCode,
//                             ),
//                           );
//                         } else {
//                           String message = response['message'] ?? 'Something went wrong';
//                           HelperMethods.showCustomSnackbar(context, message: message);                        }
//                       } catch (e) {
//                         HelperMethods.showCustomSnackbar(context, message: "An error occurred: $e");
//                       } finally {
//                       setState(() => isSending = false);
//                       }
//                     }
//                   },
//                   child: isSending
//                       ? const ThreeDotsLoader(color: Colors.white)
//                       : null,
//                 ),
//
//                 const SizedBox(height: 15),
//
//                 // Register Link
//                 RichText(
//                   text: TextSpan(
//                     text: "Don’t have a account? ",
//                     style: const TextStyle(color: Colors.black, fontSize: 14),
//                     children: [
//                       TextSpan(
//                         text: "Register",
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             navPush(
//                               context: context,
//                               page:const RegistrationScreen(mobAvailable: false,),
//                             );
//                           },
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 30),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../core/utils/custom_widgets/custom_app_button.dart';
import '../../../../core/utils/custom_widgets/custom_image_view.dart';
import '../../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../../../../core/utils/fontsResource/fontResource.dart';
import '../../../../core/utils/helper_functions/helpers_methods.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../../../../core/utils/theams/color_resource.dart';
import '../../otp/view/otp_screen.dart';
import '../../registration/view/registration_screen.dart';
import '../repo/login_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // Design Constants
  static const Color kPrimaryColor = Color(0xFF419CAB);
  static const Color kAccentColor = Color(0xFFF4F7F9);
  static const Color kSubtitleColor = Color(0xFF677294);

  String fullPhoneNumber = '';
  String? countryCode = '+91';
  String? isoCode = 'IN';
  String? phoneNumber = '';
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height - 100),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  /// --- APP LOGO SECTION ---
                  // Hero(
                  //   tag: 'app_logo',
                  //   child: CustomImageView(
                  //     imagePath: 'assets/images/appLogoUpdated1.png',
                  //     height: size.height * 0.15,
                  //     width: size.width * 0.5,
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),

                  const SizedBox(height: 40),

                  /// --- TEXT HEADINGS ---
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      color: const Color(0xFF171C20),
                      fontSize: 24,
                      fontFamily:FontResource.manrope,
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your credentials to access your portal',
                    style: TextStyle(
                      color: const Color(0xFF3F4850),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// --- MODERN PHONE INPUT CARD ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MOBILE NUMBER',
                        style: TextStyle(
                          color: const Color(0xFF6F7881),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                          letterSpacing: 0.60,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(

                          left: 12,
                          // bottom: 18,
                        ),
                        clipBehavior: Clip.antiAlias,

                        decoration: BoxDecoration(color: const Color(0xFFF0F4FA),borderRadius: BorderRadius.circular(14)),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: IntlPhoneField(


                            initialCountryCode: 'IN',
                            showDropdownIcon: false,
                            showCountryFlag: true, // Switched to true for better UX
                            dropdownIcon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: kSubtitleColor
                            ),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF222B45)
                            ),
                            dropdownTextStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                            ),
                            cursorColor: kPrimaryColor,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '000 000 0000',
                              hintStyle: TextStyle(color: kSubtitleColor.withOpacity(0.5)),
                              filled: true,
                              fillColor: Color(0xFFF0F4FA),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              // focusedBorder: OutlineInputBorder(
                              //   borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
                              //   borderRadius: BorderRadius.circular(16),
                              // ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                              counterText: '',
                            ),
                            onChanged: (phone) {
                              fullPhoneNumber = phone.completeNumber;
                              phoneNumber = phone.number;
                              countryCode = phone.countryCode;
                              isoCode = phone.countryISOCode;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 32),

                  /// --- ACTION BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: CustomAppButton(
                      label: isSending ? '' : 'Send OTP',
                      useGradient: true,
                      onPressed: isSending ? null : _handleLogin,
                      child: isSending
                          ? const ThreeDotsLoader(color: Colors.white)
                          : null,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// --- REGISTER FOOTER ---
                  RichText(
                    text: TextSpan(
                      text: "Don’t have an account? ",
                      style: const TextStyle(
                          color: const Color(0xFF3F4850),
                          fontSize: 15,
                          fontWeight: FontWeight.w400
                      ),
                      children: [
                        TextSpan(
                          text: "Register Now",
                          style: const TextStyle(
                            color: const Color(0xFF006492),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              navPush(
                                context: context,
                                page: const RegistrationScreen(mobAvailable: false),
                              );
                            },
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
                  // SizedBox(height: 20,),


                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar:   SafeArea(
        child: Container(
          height: 60,
          width: double.infinity,
        
          decoration: ShapeDecoration(
            color: const Color(0x0C006492),
            shape: RoundedRectangleBorder(
              // side: BorderSide(
              //   width: 1,
              //   color: const Color(0x19006492),
              // ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Color(0xFF6F7881),
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(width: 24),
                    Text(
                      'Terms of Service',
                      style: TextStyle(
                        color: Color(0xFF6F7881),
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(width: 24),
                    Text(
                      'Help Center',
                      style: TextStyle(
                        color: Color(0xFF6F7881),
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  '© 2026 The Olcure Healthcare. All rights reserved.',
                  style: TextStyle(
                    color: Color(0xFF6F7881),
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  /// Refactored Login Logic
  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() == true) {
      if (phoneNumber == null || phoneNumber!.isEmpty) {
        HelperMethods.showFloatingToast(context, message: 'Please Enter Your Mobile Number');
        return;
      }

      setState(() => isSending = true);

      final payload = {
        "mobile": phoneNumber,
        "countryCode": countryCode,
      };

      try {
        final response = await LoginRepository().getOtpApi(payload);
        final isSuccess = response['success'] == true || response['sucess'] == true;

        if (isSuccess) {
          navSlideFromRight(
            context,
            OtpScreen(
              mobileNumber: phoneNumber ?? '',
              countryCode: countryCode ?? '',
              isoCode: isoCode,
            ),
          );
        } else {
          final message = response['message'] ?? 'Something went wrong';
          HelperMethods.showCustomSnackbar(context, message: message);
        }
      } catch (e) {
        HelperMethods.showCustomSnackbar(context, message: "Connection Error: $e");
      } finally {
        if (mounted) setState(() => isSending = false);
      }
    }
  }
}