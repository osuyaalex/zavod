import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zavod_test/home_page.dart';
import 'package:zavod_test/tools/sizes.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Account Page',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 6.pW
            ),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0,vertical: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    hintText: 'First name',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 18
                    )
                ),
                onChanged: (v){
                  _firstName = v;
                  setState(() {});
                },
              ),
              3.gap,
              TextFormField(
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    hintText: 'Last name',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 18
                    )
                ),
                onChanged: (v){
                  _lastName = v;
                  setState(() {});
                },
              ),
              3.gap,
              TextFormField(
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 18
                    )
                ),
                onChanged: (v){
                  _email = v;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: SizedBox(
              height: 6.pH,
              width: 100.pW,
              child: ElevatedButton(
                style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                ),
                onPressed:()async{
                  if(_firstName.isNotEmpty && _lastName.isNotEmpty){
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    await pref.setString('firstName', _firstName);
                    await pref.setString('lastName', _lastName);
                    await pref.setString('email', _email);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                      return HomePage();
                    }));
                  }
                },
                child: Text('Continue',
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              ),
            ),
          ),
          1.gap,
        ],
      ),
    );
  }
}
