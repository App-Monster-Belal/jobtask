import 'package:flutter/material.dart';

Widget customText(
    String hint,
    TextInputType keyboardType,
    TextEditingController controller,
    String? Function(String?)? validator,
     {
      bool obscureText = false,
    }) {
  return TextFormField(
    keyboardType: keyboardType,
    controller: controller,
    obscureText: obscureText,
    validator: validator,
    decoration: InputDecoration(
      hintText: hint,
      labelStyle: TextStyle(color: Colors.blueGrey), // Change label color
      filled: true,
      fillColor: Colors.grey[200], // Background color
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400), // Border color
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blue), // Focused border color
      ),
    ),
  );
}

Widget customDate(
    TextEditingController controller,
    VoidCallback? onTap,
    String text,
    ) {
  return TextField(
    controller: controller,
    readOnly: true,
    onTap: onTap,
    decoration: InputDecoration(
      hintText: text,
      labelStyle: TextStyle(color: Colors.blueGrey), // Change label color
      filled: true,
      fillColor: Colors.grey[200], // Background color
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400), // Border color
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blue), // Focused border color
      ),
    ),
  );
}

Widget customButton(VoidCallback onTap, double height, String title) {
  return InkWell(
    onTap: onTap,
    splashColor: Colors.red,
    borderRadius: BorderRadius.circular(8),
    child: Ink(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.redAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

Text aTxt(String txt, Color clr, double fsz, FontWeight fwt) {
  return Text(
    txt,
    style: TextStyle(
      color: clr,
      fontSize: fsz,
      fontWeight: fwt,
    ),
  );
}
