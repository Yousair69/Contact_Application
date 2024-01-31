import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contact {
  int? id;
  String name;
  String phoneNumber;
  late String firstLetter;

  Contact({this.id, required this.name, required this.phoneNumber}) {
    firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }
  @override
  String toString() {
    return 'Contact{id: $id, name: $name, phoneNumber: $phoneNumber}';
  }
}

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  late SharedPreferences _prefs;

  List<Contact> get contacts => _contacts;

  ContactProvider() {
    loadContacts();
  }

  Future<void> loadContacts() async {
    try {
      _contacts.sort(
        (a, b) => a.firstLetter.compareTo(b.firstLetter),
      );
      _prefs = await SharedPreferences.getInstance();
      String contactsString = _prefs.getString('contacts') ?? '[]';
      List<dynamic> contactsJson = jsonDecode(contactsString);
      _contacts = contactsJson
          .map((json) => Contact.fromJson(json))
          .cast<Contact>()
          .toList();
      notifyListeners();
    } catch (error) {}
  }

  void sortContacts(bool ascending) {
    _contacts.sort((a, b) {
      if (ascending) {
        return a.firstLetter.compareTo(b.firstLetter);
      } else {
        return b.firstLetter.compareTo(a.firstLetter);
      }
    });
    notifyListeners();
  }

  void _saveContactsToPrefs() {
    String contactsString = json.encode(_contacts);
    _prefs.setString('contacts', contactsString);
  }

  void addContact(Contact contact) {
    _contacts.add(contact);
    _saveContactsToPrefs();
    notifyListeners();
  }

  void deleteAllContacts() {
    _contacts.clear();
    _saveContactsToPrefs();
    notifyListeners();
  }

  Contact getContactById(String id) {
    return _contacts.firstWhere((contact) => contact.id == id);
  }

  void updateContact(Contact updateContact) {
    int index =
        _contacts.indexWhere((contact) => contact.id == updateContact.id);
    _contacts[index] = updateContact;
    _saveContactsToPrefs();
    notifyListeners();
  }

 void deleteContact(String? name) {
  if (name != null) {
    _contacts.removeWhere((contact) => contact.name == name);
    _saveContactsToPrefs();
    notifyListeners();
  } else {
    print("Cannot delete contact with null name");
  }
}
}
