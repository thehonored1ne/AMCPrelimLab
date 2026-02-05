import 'package:hive_flutter/hive_flutter.dart';
import '../models/chat_message_model.dart';
import '../models/persona_model.dart';

class ChatRepository {
  static const String _chatsBoxName = 'chats';
  static const String _personasBoxName = 'custom_personas';

  Future<Box<List>> _openChatsBox() async => await Hive.openBox<List>(_chatsBoxName);
  Future<Box<Persona>> _openPersonasBox() async => await Hive.openBox<Persona>(_personasBoxName);

  Future<List<ChatMessage>> getMessages(String personaId) async {
    final box = await _openChatsBox();
    final raw = box.get(personaId) ?? [];
    return raw.cast<ChatMessage>().toList();
  }

  Future<void> saveMessages(String personaId, List<ChatMessage> messages) async {
    final box = await _openChatsBox();
    await box.put(personaId, messages);
  }

  Future<List<Persona>> getCustomPersonas() async {
    final box = await _openPersonasBox();
    return box.values.toList();
  }

  Future<void> saveCustomPersona(Persona persona) async {
    final box = await _openPersonasBox();
    await box.put(persona.id, persona);
  }

  Future<void> deleteCustomPersona(String personaId) async {
    final box = await _openPersonasBox();
    await box.delete(personaId);

    // Also clear chat history for this persona
    final chatsBox = await _openChatsBox();
    await chatsBox.delete(personaId);
  }

  Future<void> clearHistory(String personaId) async {
    final box = await _openChatsBox();
    await box.delete(personaId);
  }
}
