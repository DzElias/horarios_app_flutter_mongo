import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    Key? key,
    this.ctl,
    required this.hintText,
    required this.width,
    this.size,
    this.color,
    this.onChange,
    this.onTap
  }) : super(key: key) ;

  TextEditingController? ctl;
  final String hintText;
  final double width;
  Color? color;
  double? size;
  void Function(String)? onChange;

  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: (color != null) ? color :  Colors.white,
          borderRadius: const  BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      width: width,
      child: TextFormField(
        onChanged: onChange ?? (value) {},
        onTap: onTap?? (){},
        controller: ctl,
        decoration: InputDecoration(hintText: hintText, border: InputBorder.none, hintStyle: TextStyle(fontSize: (size != null)?  size : 16)),
        
      ),
    );
  }
}