import 'package:contact_app/provider/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EditScreen extends StatefulWidget {
  final Contact contact;
  final Function onEditCallback;
  const EditScreen({required this.contact, required this.onEditCallback});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameCont.text = widget.contact.name;
    phoneCont.text = widget.contact.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        title: const Text(
          'Edit Contact',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.contact.name = nameCont.text;
              widget.contact.phoneNumber = phoneCont.text;
              Provider.of<ContactProvider>(context, listen: false)
                  .updateContact(widget.contact);
              widget.onEditCallback();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check),
            color: Colors.black,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 315,
              color: Colors.grey.shade100,
              width: double.infinity,
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue,
                      child: Text(
                        widget.contact.name.isNotEmpty
                            ? widget.contact.name[0].toUpperCase()
                            : '',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameCont,
                    decoration: InputDecoration(
                      hintText: 'Enter Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  IntlPhoneField(
                    controller: phoneCont,
                    decoration: InputDecoration(
                      hintText: 'Enter Phone Number',
                      labelText: '+92 - - -  - - - - - - -',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    initialCountryCode: 'PK',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
