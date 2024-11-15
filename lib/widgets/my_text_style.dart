import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget myText(String text,
    {Color color = Colors.black,
    double size = 14,
    FontWeight weight = FontWeight.normal,
    TextAlign textalign = TextAlign.start}) {
  return Text(
    text,
    style: GoogleFonts.nunito(
      color: color,
      fontSize: size,
      fontWeight: weight,
    ),
    textAlign: textalign,
  );
}
