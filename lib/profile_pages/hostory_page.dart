import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavod_test/profile_pages/account.dart';
import 'package:zavod_test/profile_pages/chat.dart';
import 'package:zavod_test/tools/location.dart';
import 'package:zavod_test/tools/sizes.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    return Consumer<LocationProvider>(
      builder: (context, location, child) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Location History',
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
            body: location.allLocations != null?
            ListView.builder(
              itemCount: location.allLocations!.length,
                itemBuilder: (context, index){
                return ListTile(
                  title: Text(
                   location.allLocations[index]['address'],
                  ),
                  subtitle: Text(
                    'This location is ${location.allLocations[index]['distance']} far and it '
                        'would take approximately ${location.allLocations[index]['duration']} to get here',
                    style: TextStyle(
                      color: Colors.grey
                    ),
                  ),
                  leading: Icon(Icons.my_location_sharp),
                );
                }
            ):Center(
              child: Text('No Location Has Been Selected'),
            )
        );
      }
    );
  }
}
