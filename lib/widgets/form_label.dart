import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';

class FormLabel extends StatelessWidget {
  final String text;

  const FormLabel({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          GoogleFonts.poppins(fontWeight: FontWeight.w600, color: primaryColor),
    );
  }
}
