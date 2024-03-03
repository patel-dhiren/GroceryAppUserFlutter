import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/category.dart';
import '../model/item.dart';
import '../model/user_data.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  String? _verificationId;

  Future<void> verifyPhoneNumber(String phoneNumber, Function onCodeSent, Function onError) async {

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      onError("Failed to verify phone number: $e");
    }
  }

  Future<void> signInWithPhoneNumber(String smsCode, Function onSuccess, Function onSignInFailed) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: smsCode);
      var user = await _auth.signInWithCredential(credential);
      onSuccess(user);
    } catch (e) {
      onSignInFailed("Failed to sign in: $e");
    }
  }


  Stream<List<Category>> get categoryStream {
    return _database.ref().child('categories').onValue.map((event) {
      List<Category> categories = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> categoriesMap =
        event.snapshot.value as Map<dynamic, dynamic>;
        categoriesMap.forEach((key, value) {
          final category = Category.fromJson(value);
          categories.add(category);
        });
      }
      return categories;
    });
  }

  Stream<List<Item>> get itemsStream {
    return _database.ref().child('items').orderByChild('inTop').equalTo(true).onValue.map((event) {
      List<Item> items = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> itemsMap =
        event.snapshot.value as Map<dynamic, dynamic>;
        itemsMap.forEach((key, value) {
          final item = Item.fromJson(value);
          items.add(item);
        });
      }
      return items;
    });
  }

  Stream<List<Item>>  itemsListStream(String categoryId) {
    return _database.ref().child('items').orderByChild('categoryId').equalTo(categoryId).onValue.map((event) {
      List<Item> items = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> itemsMap =
        event.snapshot.value as Map<dynamic, dynamic>;
        itemsMap.forEach((key, value) {
          final item = Item.fromJson(value);
          items.add(item);
        });
      }
      return items;
    });
  }

  Future<bool> createUser(UserData user) async {
    try{
      await _database.ref('users').child(user.id).set(user.toJson());
      return true;
    }catch(e){
      return false;
    }
  }


}
