import 'dart:convert';

import 'package:freehit/Database/SecurityStorageServices.dart';
import 'package:freehit/Utils/Uri.dart';
import 'package:http/http.dart'as http;

class Userservice {
  static final Userservice instance=Userservice._init();
  Userservice._init();
  SecurityStorageServices secureDB=SecurityStorageServices.instance;
  Future<String?> updateUserName(String username)async{
    final url=Uri.parse("${BASE_URI}user/updateUserName");
    String? currentUserEmail=await secureDB.getCurrentUserEmail();
    String? token=await secureDB.getToken(currentUserEmail!);
    try{
      if(username.isNotEmpty && token!.isNotEmpty){
        final response=await http.post(
          url,
          headers: {
            "content-type":"application/json",
            "Authorization":token
          },
          body: jsonEncode({"name":username})
        );
        if(response.statusCode==200){
          return "Success";
        }else{
          return "Failed";
        }
      }
    }catch(e){
      return "Server error";
    }
    return null;

  }
  Future<String?> updateFullName(String username)async{
    final url=Uri.parse("${BASE_URI}user/updateFullName");
    String? currentUserEmail=await secureDB.getCurrentUserEmail();
    String? token=await secureDB.getToken(currentUserEmail!);
    try{
      if(username.isNotEmpty && token!.isNotEmpty){
        final response=await http.post(
          url,
          headers: {
            "content-type":"application/json",
            "Authorization":token
          },
          body: jsonEncode({"name":username})
        );
        if(response.statusCode==200){
          final data=jsonDecode(response.body);
          return data['message'];
        }else{
          return "Failed";
        }
      }
    }catch(e){
      return "Server error";
    }
    return null;

  }
}