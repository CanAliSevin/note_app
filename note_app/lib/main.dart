import 'package:flutter/material.dart';
import 'models/note.dart';
import 'services/note_services.dart';

void main() => runApp(MyApp());

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blueGrey,
          ),
          themeMode: currentMode,
          home: NotePage(),
        );
      },
    );
  }
}

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final NoteService _service = NoteService();
  late Future<List<Note>> _notes;

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  void _refreshNotes() {
    setState(() {
      _notes = _service.getNotes();
    });
  }

  // Editör Sayfasına Yönlendirme (Hem ekleme hem düzenleme için)
  void _openNoteEditor({Note? note}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditorPage(note: note)),
    );

    // Sayfadan geri dönüldüğünde liste güncellensin
    if (result == true) {
      _refreshNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("       Notlarım")),
        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () =>
                themeNotifier.value = themeNotifier.value == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light,
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: _notes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text("Henüz not yok"));

          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Dismissible(
                key: Key(note.id.toString()),
                direction: DismissDirection.startToEnd,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  await _service.deleteNote(note.id!);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Not silindi")));
                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      note.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _openNoteEditor(
                      note: note,
                    ), // Düzenlemek için sayfayı açar
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNoteEditor(), // Yeni not eklemek için boş açar
        child: Icon(Icons.add),
      ),
    );
  }
}

// --- YENİ NOT EKLEME VE DÜZENLEME SAYFASI ---
class NoteEditorPage extends StatefulWidget {
  final Note? note;

  NoteEditorPage({this.note});

  @override
  _NoteEditorPageState createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final NoteService _service = NoteService();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController = TextEditingController(
      text: widget.note?.content ?? "",
    );
  }

  void _saveNote() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Başlık boş olamaz!")));
      return;
    }

    if (widget.note == null) {
      // YENİ EKLEME
      await _service.addNote(_titleController.text, _contentController.text);
    } else {
      // GÜNCELLEME
      await _service.updateNote(
        widget.note!.id!,
        _titleController.text,
        _contentController.text,
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "Yeni Not" : "Notu Düzenle"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveNote, // Kaydet butonu
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: "Başlık",
                border: InputBorder.none,
              ),
            ),
            Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Notunuzu buraya yazın...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveNote,
        label: Text("Kaydet"),
        icon: Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
