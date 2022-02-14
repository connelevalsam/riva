import 'package:flutter/material.dart';

class RatingsComment extends StatelessWidget {
  final List commentList;
  final int selectedIndex;
  final VoidCallback callback;

  const RatingsComment(
      {Key? key,
      required this.commentList,
      required this.selectedIndex,
      required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      scrollDirection: Axis.horizontal,
      itemCount: commentList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 30.0,
          width: 100.0,
          color: selectedIndex != null && selectedIndex == index
              ? Colors.blue[50]
              : null,
          child: ListTile(
            title: Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(commentList[index]),
            ),
            selected: index == selectedIndex,
            onTap: callback,
          ),
        );
      },
    );
  }
}
