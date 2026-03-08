import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/note.dart';

class NoteService {
  // Backend adresi
  final String baseUrl = "http://10.0.2.2:8080/rest/api/notes";

  // Tüm notları getir
  Future<List<Note>> getNotes() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8080/rest/api/notes/list"),
    );

    if (response.statusCode == 200) {
      // JSON decode
      List jsonData = jsonDecode(response.body);
      // JSON'u Note objesine çevir
      return jsonData.map((e) => Note.fromJson(e)).toList();
    } else {
      throw Exception("Notlar alınamadı");
    }
  }

  // Yeni not ekle
  Future<http.Response> addNote(String title, String content) async {
    return await http.post(
      Uri.parse("http://10.0.2.2:8080/rest/api/notes/save"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title, "content": content}),
    );
  }

  // Not sil
  Future<http.Response> deleteNote(int id) async {
    return await http.delete(
      Uri.parse("http://10.0.2.2:8080/rest/api/notes/$id"),
      headers: {"Content-Type": "application/json"},
    );
  }

  // Not güncelle
  Future<http.Response> updateNote(int id, String title, String content) async {
    return await http.put(
      Uri.parse("http://10.0.2.2:8080/rest/api/notes/update/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "title": title, "content": content}),
    );
  }
}
