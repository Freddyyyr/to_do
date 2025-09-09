import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'BLoC/noteBLoC.dart';
import 'BLoC/noteEvent.dart';
import 'BLoC/noteState.dart';

void main() {
  runApp(BlocProvider(create: (context) => NoteBloc(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BLoC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const MyHomePage(title: 'To Do App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    List<String> items = ['Work', 'Personal', 'Family'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              spacing: 20,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Category',
                  ),
                  items: items.map((item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
                  value: _selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty &&
                        _descriptionController.text.isNotEmpty &&
                        _selectedCategory != null) {
                      context.read<NoteBloc>().add(
                        AddNote(
                          _titleController.text,
                          _descriptionController.text,
                          _selectedCategory!,
                        ),
                      );
                      _titleController.clear();
                      _descriptionController.clear();
                      _selectedCategory = null;
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<NoteBloc, NoteState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    GridView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: state.notes.length,
                      itemBuilder: (context, index) {
                        final note = state.notes[index];
                        return LongPressDraggable<int>(
                          data: index,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Container(
                              width: 150,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade700,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                note.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.4,
                            child: NoteCard(note: note),
                          ),
                          child: NoteCard(note: note),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: DragTarget<int>(
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            height: 70,
                            width: double.infinity,
                            color: candidateData.isNotEmpty
                                ? Colors.red.withOpacity(0.7)
                                : Colors.red.withOpacity(0.4),
                            child: const Center(
                              child: Text(
                                "Drop here to delete",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                        onAccept: (index) {
                          context.read<NoteBloc>().add(RemoveNote(index));
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(note.description),
          const Spacer(),
          Text(note.category, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
