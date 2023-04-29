import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

import 'ContactListPage.dart';

class ContactDetailsPage extends StatefulWidget{
  final Contact _contact;
  Function(Contact)? onContactDeviceSave;
  ContactDetailsPage(this._contact,this.onContactDeviceSave);

  @override
  State<StatefulWidget> createState()=>ContactDetailsPageState();

}

class ContactDetailsPageState extends State<ContactDetailsPage> {

  _openExistingContactOnDevice(BuildContext context)async{
    try{
      var contact=await ContactsService.openExistingContact(widget._contact,iOSLocalizedLabels: true);
      if(widget.onContactDeviceSave!= null){
        widget.onContactDeviceSave!(contact);
      }
      Navigator.pop(context);
    }on FormOperationException catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._contact.displayName??""),
      actions: [IconButton(onPressed: (){
        ContactsService.deleteContact(widget._contact);
      }, icon: Icon(Icons.delete)),
      IconButton(onPressed: (){
        //Navigator.push(context, MaterialPageRoute(builder: (_)=>UpdateContactPage(contct:widget._contact)));
      }, icon: Icon(Icons.update)),
        IconButton(onPressed: (){
          _openExistingContactOnDevice(context);
        }, icon: Icon(Icons.edit))
      ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Name"),
            subtitle: Text(widget._contact.givenName??""),
          ),
          ListTile(
            title: Text("Middle Name"),
            subtitle: Text(widget._contact.middleName??""),
          ),
          ListTile(
            title: Text("Family Name"),
            subtitle: Text(widget._contact.familyName??""),
          ),
          ListTile(
            title: Text("Prefix"),
            subtitle: Text(widget._contact.prefix??""),
          ),
          ListTile(
            title: Text("Suffic"),
            subtitle: Text(widget._contact.suffix??""),
          ),
          ListTile(
            title: Text("Birthday"),
            subtitle: Text(widget._contact.birthday.toString()??""),
          ),
          ListTile(
            title: Text("Company"),
            subtitle: Text(widget._contact.company??""),
          ),
          AddressTile(widget._contact.postalAddresses!),
          ItemTile("Phones",widget._contact.phones!),
          ItemTile("Emails",widget._contact.emails!),
        ],
      ),
    );
  }

  AddressTile(List<PostalAddress> postalAddresses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for(var a in postalAddresses)
          Padding(padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              ListTile(
                title: Text("Street"),
                subtitle: Text(a.street??""),
              ),
              ListTile(
                title: Text("Postcode"),
                subtitle: Text(a.postcode??""),
              ),
              ListTile(
                title: Text("City"),
                subtitle: Text(a.city??""),
              ),
              ListTile(
                title: Text("Region"),
                subtitle: Text(a.region??""),
              ),
              ListTile(
                title: Text("Country"),
                subtitle: Text(a.country??""),
              ),
            ],
          ),
          )
      ],
    );
  }

  ItemTile(String s, List<Item> phones) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(s),
        ),
        Column(
          children: [
            for(var i in phones)
              Padding(padding: EdgeInsets.symmetric(horizontal: 15),
              child: ListTile(
                title: Text(i.label??""),
                subtitle: Text(i.value??""),
              ),
                )
          ],
        )
      ],
    );
  }
}
class AddContactPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  Contact contact = Contact();
  PostalAddress address = PostalAddress(label: "Home");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a contact"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _formKey.currentState!.save();
              contact.postalAddresses = [address];
              ContactsService.addContact(contact);
              Navigator.of(context).pop();
            },
            child: Icon(Icons.save, color: Colors.white),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'First name'),
                onSaved: (v) => contact.givenName = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Middle name'),
                onSaved: (v) => contact.middleName = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last name'),
                onSaved: (v) => contact.familyName = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Prefix'),
                onSaved: (v) => contact.prefix = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Suffix'),
                onSaved: (v) => contact.suffix = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                onSaved: (v) =>
                contact.phones = [Item(label: "mobile", value: v)],
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                onSaved: (v) =>
                contact.emails = [Item(label: "work", value: v)],
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Company'),
                onSaved: (v) => contact.company = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Job'),
                onSaved: (v) => contact.jobTitle = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Street'),
                onSaved: (v) => address.street = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'City'),
                onSaved: (v) => address.city = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Region'),
                onSaved: (v) => address.region = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Postal code'),
                onSaved: (v) => address.postcode = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Country'),
                onSaved: (v) => address.country = v,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateContactsPage extends StatefulWidget {
  UpdateContactsPage({required this.contact});

  final Contact contact;

  @override
  _UpdateContactsPageState createState() => _UpdateContactsPageState();
}

class _UpdateContactsPageState extends State<UpdateContactsPage> {
  Contact? contact;
  PostalAddress address = PostalAddress(label: "Home");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Contact"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () async {
              _formKey.currentState!.save();
              contact!.postalAddresses = [address];
              await ContactsService.updateContact(contact!);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ContactListPage()));
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: contact!.givenName ?? "",
                decoration: const InputDecoration(labelText: 'First name'),
                onSaved: (v) => contact!.givenName = v,
              ),
              TextFormField(
                initialValue: contact!.middleName ?? "",
                decoration: const InputDecoration(labelText: 'Middle name'),
                onSaved: (v) => contact!.middleName = v,
              ),
              TextFormField(
                initialValue: contact!.familyName ?? "",
                decoration: const InputDecoration(labelText: 'Last name'),
                onSaved: (v) => contact!.familyName = v,
              ),
              TextFormField(
                initialValue: contact!.prefix ?? "",
                decoration: const InputDecoration(labelText: 'Prefix'),
                onSaved: (v) => contact!.prefix = v,
              ),
              TextFormField(
                initialValue: contact!.suffix ?? "",
                decoration: const InputDecoration(labelText: 'Suffix'),
                onSaved: (v) => contact!.suffix = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                onSaved: (v) =>
                contact!.phones = [Item(label: "mobile", value: v)],
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                onSaved: (v) =>
                contact!.emails = [Item(label: "work", value: v)],
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                initialValue: contact!.company ?? "",
                decoration: const InputDecoration(labelText: 'Company'),
                onSaved: (v) => contact!.company = v,
              ),
              TextFormField(
                initialValue: contact!.jobTitle ?? "",
                decoration: const InputDecoration(labelText: 'Job'),
                onSaved: (v) => contact!.jobTitle = v,
              ),
              TextFormField(
                initialValue: address.street ?? "",
                decoration: const InputDecoration(labelText: 'Street'),
                onSaved: (v) => address.street = v,
              ),
              TextFormField(
                initialValue: address.city ?? "",
                decoration: const InputDecoration(labelText: 'City'),
                onSaved: (v) => address.city = v,
              ),
              TextFormField(
                initialValue: address.region ?? "",
                decoration: const InputDecoration(labelText: 'Region'),
                onSaved: (v) => address.region = v,
              ),
              TextFormField(
                initialValue: address.postcode ?? "",
                decoration: const InputDecoration(labelText: 'Postal code'),
                onSaved: (v) => address.postcode = v,
              ),
              TextFormField(
                initialValue: address.country ?? "",
                decoration: const InputDecoration(labelText: 'Country'),
                onSaved: (v) => address.country = v,
              ),
            ],
          ),
        ),
      ),
    );
  }
}