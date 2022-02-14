import 'package:flutter/material.dart';

class Ratings extends StatelessWidget {
  final int numStars;
  final VoidCallback callback;

  const Ratings({Key? key, required this.numStars, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          onPressed: callback,
        );
      }),
    );
  }
}
