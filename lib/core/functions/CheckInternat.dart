import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:io';

checkInternet ()async{
  // No DNS lookup in the browser; the requests themselves report failures
  if (kIsWeb) return true;
  try{
     var result =await InternetAddress.lookup("google.com");
     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
       return true;
     } 
  }on SocketException catch(_){
    return false;
  }
}