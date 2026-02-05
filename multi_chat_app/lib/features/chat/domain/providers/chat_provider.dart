import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/persona_model.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/services/gemini_service.dart';
import '../../data/repositories/chat_repository.dart';

part 'chat_provider.g.dart';
part 'chat_provider.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    required Persona activePersona,
    required List<Persona> availablePersonas,
    required List<ChatMessage> messages,
    required bool isLoading,
    @Default(ThemeMode.light) ThemeMode themeMode,
    @Default('English') String language,
    String? userIconAsset,
    ChatMessage? replyingTo,
  }) = _ChatState;
}

@riverpod
class ChatNotifier extends _$ChatNotifier {
  final _repository = ChatRepository();

  final List<String> _defaultPersonaIds = [
    'youth_mentor',
    'dev_senior',
    'legal_council',
    'local_business',
    'finance'
  ];

  @override
  Future<ChatState> build() async {
    final defaultPersonas = [
      const Persona(
        id: 'youth_mentor',
        name: 'Youth Mentor',
        systemInstruction: '''You are the official Youth Development Mentor for the University. 
You ONLY answer questions about personal growth, student leadership, and emotional well-being within a campus context.

RULES:
1. Provide advice on time management, study habits, and leadership skills 📅
2. Offer guidance on navigating campus life and student organizations 🏫
3. Explain student rights, peer support resources, and mental health services 📋
4. Direct students to the Guidance Office or Peer Facilitators for specific needs 👉
5. If asked to write personal statements or do assignments -> RESPOND: "I can help you brainstorm ideas or find your voice, but I cannot write this for you. Your personal growth depends on your own effort!" 🚫
6. If someone asks about commercial products, gaming, or unrelated technical topics -> RESPOND: "I am here to support your growth as a student. Please ask me about personal development or campus life."
7. Use Gen Z slang appropriately. Be concise (2-3 sentences max) and friendly.

SCOPE: Student Growth, Leadership, Well-being ONLY''',
        tone: 'Empathetic',
        colorValue: 0xFFFFC107,
        iconAsset: 'assets/icons/youthMentor.png',
        iconCode: 0xe559, 
      ),
      const Persona(
        id: 'dev_senior',
        name: 'Senior Dev',
        systemInstruction: '''You are the official Senior Technical Consultant for the University IT Department. 
You ONLY answer questions about software development, technical concepts, and campus IT infrastructure.

RULES:
1. Explain programming concepts, logic, and debugging strategies using code blocks 💻
2. Provide info on campus labs, official software licenses, and IT support tickets 🏫
3. Explain coding standards, deployment procedures, and technical documentation 📋
4. Direct users to the IT Helpdesk for hardware issues or account resets 👉
5. If asked to write complete projects or do coding exams -> RESPOND: "I can explain snippets or logic, but I cannot build your project for you. Mastering code requires hands-on practice!" 🚫
6. If someone asks about gossip, personal life, or non-technical topics -> RESPOND: "I am focused on technical excellence. Please ask me about development or IT resources."
7. Be concise (2-3 sentences max), cynical but helpful. Use technical terms.

SCOPE: Software Development, Tech Logic, IT Infrastructure ONLY''',
        tone: 'Technical',
        colorValue: 0xFF00E676,
        iconAsset: 'assets/icons/seniorDev.png',
        iconCode: 0xeb48,
      ),
      const Persona(
        id: 'legal_council',
        name: 'Legal Counsel',
        systemInstruction: '''You are the official Campus Legal Advisor for the University. 
You ONLY answer questions about campus regulations, student disciplinary codes, and legal procedures within the institution.

RULES:
1. Answer questions regarding student handbooks, constitutional rights, and grievance procedures ⚖️
2. Provide info on the location of legal aid offices and administrative hearing rooms 🏫
3. Explain University bylaws, contract basics for student events, and compliance rules 📋
4. Direct students to the Legal Counsel's Office or Student Tribunal for specific legal representation 👉
5. If asked to falsify documents or bypass rules -> RESPOND: "I provide legal guidance based on official policies. I cannot assist in violating the law or school regulations." 🚫
6. If someone asks about social media drama, entertainment, or casual topics -> RESPOND: "I am specialized in campus legal and policy assistance. Please ask me about regulations or institutional law."
7. Be professional, objective, and concise (2-3 sentences max).

SCOPE: Campus Law, Student Rights, Institutional Policy ONLY''',
        tone: 'Professional',
        colorValue: 0xFF1A237E,
        iconAsset: 'assets/icons/legalCouncel.png',
        iconCode: 0xe2ef,
      ),
      const Persona(
        id: 'local_business',
        name: 'Local Business',
        systemInstruction: '''You are the official Local Business Liaison for the University. 
You ONLY answer questions about nearby student discounts, partner establishments, and campus entrepreneurship.

RULES:
1. Provide info on student deals, nearby dining options, and local services 🍔
2. Give directions to partner stores, banks, and transport hubs near the campus 🏫
3. Explain the process for student-led business booths and campus bazaars 📋
4. Direct student entrepreneurs to the Business Development Center for partnership requests 👉
5. If asked to provide startup capital or manage a business -> RESPOND: "I can guide you to local resources and partnership info, but I cannot manage your business for you. Experience is the best teacher!" 🚫
6. If someone asks about global politics, celebrity news, or unrelated hobbies -> RESPOND: "I am focused on the local business ecosystem. Please ask me about nearby shops, discounts, or campus bazaars."
7. Be friendly, energetic, and concise (2-3 sentences max).

SCOPE: Local Partners, Student Discounts, Campus Bazaars ONLY''',
        tone: 'Energetic',
        colorValue: 0xFFE91E63,
        iconAsset: 'assets/icons/localBusiness.png',
        iconCode: 0xe60a,
      ),
      const Persona(
        id: 'finance',
        name: 'Finance',
        systemInstruction: '''You are the official Campus Financial Consultant for the University. 
You ONLY answer questions about tuition fees, scholarship requirements, and campus financial literacy.

RULES:
1. Answer questions about payment deadlines, refund policies, and scholarship applications 💰
2. Provide directions to the Cashier, Accounting Office, and Financial Aid Department 🏫
3. Explain billing statements, student insurance fees, and installment plans 📋
4. Direct students to the Registrar or Scholarship Committee for specific document submissions 👉
5. If asked to manipulate financial records or pay for items -> RESPOND: "I can explain fees and processes, but I cannot process payments or alter financial data. Transparency is key!" 🚫
6. If someone asks about dating advice, movies, or non-financial topics -> RESPOND: "I am specialized in campus financial assistance. Please ask me about fees, scholarships, or financial literacy."
7. Be precise, helpful, and concise (2-3 sentences max).

SCOPE: Tuition, Scholarships, Financial Literacy ONLY''',
        tone: 'Precise',
        colorValue: 0xFF4CAF50,
        iconAsset: 'assets/icons/finance.png',
        iconCode: 0xe041,
      ),
    ];

    final customPersonas = await _repository.getCustomPersonas();
    final allPersonas = [...defaultPersonas, ...customPersonas];

    final initialPersona = allPersonas[0];
    final messages = await _repository.getMessages(initialPersona.id);

    return ChatState(
      activePersona: initialPersona,
      availablePersonas: allPersonas,
      messages: messages,
      isLoading: false,
    );
  }

  void toggleTheme() {
    final currentMode = state.value!.themeMode;
    final nextMode = currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = AsyncValue.data(state.value!.copyWith(themeMode: nextMode));
  }

  void setLanguage(String language) {
    state = AsyncValue.data(state.value!.copyWith(language: language));
  }

  void setUserIcon(String? assetPath) {
    state = AsyncValue.data(state.value!.copyWith(userIconAsset: assetPath));
  }

  void setReplyingTo(ChatMessage? message) {
    state = AsyncValue.data(state.value!.copyWith(replyingTo: message));
  }

  Future<void> toggleReaction(String messageId, String emoji) async {
    final currentState = state.value!;
    final updatedMessages = currentState.messages.map((m) {
      if (m.id == messageId) {
        final isAlreadyThisEmoji = m.reactions.contains(emoji);
        return m.copyWith(reactions: isAlreadyThisEmoji ? [] : [emoji]);
      }
      return m;
    }).toList();

    state = AsyncValue.data(currentState.copyWith(messages: updatedMessages));
    await _repository.saveMessages(currentState.activePersona.id, updatedMessages);
  }

  Future<void> switchPersona(Persona persona) async {
    final currentState = state.value!;
    state = const AsyncValue.loading();
    final messages = await _repository.getMessages(persona.id);
    state = AsyncValue.data(currentState.copyWith(
      activePersona: persona,
      messages: messages,
      replyingTo: null,
    ));
  }

  Future<void> deletePersona(String id) async {
    if (_defaultPersonaIds.contains(id)) return;
    
    await _repository.deleteCustomPersona(id);
    final currentState = state.value!;
    final allPersonas = currentState.availablePersonas.where((p) => p.id != id).toList();
    
    if (currentState.activePersona.id == id) {
      await switchPersona(allPersonas.first);
    } else {
      state = AsyncValue.data(currentState.copyWith(availablePersonas: allPersonas));
    }
  }

  Future<void> sendMessage(String text, {List<XFile>? images}) async {
    final currentState = state.value!;
    final currentPersona = currentState.activePersona;
    final language = currentState.language;
    final previousMessages = currentState.messages;
    final replyingTo = currentState.replyingTo;

    List<Uint8List> imageBytesList = [];
    List<String> imagePaths = [];
    
    if (images != null && images.isNotEmpty) {
      for (var image in images) {
        final bytes = await image.readAsBytes();
        imageBytesList.add(bytes);
        imagePaths.add(image.path);
      }
    }

    final userMsg = ChatMessage(
        id: const Uuid().v4(),
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
        imagePaths: imagePaths,
        replyToId: replyingTo?.id,
        replyToText: replyingTo?.text,
    );

    final historyWithUser = [...previousMessages, userMsg];
    state = AsyncValue.data(currentState.copyWith(
      messages: historyWithUser, 
      isLoading: true,
      replyingTo: null,
    ));
    await _repository.saveMessages(currentPersona.id, historyWithUser);

    try {
      final gemini = ref.read(geminiServiceProvider);
      final personalizedInstruction = "${currentPersona.systemInstruction}\n\nIMPORTANT: Respond ONLY in $language.";
      
      gemini.initModel(systemInstruction: personalizedInstruction, isVision: imageBytesList.isNotEmpty);

      final geminiHistory = previousMessages.where((m) => 
        m.id != 'thinking-id' && !m.text.startsWith('Error:')
      ).map((m) {
        return m.isUser 
          ? Content('user', [TextPart(m.text)]) 
          : Content('model', [TextPart(m.text)]);
      }).toList();

      final thinkingMsg = ChatMessage(
        id: 'thinking-id',
        text: '${currentPersona.name} is thinking...',
        isUser: false,
        timestamp: DateTime.now(),
      );
      state = AsyncValue.data(state.value!.copyWith(
        messages: [...historyWithUser, thinkingMsg]
      ));

      final stream = gemini.streamChat(
        geminiHistory, 
        text, 
        imageBytesList.isNotEmpty ? imageBytesList : null
      );

      String fullResponse = "";
      await for (final chunk in stream) {
        fullResponse += chunk.text ?? "";
      }

      await Future.delayed(const Duration(seconds: 4));

      if (fullResponse.isEmpty) {
        fullResponse = "I'm sorry, I couldn't generate a response. Please check your API key and connection.";
      }

      final aiMsg = ChatMessage(
          id: const Uuid().v4(),
          text: fullResponse,
          isUser: false,
          timestamp: DateTime.now()
      );

      final latestMessages = state.value!.messages.where((m) => m.id != 'thinking-id').toList();

      state = AsyncValue.data(state.value!.copyWith(
        messages: [...latestMessages, aiMsg],
        isLoading: false
      ));
      
      await _repository.saveMessages(currentPersona.id, state.value!.messages);

    } catch (e) {
      final currentMessages = state.value!.messages.where((m) => m.id != 'thinking-id').toList();
      
      String displayError = "Error: $e";
      if (e.toString().contains("quota") || e.toString().contains("429")) {
        displayError = "Daily limit reached, please try again later.";
      }

      final errorMsg = ChatMessage(
        id: const Uuid().v4(),
        text: displayError,
        isUser: false,
        timestamp: DateTime.now(),
      );
      state = AsyncValue.data(state.value!.copyWith(
        messages: [...currentMessages, errorMsg],
        isLoading: false
      ));
    }
  }

  Future<void> addPersona(String name, String instruction, String tone, int colorValue, {String? iconAsset, String? id}) async {
    final currentState = state.value!;
    
    final newPersona = Persona(
      id: id ?? const Uuid().v4(),
      name: name,
      systemInstruction: instruction,
      tone: tone,
      colorValue: colorValue,
      iconAsset: iconAsset ?? 'assets/icons/default.png',
      iconCode: 57941,
    );

    await _repository.saveCustomPersona(newPersona);
    
    // Instead of calling build() which resets themeMode and language,
    // we update the list manually in the current state.
    
    final existingIndex = currentState.availablePersonas.indexWhere((p) => p.id == newPersona.id);
    final List<Persona> updatedList;
    
    if (existingIndex != -1) {
      updatedList = List<Persona>.from(currentState.availablePersonas);
      updatedList[existingIndex] = newPersona;
    } else {
      updatedList = [...currentState.availablePersonas, newPersona];
    }

    state = AsyncValue.data(currentState.copyWith(
      availablePersonas: updatedList,
      // If we're updating the currently active persona, update its reference too
      activePersona: currentState.activePersona.id == newPersona.id ? newPersona : currentState.activePersona,
    ));
  }

  Future<void> clearChat() async {
    final currentState = state.value!;
    await _repository.clearHistory(currentState.activePersona.id);
    state = AsyncValue.data(currentState.copyWith(messages: []));
  }
}
