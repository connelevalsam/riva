import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../themes/riva_theme.dart';
import '../widgets/widgets.dart';

class DriverArrived extends StatelessWidget {
  final int counter;
  final VoidCallback phoneNumber;
  final VoidCallback sendMessage;

  DriverArrived(
      {Key? key,
      required this.counter,
      required this.phoneNumber,
      required this.sendMessage})
      : super(key: key);

  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Future.delayed(const Duration(seconds: 20), () {});
    return Container(
      height: size.height * vh,
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: radius,
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                height: 3.0,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    color: Colors.white,
                  ),
                  width: size.width * .5, //size.width / 3,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                //************details
                Expanded(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //************picture
                      const CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/person_joe.jpeg"),
                        radius: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      //***********details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width * .3,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Sheyi Kaido',
                                    style: RivaTheme.whiteText.headline5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Toyota Camry',
                            style: RivaTheme.whiteText.headline5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '4.6',
                                style: RivaTheme.whiteText.headline5,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "1,007 Pickups",
                                style: RivaTheme.whiteText.headline5,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                //**********actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PhoneNumber(
                      callback: phoneNumber,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SendMessage(
                      counter: counter,
                      callback: sendMessage,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Text(
                    "Arrived",
                    style: RivaTheme.blackText.headline4,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 1.0),
                    child: Divider(
                      color: Colors.grey[200],
                      thickness: 0.1,
                    ),
                  ),
                  BtnWidget(
                    bgColor: Colors.grey[300],
                    txtColor: Colors.black,
                    title: "Cancel Request",
                    btnSize: .9,
                    callback: () {},
                    theme: RivaTheme.blackText.headline5,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
