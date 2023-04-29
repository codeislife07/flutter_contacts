

import 'package:flutter/material.dart';
import 'package:flutter_contacts/ContactListPage.dart';
import 'package:flutter_contacts/ContactPickerPage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ContactDetailsPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      routes: <String,WidgetBuilder>{
        "/add":(BuildContext context)=>AddContactPage(),
        "/contactsList":(BuildContext context)=>ContactListPage(),
        "/nativeContactPicker":(BuildContext context)=>ContactPickerPage(),
      },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _askPermission(null);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(onPressed: (){
              _askPermission("/contactsList");
            }, child: Text("Contact List")),
            ElevatedButton(onPressed: (){
              _askPermission("/nativeContactPicker");
            }, child: Text("Native Contact picker")),
          ],
        ),
      ),
       );
  }

  void _askPermission(String? routeName) async{
    PermissionStatus permissionStatus=await _getCotactPermission();
    if(permissionStatus==PermissionStatus.granted){
      if(routeName!=null){
        Navigator.pushNamed(context, routeName);
      }else{
        _handleInvalidePermissio(permissionStatus);
      }
    }
  }

  Future<PermissionStatus> _getCotactPermission() async{
    PermissionStatus permissionStatus =await Permission.contacts.status;
    if(permissionStatus !=PermissionStatus.granted &&
      permissionStatus !=PermissionStatus.permanentlyDenied) {
      PermissionStatus permission=await Permission.contacts.request();
     return permission;
    }else{
      return permissionStatus;
    }
  }

  void _handleInvalidePermissio(PermissionStatus permissionStatus)async {
    if(permissionStatus ==PermissionStatus.denied){
      final snackbar=SnackBar(content: Text("Access to contact datat denied"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }else if(permissionStatus ==PermissionStatus.permanentlyDenied){
      final snackbar=SnackBar(content: Text("Contact data not available on device"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
