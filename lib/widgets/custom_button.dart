import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String? text;
  final Function()? onPressed;
  final bool? loading;
  const CustomButton({
    Key? key,
    this.text,
    this.onPressed,
    this.loading,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 57, 22, 83),
        ),
        // onpressed
        onPressed: widget.onPressed,
        child: Center(
          child: widget.loading!
              ? const CupertinoActivityIndicator(
                  radius: 12,
                  animating: true,
                  color: Colors.white,
                )
              : Text(
                  widget.text!,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
        ),
      ),
    );
  }
}
