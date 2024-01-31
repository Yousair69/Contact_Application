import 'package:contact_app/provider/contact_provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ContactFormScreen extends StatefulWidget {
  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Contacts',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final contactProvider =
                    Provider.of<ContactProvider>(context, listen: false);
                Contact newContact =
                    Contact(name: nameCont.text, phoneNumber: phoneCont.text);
                contactProvider.addContact(newContact);
                Navigator.pop(context);
              }
            },
            icon: const Icon(
              Icons.check,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 25),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Name',
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
                const SizedBox(height: 05),
                TextFormField(
                  controller: nameCont,
                  decoration: InputDecoration(
                    hintText: 'Enter Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Phone Number',
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
                const SizedBox(height: 10),
                IntlPhoneField(
                  controller: phoneCont,
                  decoration: InputDecoration(
                    hintText: 'Enter Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  initialCountryCode: 'PK',
                  
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
