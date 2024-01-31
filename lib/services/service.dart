import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ContactServices {
  static const String contacts = 'saved_contacts';

  static Future<void> saveContacts(List<String> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(contacts);
    prefs.setString('contacts', jsonString);
  }

  static Future<List<String>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('contacts') ?? '[]';
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.cast<String>();
  }

  void addContact(String newContact) async {
  List<String> currentContacts = await ContactServices.getContacts();
  currentContacts.add(newContact);
  saveContacts(currentContacts);
}

 Future<void> updateContact(String oldContact, String newContact) async {
    List<String> currentContacts = await getContacts();
    final int index = currentContacts.indexOf(oldContact);
    if (index != -1) {
      currentContacts[index] = newContact;
      saveContacts(currentContacts);
    }
  }
}
