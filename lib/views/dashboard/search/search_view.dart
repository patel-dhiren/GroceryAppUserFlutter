import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/constants.dart';
import '../../../firebase/firebase_service.dart';
import '../../../model/item.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  final TextEditingController _searchController = TextEditingController();
  List<Item> _searchResults = [];

  void _searchProducts(String query) async {
    if (query.isNotEmpty) {
      final results = await FirebaseService().searchItemByName(query);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  itemCount: _searchResults.length,
                  shrinkWrap: true,
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
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppConstant.itemView, arguments: _searchResults[index]);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.network(
                                        _searchResults[index].imageUrl,
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                    Text(

                                      _searchResults[index].name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${_searchResults[index].price} /${_searchResults[index].unit}',
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
                                            'Rs. ${_searchResults[index].price}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(5.0),
      child: TextField(
        controller: _searchController,
        onChanged: _searchProducts,
        decoration: InputDecoration(
            hintText: "Type here..",
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
      ),
    );
  }



}
