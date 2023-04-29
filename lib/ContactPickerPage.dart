import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactPickerPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>ContactPickerPageState();

}

class ContactPickerPageState extends State<ContactPickerPage> {
  Contact? contact;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text("Contact Picker"),),
     body: Column(
       children: [
         SizedBox(height: 200,),
         ElevatedButton(onPressed: (){
           _pickContact();
         }, child: Text("Pick a Contact")),
         SizedBox(height: 200,),
         contact==null?Container():Text("Contact selets : ${contact!.displayName}")
       ],
     ),
   );
  }

  void _pickContact() async{
    try{
      Contact? contacst=await ContactsService.openDeviceContactPicker(iOSLocalizedLabels: true);
      if(contacst!=null)
        setState(() {
          contact=contacst;
        });

    }catch(E){
      print(E.toString());
    }
  }
}