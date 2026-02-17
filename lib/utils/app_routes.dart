import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppStyles {
  //المفروض هتعمل زي دول

  static TextStyle semi20Black(BuildContext context) => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onBackground,
  );

  static TextStyle semi20Primary(BuildContext context) => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).primaryColor,
  );
}