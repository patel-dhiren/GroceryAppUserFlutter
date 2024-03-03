import 'package:flutter/material.dart';
import 'package:grocery_app_user/model/category.dart';
import 'package:shimmer/shimmer.dart';

import '../../firebase/firebase_service.dart';
import '../../model/item.dart';

class ItemListView extends StatefulWidget {
  Category category;

  ItemListView({required this.category});

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: StreamBuilder<List<Item>>(
          stream: FirebaseService().itemsListStream(widget.category.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GridView.builder(
                itemCount: 10,
                // Adjust based on your placeholder count
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    mainAxisExtent: 210,
                    // Adjust size accordingly
                    crossAxisSpacing: 8,
                    childAspectRatio: 1 / 1.5),
                itemBuilder: (context, index) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 10,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: double.infinity,
                                height: 10,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: 60,
                                height: 10,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              var itemList = snapshot.data ?? [];

              return GridView.builder(
                itemCount: itemList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    mainAxisExtent: 210,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1 / 1.5),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.grey.shade300, width: 1)),
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: GridTile(
                        child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.network(
                                    itemList[index].imageUrl,
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                Text(
                                  itemList[index].name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${itemList[index].price} /${itemList[index].unit}',
                                  style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Rs. ${itemList[index].price}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.favorite_border,
                                      color: Colors.grey,
                                    )
                                  ],
                                )
                              ],
                            )),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      )
    );
  }
}
