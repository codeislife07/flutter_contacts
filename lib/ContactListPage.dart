import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_ContactListPageState();

}

class _ContactListPageState extends State<ContactListPage> {

  List<Contact> contact=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshContacts();
  }

  void refreshContacts()async {
    var contacts=await ContactsService.getContacts(
      withThumbnails: false,iOSLocalizedLabels: true,);
      contact.addAll(contacts);
      for(final i in contact){
        ContactsService.getAvatar(i).then((value){
          if(value==null){
            return;
          }else{
            i.avatar=value;
          }
        });
        setState(() {

        });
      }

  }
  void updateContact()async{
    Contact con=contact.firstWhere((element) => element.familyName!.startsWith("coding"));
    con.avatar=null;
    await ContactsService.updateContact(con);
    refreshContacts();
  }

  void _openContactForm()async{
    try{

    }on FormOperationException
    catch(e){
      switch(e.errorCode){
        default:
          print(e.errorCode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts Plugin'),actions: [IconButton(onPressed: (){_openContactForm();}, icon: Icon(Icons.create))],),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, "/add").then((value){
          refreshContacts();
        });
      },child: Icon(Icons.add),),
      body: SafeArea(
        child: contact!=null
            ?ListView.builder(
          itemCount: contact.length??0, itemBuilder: (BuildContext context, int index) {
            Contact c=contact.elementAt(index);
            return ListTile(
              onTap: (){},
              leading: (c.avatar!=null && c.avatar!.length>0)
                      ?CircleAvatar(backgroundImage: MemoryImage(c.avatar!),)
                      :CircleAvatar(child: Text(c.initials()),),
              title: Text(c.displayName??""),
            );
        },

        )
            :Container(child: Center(child: CircularProgressIndicator(),),),
      ),
    );
  }

  void contactOnDeviceHasBeenUpdated(Contact contactd){
    setState(() {
      // var id=context.ind
    });
  }

}


