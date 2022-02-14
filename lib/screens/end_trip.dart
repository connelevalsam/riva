import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation.dart';
import '../provider/provider.dart';
import '../themes/riva_theme.dart';
import '../widgets/widgets.dart';

class EndTrip extends StatefulWidget {
  const EndTrip({Key? key}) : super(key: key);

  @override
  _EndTripState createState() => _EndTripState();
}

class _EndTripState extends State<EndTrip> {
  DateTime arrivedDate = DateTime.now();
  String? formattedArrivedDate;
  String type = "";
  int numStars = -1;
  bool hasRated = false;
  int? rating;
  dynamic result;

  final List<String> commentList = <String>[
    "Awesome Service",
    "Interesting Conversation",
    "Offered Sweets & Candy",
    "Made me laugh",
    "Smooth Driver",
    "Great Route Choice",
  ];
  String txtComment = "Awesome Service";
  int _selectedIndex = 0;
  int _starsIndex = 0;
  Color? color = Colors.blue[100];
  bool isCompliment = false;

  Widget complimentButton() {
    return ButtonTheme(
      minWidth: 50,
      height: 40,
      child: FlatButton(
        onPressed: () {
          setState(() {
            isCompliment = !isCompliment;
          });
        },
        child: Text("Give a compliment",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        color: Colors.blue[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    rating = 0;
    // formattedArrivedDate =
    //     DateFormat.yMMMMd('en_US').add_jm().format(arrivedDate);
  }

  Widget _handleRatings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          color: Theme.of(context).primaryColor,
          icon: Icon(
            (index <= numStars)
                ? Icons.star_outlined
                : Icons.star_outline_sharp,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            setState(() {
              numStars = index;
              hasRated = true;
              rating = index + 1;
            });
          },
        );
      }),
    );
  }

  Widget commentSection() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      scrollDirection: Axis.horizontal,
      itemCount: commentList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 30.0,
          width: 100.0,
          color: _selectedIndex != null && _selectedIndex == index
              ? Colors.blue[50]
              : null,
          child: ListTile(
            title: Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(commentList[index]),
            ),
            selected: index == _selectedIndex,
            onTap: () {
              setState(() {
                _selectedIndex = index;
                txtComment = commentList[index];
              });

              print('x-x-x- comment - {$txtComment} -x-x-x-x');
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context, listen: false);
    return WillPopScope(
        child: Scaffold(
          appBar: NoMemuAppBar(
            title: "Trip to ${appData.destinationAddress}",
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 10.0,
            ),
            child: Center(
              child: ListView(
                children: [
                  Center(
                    child: RichText(
                      text: TextSpan(
                          text: "Your fare is ",
                          style: Theme.of(context).textTheme.bodyText1,
                          children: [
                            TextSpan(
                              text: "\u{20A6}1200.00",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ]),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/images/person_joe.jpeg"),
                    radius: 40,
                  ),
                  Center(
                    child: Text(
                      'Sheyi Kaido',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Driver',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      'How was your trip with Sheyi Kaido',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  _handleRatings(),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      'Give a compliment',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  complimentButton(),
                  SizedBox(
                    height: (isCompliment ? 150 : 0),
                    width: 300,
                    child: (isCompliment ? commentSection() : null),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        onPrimary: Colors.white,
                        padding: const EdgeInsets.all(20),
                        fixedSize: Size.fromWidth(
                            MediaQuery.of(context).size.width * .9)),
                    onPressed: () async {
                      Loader(
                        context,
                        "Loading",
                      );
                      await Future.delayed(const Duration(seconds: 10), () {});
                      appData.cleanup();
                      Navigator.of(context).pushNamed(home);
                    },
                    child: Text(
                      'Done',
                      style: RivaTheme.whiteText.headline5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}
