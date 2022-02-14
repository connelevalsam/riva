import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../navigation.dart';
import '../../themes/riva_theme.dart';
import '../../widgets/widgets.dart';

class RegisterPhone extends StatefulWidget {
  const RegisterPhone({Key? key}) : super(key: key);

  @override
  _RegisterPhoneState createState() => _RegisterPhoneState();
}

class _RegisterPhoneState extends State<RegisterPhone> {
  int errCheck = 0;
  int check = 0;
  String errFieldTxt = "";

  final txtPhoneController = TextEditingController();

  void _handleSubmit() {
    setState(() {
      check = 1;
    });
    if (mounted) {
      setState(() {
        check = 0;
      });
      Navigator.pushNamed(context, registerOTP);
    }
  }

  void _handleLogin() {
    Navigator.pushReplacementNamed(context, login);
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
                                  text: "Register",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.034),
                                  children: const <TextSpan>[
                                    TextSpan(
                                        text: ' with \nyour details',
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width * .9)),
                          onPressed: _handleSubmit,
                          child: Text(
                            'Get OTP',
                            style: RivaTheme.whiteText.headline5,
                          ),
                        )
                      ],
                    ),
                    flex: 2,
                  )
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
                onPressed: _handleLogin,
                child: RichText(
                  text: TextSpan(
                      text: "You already have an Account?",
                      style: Theme.of(context).textTheme.headline6,
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Login',
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
