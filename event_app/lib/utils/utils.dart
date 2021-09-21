import 'dart:convert';

import 'package:crypto/crypto.dart';

class Utils {
  static String convertToMD5(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }
}