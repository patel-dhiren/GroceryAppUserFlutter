import 'package:flutter/material.dart';
import 'package:grocery_app_user/constants/constants.dart';
import 'package:grocery_app_user/firebase/firebase_service.dart';
import 'package:grocery_app_user/model/category.dart';
import 'package:grocery_app_user/model/item.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  SizedBox(height: 12),
                  Text(
                    'Top Categories',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  _buildHorizontalListView(),
                  SizedBox(height: 10),
                  Text(
                    'Top Selling',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  _buildTopProductsGridView()
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildSearchBar() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppConstant.searchView);
      },
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(5.0),
        child: TextField(
          showCursor: false,
          enabled: false,
          decoration: InputDecoration(
              hintText: "Search for products",

              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
        ),
      ),
    );
  }

  Widget _buildHorizontalListView() {
    return Container(
      height: 110,
      child: StreamBuilder<List<Category>>(
        stream: FirebaseService().categoryStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6, // Number of shimmer items
                itemBuilder: (context, index) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.all(5),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            var categories = snapshot.data ?? [];

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppConstant.itemListView, arguments: categories[index]);
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          child: Image.network(
                            categories[index].imageUrl,
                            width: 50,
                            height: 50,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildTopProductsGridView() {

    return StreamBuilder<List<Item>>(
      stream: FirebaseService().itemsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridView.builder(
            itemCount: 6,
            // Adjust based on your placeholder count
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
    );
  }
}
