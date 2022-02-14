import 'dart:async';

import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class RegisterOTP extends StatefulWidget {
  const RegisterOTP({Key? key}) : super(key: key);

  @override
  _RegisterOTPState createState() => _RegisterOTPState();
}

class _RegisterOTPState extends State<RegisterOTP> {
  final firstTxtFieldController = TextEditingController();
  final secondTxtFieldController = TextEditingController();
  final thirdTxtFieldController = TextEditingController();
  final fourthTxtFieldController = TextEditingController();
  final fifthTxtFieldController = TextEditingController();

  FocusNode? firstTxtFieldFocusNode;
  FocusNode? secondTxtFieldFocusNode;
  FocusNode? thirdTxtFieldFocusNode;
  FocusNode? fourthTxtFieldFocusNode;
  FocusNode? fifthTxtFieldFocusNode;

  // 0 means no error, 1 means there is an error
  int errCheck = 0;
  // 0 means nothing to check, 1 means there is a function loading
  int check = 0;
  // variable that holds error message
  String txtErr = "";
  //result returned from controller
  dynamic result;
  // 0 means no successMsg, 1 means success msg available
  int chkSuccess = 0;
  // variable that holds success message
  String txtSuccess = "";

  int _start = 30;
  Timer? _timer;
  bool? hasCompletedCountdown;

  //***********************************************
  void _timeCounter() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_start == 0) {
        setState(() {
          _timer!.cancel();
          hasCompletedCountdown = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    firstTxtFieldFocusNode!.dispose();
    secondTxtFieldFocusNode!.dispose();
    thirdTxtFieldFocusNode!.dispose();
    fourthTxtFieldFocusNode!.dispose();
    fifthTxtFieldFocusNode!.dispose();
    firstTxtFieldController.dispose();
    secondTxtFieldController.dispose();
    thirdTxtFieldController.dispose();
    fourthTxtFieldController.dispose();
    fifthTxtFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    hasCompletedCountdown = false;
    firstTxtFieldFocusNode = FocusNode();
    secondTxtFieldFocusNode = FocusNode();
    thirdTxtFieldFocusNode = FocusNode();
    fourthTxtFieldFocusNode = FocusNode();
    fifthTxtFieldFocusNode = FocusNode();

    //setting focus for the first text field
    firstTxtFieldFocusNode!.requestFocus();
    _timeCounter();
  }

  // _resendClick() async {
  //   setState(() {
  //     errCheck = 0;
  //     check = 1;
  //     chkSuccess = 0;
  //     hasCompletedCountdown = false;
  //   });
  //   result = await APIRegisteration().resendCode(userPhoneNumber);
  //   if (result is int) {
  //     setState(() {
  //       successCheck = -1;
  //       successFieldTxt = "Verification code sent";
  //       check = 1;
  //       _start = 30;
  //     });
  //     _timeCounter();
  //   } else {
  //     setState(() {
  //       //print(result);
  //       errCheck = -1;
  //       errFieldTxt = result;
  //       check = 1;
  //     });
  //   }
  // }

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            smallEntryField(
                              context,
                              "",
                              firstTxtFieldController,
                              focusNode: firstTxtFieldFocusNode,
                              nextFocus: secondTxtFieldFocusNode,
                            ),
                            smallEntryField(
                                context, "", secondTxtFieldController,
                                focusNode: secondTxtFieldFocusNode,
                                nextFocus: thirdTxtFieldFocusNode),
                            smallEntryField(
                                context, "", thirdTxtFieldController,
                                focusNode: thirdTxtFieldFocusNode,
                                nextFocus: fourthTxtFieldFocusNode),
                            smallEntryField(
                                context, "", fourthTxtFieldController,
                                focusNode: fourthTxtFieldFocusNode,
                                nextFocus: fifthTxtFieldFocusNode),
                            smallEntryField(
                                context, "", fifthTxtFieldController,
                                focusNode: fifthTxtFieldFocusNode),
                          ],
                        ),
                      ],
                    ),
                    flex: 2,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
* countDownText(
        context,
        _start.toString().padLeft(2, '0'),
      ),
* */
