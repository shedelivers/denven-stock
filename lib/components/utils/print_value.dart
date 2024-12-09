import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

void printValue(dynamic value, {String tag = ""}) {

  if (kDebugMode) {
    try{
      var decodedJSON = json.decode(value.toString()) as Map<String, dynamic>;
      log("JSON OUTPUT: $tag ${const JsonEncoder.withIndent('   ').convert(decodedJSON)}\n\n");
    }catch(_){
      if(value is Map){
        log("JSON OUTPUT: $tag ${const JsonEncoder.withIndent('   ').convert(value)}\n\n");
      }else {
        if (kDebugMode) {
          print("PRINT OUTPUT: $tag ${value.toString()}\n\n");
        }
      }
    }
  }
}