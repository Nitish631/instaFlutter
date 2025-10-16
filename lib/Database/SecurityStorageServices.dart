import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityStorageServices{
  static final SecurityStorageServices instance=SecurityStorageServices._init();
  SecurityStorageServices._init();
  Future<bool> anycurrentUser()async{
    String? currentemail=await getCurrentUserEmail();
    if(currentemail!.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }
  final _storage=const FlutterSecureStorage();
  Future<void> saveSensitiveData(String email,String password,String jwt)async{
    await _storage.write(key: 'pass_$email', value: password);
    await _storage.write(key: 'token_$email', value: jwt);
  }
  Future<String?> getPassword(String email)async{
    return await _storage.read(key: 'pass_$email');
  }
  Future<String?> getToken(String email)async{
    return await _storage.read(key: 'token_$email');
  }

  Future<String?> getCurrentUserEmail()async{
    return await _storage.read(key: 'current_user');
  }
  Future<void> updateCurrentUserEmail(String email)async{
    await _storage.write(key: 'current_user', value: email);
  }
  Future<void>deleteCurrentUser()async{
    await _storage.delete(key: 'current_user');
  }
  Future<void>deleteAccount(String email)async{
    await _storage.delete(key: 'pass_$email');
    await _storage.delete(key: "token_$email");
  }
  Future<void>deleteAllAccounts()async{
    await _storage.deleteAll();
  }
}