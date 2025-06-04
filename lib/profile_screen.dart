import 'package:flutter/material.dart';
import 'package:zavod_test/profile_pages/account.dart';
import 'package:zavod_test/profile_pages/chat.dart';
import 'package:zavod_test/profile_pages/hostory_page.dart';
import 'package:zavod_test/tools/sizes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile',
              style:TextStyle(
            fontWeight: FontWeight.bold,
          )),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.9.pH),
            child: Divider(
              color: Colors.grey,
            ),
          ),
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              'Account',
              style: th.textTheme.bodySmall,
            ),
            leading: Icon(Icons.person_3_rounded),
            trailing: Icon(Icons.arrow_forward_ios, size: 5.pW),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Account();
              }));
            },
          ),
          ListTile(
            title: Text(
              'Chat',
              style: th.textTheme.bodySmall,
            ),
            leading: Icon(Icons.chat),
            trailing: Icon(Icons.arrow_forward_ios, size: 5.pW),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Chat();
              }));
            },
          ),
          ListTile(
            title: Text(
              'History',
              style: th.textTheme.bodySmall,
            ),
            leading: Icon(Icons.my_location_rounded),
            trailing: Icon(Icons.arrow_forward_ios, size: 5.pW),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return HistoryPage();
              }));
            },
          ),
        ],
      )
    );
  }
}
