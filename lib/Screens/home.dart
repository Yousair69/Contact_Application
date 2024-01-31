import 'package:contact_app/Screens/formscreen.dart';
import 'package:contact_app/Screens/detail_screen.dart';
import 'package:contact_app/provider/contact_provider.dart';
import 'package:contact_app/services/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();

  void updateContactafterDeletion(BuildContext context) {
    Provider.of<ContactProvider>(context, listen: false).loadContacts();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final ContactServices contactServices = ContactServices();
  late ContactProvider contactProvider;
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
    contactProvider.loadContacts();
  }

  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        title: isSearching
            ? TextField(
                controller: searchController,
                onChanged: (String? value) {
                  setState(() {
                    searchText = value.toString();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search Contacts',
                ),
              )
            : const Text(
                'Contacts',
                style: TextStyle(color: Colors.black),
              ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) {
                    searchController.clear();
                  }
                });
              },
              icon: Icon(
                isSearching ? Icons.cancel_outlined : Icons.search,
                color: Colors.black,
              )),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'Sort by',
                child: Row(
                  children: [
                    Text('Sort by'),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  contactProvider.deleteAllContacts();
                },
                child: const Text('Delete all'),
              ),
            ],
            onSelected: (value) {
              if (value == 'Sort by') {
                showNestedPopupMenu(context);
              }
            },
          ),
        ],
      ),
      body: Consumer<ContactProvider>(
        builder: (context, value, child) {
          if (contactProvider.contacts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/Group 2.png'),
                  const SizedBox(height: 10),
                  const Text(
                    'You have no contacts yet',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            );
          } else {
            final filteredContacts = contactProvider.contacts
                .where((contact) =>
                    contact.name
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()) ||
                    contact.phoneNumber.contains(searchController.text))
                .toList();
            return ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailScreen(
                                  onUpdateCallback: () {
                                    contactProvider.loadContacts();
                                    Navigator.pop(context);
                                  },
                                  onDeleteCallback: () {
                                    setState(() {
                                      contacts.remove(contact);
                                      widget
                                          .updateContactafterDeletion(context);
                                    });
                                  },
                                  contact: contact,
                                )));
                  },
                  leading: CircleAvatar(
                    child: Text(
                      contact.name.isNotEmpty
                          ? contact.name[0].toUpperCase()
                          : '',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(contact.name),
                  subtitle: Text(contact.phoneNumber),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.green,
                      )),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ContactFormScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showNestedPopupMenu(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    double rightEdge = offset.dx + renderBox.size.width;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        rightEdge,
        offset.dy, // Adjust the vertical offset as needed
        rightEdge + 200, // Adjust the width of the nested menu as needed
        offset.dy + renderBox.size.height,
      ),
      items: [
        PopupMenuItem(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(Icons.arrow_left),
                SizedBox(width: 02),
                Text('Sort by')
              ],
            )),
        PopupMenuItem(
          onTap: () {
            contactProvider.sortContacts(true);
          },
          child: const Text(' A-Z '),
        ),
        PopupMenuItem(
          onTap: () {
            contactProvider.sortContacts(false);
          },
          child: const Text(' Z-A '),
        )
      ],
    ).then((value) {
      if (value != null) {}
    });
  }
}
