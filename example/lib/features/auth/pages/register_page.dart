import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuse_connect_example/features/auth/pages/verify_phone_page.dart';
import 'package:fuse_connect_example/features/home/pages/home_page.dart';
import 'package:fuse_connect_example/widgets/app_elevated_button.dart';
import 'package:phone_number/phone_number.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _phoneNumberTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPhoneValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: const Text('Sign up to Atmos'),
                border: const Border(),
                trailing: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const HomePage(),
                    ));
                  },
                  child: const Text('Skip'),
                ),
              )
            ];
          },
          body: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _phoneNumberTextEditingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              label: const Text('Phone number'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              prefix: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/images/features/auth/us_flag.png',
                                    width: 22,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  const Text("+1"),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                ],
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !_isPhoneValid) {
                                return 'Enter valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: _passwordTextEditingController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Password'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter valid password';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    AppElevatedButton(
                      child: const Text("Sign up"),
                      onPressed: () async {
                        await _checkPhoneNumberValidity();

                        if (_formKey.currentState!.validate()) {
                          var parsedPhoneNumber = await PhoneNumberUtil().parse(
                            _phoneNumberTextEditingController.text,
                            regionCode: "US",
                          );

                          if (!mounted) return;

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => VerifyPhonePage(
                                phoneNumber: parsedPhoneNumber.e164,
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _checkPhoneNumberValidity() async {
    bool isPhoneValid = await PhoneNumberUtil().validate(
      _phoneNumberTextEditingController.text,
      regionCode: "US",
    );

    setState(() {
      _isPhoneValid = isPhoneValid;
    });
  }
}
