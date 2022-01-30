import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final void Function() onPressedFunction;
  const CustomIconButton({
    required this.iconData,
    required this.onPressedFunction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero),
        onPressed: onPressedFunction,
        child: Icon(
          iconData,
          color: Colors.black,
        ));
  }
}
