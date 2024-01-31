import 'package:contact_app/Screens/editscreen.dart';
import 'package:contact_app/provider/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  final Contact contact;
  final Function onDeleteCallback;
  final Function onUpdateCallback;
  DetailScreen(
      {super.key,
      required this.contact,
      required this.onDeleteCallback,
      required this.onUpdateCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        title: const Text(
          'Contact Detail',
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
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditScreen(
                              contact: contact,
                              onEditCallback: () {
                                onUpdateCallback();
                              })));
                },
                child: const Text('Edit'),
              ),
              PopupMenuItem(
                onTap: () {
                  print("Before Deletion: $contact.id ");
                  Provider.of<ContactProvider>(context, listen: false)
                      .deleteContact(contact.name);
                  print("After Deletion");

                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
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
              height: 250,
              color: Colors.grey.shade100,
              width: double.infinity,
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue,
                      child: Text(
                        contact.name.isNotEmpty
                            ? contact.name[0].toUpperCase()
                            : '',
                        style:
                            const TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    contact.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(' ${contact.phoneNumber}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Container(
                        decoration: const BoxDecoration(
                            color: Color(0xffE9AD13), shape: BoxShape.circle),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.message,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.call_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  ' Call History',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                )),
          ],
        ),
      ),
    );
  }
}
