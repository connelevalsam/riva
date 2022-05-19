import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../widgets/widgets.dart';
import '../screens.dart';

class Logistics extends StatefulWidget {
  const Logistics({Key? key}) : super(key: key);

  @override
  _LogisticsState createState() => _LogisticsState();
}

class _LogisticsState extends State<Logistics> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // var result = fetchPro();
    // result.then((value) => print("-------fetched = ${value}"));
  }

  Future fetchPro() async {
    var url = Uri.parse('http://192.168.42.141:3000/api/hello');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return (response.body);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: SizedBox(
              width: size.width * .7,
              child: Row(
                children: <Widget>[
                  const ProgressTabView(title: "1", active: true),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                  const ProgressTabView(title: "2", active: false),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                  const ProgressTabView(title: "3", active: false),
                ],
              ),
            ),
            bottom: const TabBar(tabs: [
              Tab(
                text: "Errand",
              ),
              Tab(
                text: "Logistics",
              ),
            ]),
          ),
          body: TabBarView(children: [
            const ErrandView1(),
            const LogisticsView1(),
          ]),
        ));
  }
}
