import 'package:flutter/material.dart';
import 'package:grocery_app_user/firebase/firebase_service.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/cart.dart';

class CartView extends StatefulWidget {

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(
          'CHECK OUT',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.shopping_basket_sharp,
          color: Colors.white,
        ),
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Cart>>(
          future: FirebaseService().getCartItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return _buildEmptyCart();
            } else {
              return _buildCartList(snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(15),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.5,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 16,
                          width: MediaQuery.of(context).size.width * 0.3,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 20,
                                width: 40,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 20),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 20,
                                width: 40,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: 5,
    );
  }

  Widget _buildCartList(List<Cart> cartItems) {
    return ListView.builder(
      padding: EdgeInsets.all(15),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final Cart cartItem = cartItems[index];
        return Card(
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Image.network(
                  cartItem.imageUrl,
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        "${cartItems[index].price} /${cartItems[index].unit}",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(),
                            ),
                            child: Icon(Icons.remove),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Center(
                            child: Text(
                              "${cartItem.quantity}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.green,
                            ),
                          ),
                          Expanded(child: Container()),
                          Text("Rs. ${cartItem.totalPrice.toStringAsFixed(2)}", style: TextStyle(fontSize: 16),)
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Text('Your cart is empty.'),
    );
  }
}
