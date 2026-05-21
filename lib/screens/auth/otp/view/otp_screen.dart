import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/coreServices/socket_service/socket_service.dart';
import '../../../../core/utils/custom_widgets/custom_app_button.dart';
import '../../../../core/utils/custom_widgets/custom_image_view.dart';
import '../../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../../../../core/utils/helper_functions/helpers_methods.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../../../../core/utils/theams/color_resource.dart';
import '../../../home/view/bottom_controller.dart';
import '../../registration/view/registration_screen.dart';
import '../model/verify_otp_model.dart';
import '../provider/otpProvider.dart';
import '../repo/verify_otp_repository.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;
  final String countryCode;
  final String? isoCode;

  const OtpScreen({
    super.key,
    required this.mobileNumber,
    required this.countryCode,
     this.isoCode,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  String otp = '';
  bool isVerifying = false;
  String? deviceToken;


  @override
  void initState() {
    super.initState();
    _initFCMToken();
  }

  Future<void> _initFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    setState(() {
      deviceToken = token;
    });
    print("FCM Token: $token");
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<OTPProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: ColorResource.white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: height * 0.15),

                // Logo
                CustomImageView(
                  imagePath: 'assets/images/appLogoUpdated1.png',
                  height: height * 0.18,
                  width: width * 0.4,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 30),

                // OTP Sent Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          const Text(
                            'We have sent 4 Digit OTP to',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorResource.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.countryCode}${widget.mobileNumber}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: ColorResource.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: ColorResource.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // OTP Input (Pinput)
                Form(
                  key: _formKey,
                  child: Pinput(
                    length: 4,
                    keyboardType: TextInputType.number,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorResource.primaryColor),
                        color: Colors.transparent,
                      ),
                    ),
                    onCompleted: (value) => setState(() => otp = value),
                    onChanged: (value) => setState(() => otp = value),
                  ),
                ),

                const SizedBox(height: 30),

                // Send OTP Button (Gradient)
                CustomAppButton(
                  label: 'Verify OTP',
                  useGradient: true,
                  onPressed: isVerifying
                      ? () async{
                    const  ThreeDotsLoader(color: ColorResource.primaryColor);
                        }
                      : () async {
                          if (otp.length != 4) {
                            HelperMethods.showCustomSnackbar(
                              context,
                              message: 'Please enter the 4-digit OTP.',
                            );
                            return;
                          }

                          setState(() => isVerifying = true);
                          final deviceId = await HelperMethods.getDeviceId();
                          try {
                            final otpData = verifyOtp(
                              mobileNo: widget.mobileNumber,
                              otp: otp,
                              deviceId: deviceId,
                              fcmToken:deviceToken
                            );
                            final response = await VerifyOtpRepository().verifyOtpApi(otpData.toJson());

                              final isRegistered = response['isRegistered'];
                            print(isRegistered);
                            print(response);
                            print(response);
                              if (response != null && response['success'] == true && isRegistered == true) {
                                final socketService = SocketService();
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                final token = response['token'];
                                await pref.setString('token', token);
                                socketService.connect(userId: token);
                                socketService.listenToCallEvents();
                                navPushRemove(context: context, page: const BottomNavController());
                              } else if(response['success'] == true && isRegistered == false){
                                navPushRemove(
                                  context: context,
                                  page:RegistrationScreen(countryCode: widget.countryCode,mobileNumber: widget.mobileNumber,mobAvailable: true,isoCode: widget.isoCode,),
                                );
                              } else{
                                  HelperMethods.showCustomSnackbar(
                                    context,
                                    message: 'Invalid OTP. Please try again.',
                                  );
                              }
                          } catch (e) {
                            HelperMethods.showCustomSnackbar(
                              context,
                              message: 'An error occurred. Please try again.',
                            );
                          } finally {
                            setState(() => isVerifying = false);
                          }
                        },
                  child: isVerifying
                      ? const ThreeDotsLoader(color: Colors.white)
                      : null,
                ),

                const SizedBox(height: 15),

                // Resend OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't Get OTP? ",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    provider.isResendEnabled
                        ? GestureDetector(
                            onTap: () =>
                                provider.resendOTP(widget.mobileNumber),
                            child: const Text(
                              "Re-send",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorResource.primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : Text(
                            "Re-send in ${provider.timerSeconds}s",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                  ],
                ),

                SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
