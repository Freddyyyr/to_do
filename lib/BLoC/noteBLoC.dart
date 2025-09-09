import 'package:flutter_bloc/flutter_bloc.dart';
import 'noteEvent.dart';
import 'noteState.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteState(notes: [])) {
    on<AddNote>((event, emit) {
      final addedNote = List<Note>.from(state.notes)
        ..add(
          Note(
            title: event.title,
            description: event.description,
            category: event.category,
          ),
        );
      emit(NoteState(notes: addedNote));
    });
    on<RemoveNote>((event, emit) {
      final removedNote = List<Note>.from(state.notes)..removeAt(event.index);
      emit(NoteState(notes: removedNote));
    });
  }
}
