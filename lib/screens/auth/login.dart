import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/mock_riva_services.dart';
import '../../navigation.dart';
import '../../provider/user_provider.dart';
import '../../themes/riva_theme.dart';
import '../../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final txtPhoneController = TextEditingController();
  final txtPasswordController = TextEditingController();

  //0 means no error, 1 means there is an error
  int errCheck = 0;
  //0 means nothing to check, 1 means there is a function loading
  int check = 0;
  //variable that holds error message
  String errFieldTxt = "";
  //result returned from controller
  dynamic result;
  //boolean for seeing password values or not
  bool _showPassword = false;
  String txtPhone = "", txtPass = "";
  final mockService = MockRivaServices();

  void checkPasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _handleSubmit() async {
    String _password = txtPasswordController.text;
    String _phone = txtPhoneController.text;
    var result = await mockService.getUserData();
    var _rPass = result.firstWhere((element) => element.password == _password);
    print("The phone --- ${_rPass.phone}");
    print("The password --- ${_rPass.password}");
    print(_rPass);
    setState(() {
      check = 1;
    });
    if (mounted) {
      setState(() {
        check = 0;
      });
      if (_password.isEmpty && _phone.isEmpty) {
        setState(() {
          errCheck = 1;
          errFieldTxt = "Please no empty fields";
        });
        print(errFieldTxt);
      } else if (_password == _rPass.password && _phone == _rPass.phone) {
        setState(() {
          check = 1;
          errFieldTxt = "";
          errCheck = 0;
        });
        Provider.of<UserProvider>(context, listen: false).setUser(
          _rPass.phone,
          _rPass.id.toString(),
          _rPass.password,
          _rPass.profile,
        );
        Navigator.pushReplacementNamed(context, home);
      } else {
        setState(() {
          errCheck = 1;
          errFieldTxt = "Wrong credentials";
        });
      }
    }
  }

  void _handleRegister() {
    Navigator.pushNamed(context, registerPhone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/bgAuth.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 50,
                            child: RichText(
                              text: TextSpan(
                                  text: "Login",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.034),
                                  children: const <TextSpan>[
                                    TextSpan(
                                        text:
                                            ' with \npassword and phone\nnumber',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300))
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        txtField(
                          context,
                          "Phone number",
                          txtPhoneController,
                          isPassword: true,
                          hasEye: false,
                          keyboardType: TextInputType.number,
                        ),
                        txtField(
                          context,
                          "Password",
                          txtPasswordController,
                          isPassword: _showPassword,
                          hasEye: true,
                          changeEyeColor: checkPasswordVisibility,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot password?',
                            style: RivaTheme.redText.headline5,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        (check == 0
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(20),
                                    fixedSize: Size.fromWidth(
                                        MediaQuery.of(context).size.width *
                                            .9)),
                                onPressed: _handleSubmit,
                                child: Text(
                                  'Login',
                                  style: RivaTheme.whiteText.headline5,
                                ),
                              )
                            : const CircularProgressIndicator()),
                        const SizedBox(
                          height: 10,
                        ),
                        (errCheck == 0
                            ? const SizedBox(
                                height: 5,
                              )
                            : errorMsg(errFieldTxt)),
                      ],
                    ),
                    flex: 2,
                  ),
                ],
              ),
            ),
            Positioned(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.indigo[200],
                    padding: const EdgeInsets.all(20),
                    fixedSize:
                        Size.fromWidth(MediaQuery.of(context).size.width)),
                onPressed: _handleRegister,
                child: RichText(
                  text: TextSpan(
                      text: "You don't have an Account?",
                      style: Theme.of(context).textTheme.headline6,
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Register',
                          style: RivaTheme.indigoText.headline4,
                        )
                      ]),
                ),
              ),
              bottom: 0,
            )
          ],
        ),
      ),
    );
  }
}
