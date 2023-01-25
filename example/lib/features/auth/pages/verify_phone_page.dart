import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuse_connect_example/constants/colors.dart';
import 'package:fuse_connect_example/widgets/app_elevated_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhonePage extends StatefulWidget {
  final String phoneNumber;
  const VerifyPhonePage({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  final GlobalKey<ScaffoldState> _pinKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              const CupertinoSliverNavigationBar(
                backgroundColor: Colors.white,
                border: Border(),
                largeTitle: Text('5-digit code'),
              )
            ];
          },
          body: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Please enter the code we've sent to ${widget.phoneNumber}",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PinCodeTextField(
                          key: _pinKey,
                          appContext: context,
                          textStyle: Theme.of(context).textTheme.bodyText2,
                          length: 5,
                          mainAxisAlignment: MainAxisAlignment.start,
                          validator: (v) {
                            return null;
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeColor: AppColors.graySwatch[400],
                            inactiveColor: AppColors.graySwatch[400],
                            borderWidth: 1,
                            selectedColor: AppColors.graySwatch[400],
                            activeFillColor: Colors.white,
                            selectedFillColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            fieldOuterPadding: const EdgeInsets.only(right: 14),
                          ),
                          cursorColor: Colors.black,
                          enableActiveFill: true,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.none,
                          onCompleted: (v) async {},
                          beforeTextPaste: (text) {
                            return true;
                          },
                          onChanged: (String value) {},
                        ),
                      ],
                    ),
                  ),
                  AppElevatedButton(
                    child: const Text("Sign up"),
                    onPressed: () async {
                      // print('Sign up tapped');

                      // var clientSecret = await API.createClientSecret(
                      //   phone: widget.phoneNumber,
                      //   template: "KycAndBankLinking",
                      // );

                      // print("Client secret $clientSecret");

                      // FuseOnboardingKit fuseOnboardingKit = FuseOnboardingKit(
                      //   onSuccess: (publicToken) async {
                      //     if (kDebugMode) {
                      //       print('Public token');
                      //     }

                      //     await API.exchangePublicToken(
                      //         publicToken: publicToken);

                      //     if (kDebugMode) {
                      //       print("On success");
                      //     }
                      //     if (!mounted) return;

                      //     Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (_) => const HomePage(),
                      //     ));
                      //   },
                      //   onExit: (error) {
                      //     if (kDebugMode) {
                      //       print("On exit");
                      //     }
                      //   },
                      //   onInstitutionSelected:
                      //       (String institutionId, callBack) async {
                      //     String linkToken = API.createLinkToken(
                      //       institutionId: institutionId,
                      //       userId: "1383839374",
                      //       clientSecret: clientSecret,
                      //     );

                      //     callBack(linkToken);
                      //   },
                      // );

                      // fuseOnboardingKit.open(clientSecret);
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
