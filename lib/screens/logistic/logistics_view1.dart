import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/provider.dart';
import '../../themes/riva_theme.dart';
import '../../widgets/widgets.dart';

class LogisticsView1 extends StatefulWidget {
  const LogisticsView1({Key? key}) : super(key: key);

  @override
  _LogisticsView1State createState() => _LogisticsView1State();
}

class _LogisticsView1State extends State<LogisticsView1> {
  final txtCurrent = TextEditingController();
  final txtDestination = TextEditingController();

  _handleGetLocation(int ch) async {
    var appData = Provider.of<AppData>(context, listen: false);
    if (ch == 0) {
      PlacesHelper().handlePressButton(context, 0);
      print("The selected address ${appData.currentAddress}");
      setState(() {
        txtCurrent.text = appData.currentAddress;
        print("2nd selected address ${appData.currentAddress}");
      });
    } else if (ch == 1) {
      await PlacesHelper().handlePressButton(context, 1);
      var result = await PlacesHelper().getSetAdr(context, 1);
      print("======= first result - $result=====");
      setState(() {
        txtDestination.text = result;
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            ListTile(
              leading: const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Icon(Icons.location_on),
              ),
              title: txtField(
                context,
                "Current address",
                txtCurrent,
                isPassword: true,
                hasOnTap: true,
                onTap: () => _handleGetLocation(0),
              ),
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Icon(
                  Icons.location_searching,
                  color: Colors.indigo[200],
                ),
              ),
              title: txtField(
                context,
                "Destination",
                txtDestination,
                isPassword: true,
                hasOnTap: true,
                onTap: () => _handleGetLocation(1),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
        Positioned(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  primary: Theme.of(context).primaryColor,
                  fixedSize:
                      Size.fromWidth(MediaQuery.of(context).size.width * .9)),
              onPressed: () {},
              child: Text(
                "Next",
                style: RivaTheme.whiteText.headline5,
              ),
            ),
          ),
          bottom: 5,
        )
      ],
    );
  }
}
