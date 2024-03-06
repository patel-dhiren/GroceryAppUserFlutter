import 'package:flutter/material.dart';
import 'package:grocery_app_user/constants/constants.dart';
import 'package:grocery_app_user/firebase/firebase_service.dart';
import 'package:grocery_app_user/gen/assets.gen.dart';
 // Import your DatabaseService class

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
 // Initialize DatabaseService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile Account'),
      ),
      body: FutureBuilder(
        future: FirebaseService().getUserData(), // Replace 'your_user_id' with the actual user ID
        builder: (context,  snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Text('Error fetching user data');
          } else {
            var userData = snapshot.data;
            return ListView(
              children: [
                ListTile(
                  isThreeLine: true,
                  contentPadding: EdgeInsets.all(16),
                  tileColor: Colors.white,
                  leading: Container(
                    height: 100,
                    color: Colors.white,
                    child: Image.asset(
                      Assets.images.user.path,
                    ),
                  ),
                  title: Text(
                    userData!.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text('Contact : ${userData!.contact}'),
                  trailing: IconButton(
                    onPressed: () async {
                      bool? status = await Navigator.pushNamed(context, AppConstant.profileUpdateView, arguments: userData) as bool;
                      if(status!=null && status){
                        setState(() {
                        });
                      }
                    },
                    icon: Icon(Icons.edit),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        leading: Icon(Icons.shopping_bag_outlined),
                        title: Text(
                          'My Cart',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        trailing: Icon(Icons.navigate_next),
                      ),
                      ListTile(
                        leading: Icon(Icons.note_alt_outlined),
                        title: Text(
                          'Orders',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        trailing: Icon(Icons.navigate_next),
                      ),
                      ListTile(
                        leading: Icon(Icons.logout_rounded),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        trailing: Icon(Icons.navigate_next),
                      )
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
