import 'dart:convert';
import 'package:freehit/Database/SecurityStorageServices.dart';
import 'package:freehit/Utils/Uri.dart';
import 'package:freehit/Secret/secret.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleSignInService {
  static GoogleSignInService instance=GoogleSignInService._init();
  GoogleSignInService._init();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:Secret().GOOGLE_CLIENT_ID,
    scopes: ['email', 'profile'],
  );

  Future<Map<String,dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        return {"message":"No account choosed."};
      }
      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;
      final String email = account.email;
      final response = await http.post(
        Uri.parse('${BASE_URI}auth/google_auth'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': email,
          'password': idToken,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String ,dynamic> responseData=jsonDecode(response.body);
        final String JwtToken=responseData['token'];
        final String password=idToken!.substring(0,50);
        await SecurityStorageServices.instance.saveSensitiveData(email,password,JwtToken);
        await SecurityStorageServices.instance.updateCurrentUserEmail(email);
        return {"success":true};
      }else if(response.statusCode==400){
        final Map<String,dynamic> responseData=jsonDecode(response.body);
        final String message=responseData['message'];
        return {"message":message,"success":false};
      }
      return {"message":"Network error.","success":false};
    } catch (e) {
     return {"message":"Network error.","success":false};
    }
  }

  Future<void> signOut() async {
    SecurityStorageServices.instance.deleteCurrentUser();
    await _googleSignIn.signOut();
  }
}
