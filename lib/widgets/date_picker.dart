import 'package:flutter/material.dart';

class DatePickerFormField extends StatelessWidget {
  const DatePickerFormField({
    Key? key,
    required this.dateCtl,
  }) : super(key: key);

  final TextEditingController dateCtl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      width: 100,
      child: TextFormField(
        onTap: () async {
          DateTime? date = DateTime(1900);
          FocusScope.of(context).requestFocus(FocusNode());

          date = await showDatePicker(
            
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now());

          if (date != null) {
            dateCtl.text = '${date.day}/${date.month}/${date.year}';
          }
        },
        controller: dateCtl,
        decoration: InputDecoration(
            hintText:
                '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            border: InputBorder.none),
      ),
    );
  }
}