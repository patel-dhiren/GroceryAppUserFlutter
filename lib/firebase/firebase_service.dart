import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_user/model/order_data.dart';

import '../model/address.dart';
import '../model/cart.dart';
import '../model/category.dart';
import '../model/item.dart';
import '../model/order.dart';
import '../model/user_data.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final Map<String, ValueNotifier<bool>> _favorites = {};

  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  String? _verificationId;

  Future<void> verifyPhoneNumber(
      String phoneNumber, Function onCodeSent, Function onError) async {
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

  Future<void> signInWithPhoneNumber(
      String smsCode, Function onSuccess, Function onSignInFailed) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: smsCode);
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
    return _database
        .ref()
        .child('items')
        .orderByChild('inTop')
        .equalTo(true)
        .onValue
        .map((event) {
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

  Stream<List<Item>> itemsListStream(String categoryId) {
    return _database
        .ref()
        .child('items')
        .orderByChild('categoryId')
        .equalTo(categoryId)
        .onValue
        .map((event) {
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
    try {
      await _database.ref('users').child(user.id).set(user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkIfUserExists(String userId) async {
    try {
      final snapshot = await _database.ref().child('users/$userId').get();
      if (snapshot.exists) {
        print('User exists.');
        return true;
      } else {
        print('User does not exist.');
        return false;
      }
    } catch (e) {
      throw Exception('Failed to check if user exists');
    }
  }

  Future<List<Item>> searchItemByName(String query) async {
    final allItems = await fetchItems();
    return allItems
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Item>> fetchItems() async {
    List<Item> items = [];
    try {
      final snapshot = await _database.ref().child('items').get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> productsMap =
            snapshot.value as Map<dynamic, dynamic>;
        productsMap.forEach((key, value) {
          final item = Item.fromJson(value);
          items.add(item);
        });
      }
    } catch (e) {
      return items;
    }
    return items;
  }

  void toggleFavorite(String productId) {
    if (_auth.currentUser != null) {
      final ref = _database
          .ref('userFavorites')
          .child(_auth.currentUser!.uid)
          .child(productId);
      ref.get().then((snapshot) async {
        final isFavoriteNow = !snapshot.exists;
        if (isFavoriteNow) {
          await ref.set(true);
        } else {
          await ref.remove();
        }

        // Update the local ValueNotifier for this product's favorite status
        _favorites[productId]?.value = isFavoriteNow;
      });
    }
  }

  Future<bool> getFavorite(String productId) async {
    if (_auth.currentUser != null) {
      final snapshot = await _database
          .ref('userFavorites')
          .child(_auth.currentUser!.uid)
          .child(productId)
          .get();
      if (snapshot.exists) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  ValueNotifier<bool> getFavoriteNotifier(String productId) {
    // If the notifier doesn't exist, create it with a default value of false
    _favorites.putIfAbsent(productId, () => ValueNotifier<bool>(false));
    return _favorites[productId]!;
  }

  void updateFavorites(bool isFavorite, String productId) {
    _favorites[productId]?.value = isFavorite;
  }

  Future<List<String>> fetchUserFavoriteItemIds(String userId) async {
    final snapshot = await _database.ref().child('userFavorites/$userId').get();
    if (snapshot.exists && snapshot.value != null) {
      Map<dynamic, dynamic> favorites =
          Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
      return favorites.keys.cast<String>().toList();
    } else {
      return [];
    }
  }

  Future<Map<dynamic, dynamic>> fetchItemDetails(String itemId) async {
    final snapshot = await _database.ref().child('items/$itemId').get();
    if (snapshot.exists && snapshot.value != null) {
      return Map<dynamic, dynamic>.from(
          snapshot.value as Map<dynamic, dynamic>);
    } else {
      return {};
    }
  }

  Future<List<Map<dynamic, dynamic>>> fetchUserFavoriteItems() async {
    var userId = _auth.currentUser!.uid;

    List<Map<dynamic, dynamic>> favoriteItemsDetails = [];
    List<String> favoriteItemIds = await fetchUserFavoriteItemIds(userId);

    for (String itemId in favoriteItemIds) {
      Map<dynamic, dynamic> itemDetails = await fetchItemDetails(itemId);
      if (itemDetails.isNotEmpty) {
        favoriteItemsDetails.add(itemDetails);
      }
    }

    return favoriteItemsDetails;
  }

  Future<void> addToCart(Item item, int quantity) async {
    var userId = _auth.currentUser!.uid;

    DatabaseReference cartRef =
        _database.ref().child('userCarts/$userId/items/${item.id}');

    final snapshot = await cartRef.get();
    if (snapshot.exists) {
      // Item exists, update quantity
      int currentQuantity =
          (snapshot.value as Map<dynamic, dynamic>)['quantity'];
      cartRef.update({
        'quantity': quantity,
        'totalPrice': (item.price * quantity).toDouble(),
      });
    } else {
      // New item, add to cart
      cartRef.set({
        'id': item.id,
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'unit': item.unit,
        'imageUrl': item.imageUrl,
        'quantity': quantity,
        'totalPrice': (item.price * quantity).toDouble(),
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  Stream<List<Cart>> getCartItems() {
    var userId = FirebaseAuth.instance.currentUser!.uid;


    Stream<DatabaseEvent> stream =
        _database.ref().child('userCarts').child(userId).child('items').onValue;

    return stream.map((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        // Convert the data snapshot to a map and then to a List<Cart>
        Map<dynamic, dynamic> cartMap = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
        List<Cart> cartItems = cartMap.values
            .map((item) => Cart.fromJson(Map<dynamic, dynamic>.from(item)))
            .toList();
        return cartItems;
      } else {
        return <Cart>[]; // Return an empty list if there's no data
      }
    });
  }

  Future<UserData?> getUserData() async {
    try {
      var userId = _auth.currentUser!.uid;

      DataSnapshot snapshot = await _database.ref("users").child(userId).get();
      if (snapshot.value != null) {
        return UserData.fromJson(snapshot.value);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> updateCartItem(Cart cartItem) async {
    try {
      var userId = _auth.currentUser!.uid;

      await _database.ref().child('userCarts').child(userId).child('items').child(cartItem.id).update(cartItem.toJson());
      print('Cart item updated successfully');
    } catch (e) {
      print('Error updating cart item: $e');
    }
  }

  Future<void> updateUserData(UserData userData) async {
    try {
      await _database.ref("users").child(userData.id).update({
        'name': userData.name,
        'email': userData.email,
        // You can add more fields to update here if needed
      });
    } catch (e) {
      print('Error updating user data: $e');
      throw e;
    }
  }

  Future<void> removeCartItem( String cartItemId) async {
    try {

      var userId = _auth.currentUser!.uid;

      await _database.ref()
          .child('userCarts')
          .child(userId)
          .child('items')
          .child(cartItemId)
          .remove();
      print('Cart item removed successfully');
    } catch (e) {
      print('Error removing cart item: $e');
    }
  }

  Future<List<Cart>> getCartItemOnce() async {
    List<Cart> cartItems = [];
    try {

      var userId = _auth.currentUser!.uid;

      DatabaseReference ref = _database.ref('userCarts/$userId/items');
      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> items = snapshot.value as Map<dynamic, dynamic>;
        items.forEach((key, value) {
          Cart cartItem = Cart(
            id: value['id'],
            name: value['name'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            price: double.parse(value['price'].toString()),
            quantity: int.parse(value['quantity'].toString()),
            totalPrice: double.parse(value['totalPrice'].toString()),
            unit: value['unit'], createdAt: value['createdAt'],
          );
          cartItems.add(cartItem);
        });
      }
    } catch (e) {
      print("An error occurred while fetching cart items: ${e.toString()}");
      // Optionally, handle the error in a way that's appropriate for your app
    }
    return cartItems;
  }

  Stream<List<Address>> getAddressStream() {

    var userId = _auth.currentUser!.uid;

    Stream<DatabaseEvent> stream =
        _database.ref().child('userAddresses').child(userId).onValue;

    return stream.map((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        // Convert the data snapshot to a map and then to a List<Cart>
        Map<dynamic, dynamic> addressMap = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
        List<Address> addressItems = addressMap.values
            .map((item) => Address.fromJson(Map<dynamic, dynamic>.from(item)))
            .toList();
        return addressItems;
      } else {
        return <Address>[]; // Return an empty list if there's no data
      }
    });
  }

  Future<void> addAddress(Address address) async {
    var userId = _auth.currentUser!.uid;
    var id = _database.ref('userAddresses/$userId').push().key;
    address.id = id.toString();
    //DatabaseReference addressRef = _database.ref('userAddresses/$userId').push();
    // Set the address data
    await _database.ref('userAddresses/$userId').child(address.id).set(address.toJson());
  }

  Future<void> placeOrder(Order order) async {
    
    String? id = _database.ref().child('orders').push().key;
    order.orderId = id;
    if(id!=null){
      await _database.ref().child('orders').child(id).set(order.toJson());
      await _database.ref().child('userCarts').child(order.userId!).remove();
    }
    
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }

  Stream<List<Order>> get orderStream {

    var userId = _auth.currentUser!.uid;

    return _database
        .ref()
        .child('orders')
        .orderByChild('userId')
        .equalTo(userId)
        .onValue
        .map((event) {
      dynamic ordersMap = event.snapshot.value ?? {};
      List<Order> orders = [];
      ordersMap.forEach((key, value) {
        orders.add(Order.fromJson(Map<String, dynamic>.from(value)));
      });
      return orders;
    });
  }

}
