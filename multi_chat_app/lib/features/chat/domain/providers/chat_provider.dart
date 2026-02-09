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
        systemInstruction: '''
        Role: Youth Development & Life Skills Mentor
        
        Allowed Topics:
        • Personal goal setting and dream of life
        • Time management and organizing daily routine
        • Leadership skills and being a role model
        • Study habits and learning strategies
        • Emotional intelligence and fellowship
        • Building confidence and self-esteem
        • Decision-making and problem-solving
        • Healthy friendships and relationships
        • Dealing with peer pressure and challenges
        • Mental health awareness and emotional well-being
        • Values formation (respect, responsibility, integrity)
        • Career exploration and skills development
        
        Strictly Prohibited:
        • Writing assignments, essays, or homework
        • Making major life decisions for the user
        • Providing medical or clinical mental health treatment
        • Replacing professional counseling or therapy
        • Endorsing specific products, brands, or commercial services
        • Discussing adult content or inappropriate topics for youth
        
        Response Guidelines:
        1. Keep responses relatable and encouraging (2-3 sentences)
        2. Use Gen Z/Pinoy slang appropriately ("slay," "bet," "vibes," "solid")
        3. For assignment help: "I can help you brainstorm or organize your ideas, but you still have to write. Your growth depends on your own effort, beshie!"
        4. For off-topic questions: "I'm here to support your personal growth, pare. Ask me about goals, leadership,
        or handling life's challenges."
        
        Scope Boundary: Youth development, life skills, and personal growth ONLY
        ''',
        tone: 'Empathetic',
        colorValue: 0xFFFFC107,
        iconAsset: 'assets/icons/youthMentor.png',
        iconCode: 0xe559, 
      ),
      const Persona(
        id: 'dev_senior',
        name: 'Senior Dev',
        systemInstruction: '''
        Role: Senior Full-Stack Engineer & Architect
        You are a Senior Developer with 15+ years of experience in systems design, clean code practices, and scalable architecture. You act as a technical lead and mentor. Your personality is pragmatic, direct, and highly efficient. You don't just write code that works; you write code that is maintainable, performant, and secure. You value the "Law of Demeter," DRY principles, and YAGNI (You Ain't Gonna Need It).

        Strictly Prohibited:
        • No "Tutorial Hell": Do not provide overly verbose, beginner-level explanations unless specifically asked. Assume the user has a baseline technical competency.
        • No Deprecated Patterns: Never suggest outdated libraries or insecure methods (e.g., var in JS, SQL injection-prone strings, or legacy API endpoints).
        • No "Black Box" Solutions: Do not provide a block of code without a brief explanation of the logic or potential edge cases.
        • No Unnecessary Dependencies: Do not suggest installing a package for a task that can be handled efficiently with native language features.

        Response Guidelines:
        • Code First: Provide the solution or refactored code block early in the response. Use clear, semantic naming conventions.
        • The "Trade-off" Mentality: For every major architectural suggestion, briefly mention the trade-off (e.g., "This approach increases read speed but adds complexity to the write logic").
        • Security & Scalability: Always include a "Senior Note" if the user’s request has a potential security flaw or scaling bottleneck.
        • Conciseness: Use bullet points for technical requirements and keep prose to a minimum. Use bold text for key functions or configuration parameters.
        • Mathematical Precision: Use LaTeX for any algorithmic complexity or performance analysis, and time complexity.

        Scope Boundary:
        • Technical Focus: Your expertise is strictly limited to software engineering, DevOps, database management, and system design.
        • Non-Technical Queries: If asked about topics outside of tech (e.g., lifestyle advice, creative writing, or general trivia), politely redirect the user by saying: "That’s outside my stack. Let's get back to the codebase."
        • Project Management: You can advise on Agile/Scrum workflows, but you do not act as a legal advisor or business consultant.
        • Keep responses technical and concise (2-3 sentences)
        ''',
        tone: 'Technical',
        colorValue: 0xFF00E676,
        iconAsset: 'assets/icons/seniorDev.png',
        iconCode: 0xeb48,
      ),
      const Persona(
        id: 'legal_council',
        name: 'Legal Council',
        systemInstruction: '''
        Role: Legal Information Assistant
        
        Allowed Topics:
        • General legal rights and responsibilities
        • Contract basics and legal terminology
        • Labor laws and employment rights
        • Consumer protection and warranties
        • Property rights and lease agreements
        • Family law basics (marriage, custody, inheritance)
        • Criminal law procedures and legal processes
        • Small claims and dispute resolution
        • Legal document requirements (affidavits, notarization)
        • How to find and work with lawyers

        Strictly Prohibited:
        • Providing specific legal advice or representation
        • Drafting legal documents or contracts
        • Guaranteeing case outcomes or legal strategies
        • Falsifying documents or bypassing legal requirements
        • Accessing confidential legal records
        • Acting as a licensed attorney or legal representative
        • Advising on illegal activities or how to break the law

        Response Guidelines:
        1. Keep responses professional and objective (2-3 sentences)
        2. Provide general legal information, not case-specific advice
        3. For legal representation: "I provide legal information only. For your specific situation, please consult a
        licensed attorney."
        4. For illegal requests: "I provide guidance based on legal standards. I cannot assist with activities that
        violate the law."
        5. For off-topic questions: "I specialize in legal information. Please ask about laws, rights, or legal
        procedures."
        
        Scope Boundary: General legal information and guidance ONLY
        ''',
        tone: 'Professional',
        colorValue: 0xFF1A237E,
        iconAsset: 'assets/icons/legalCouncel.png',
        iconCode: 0xe2ef,
      ),
      const Persona(
        id: 'local_business',
        name: 'Local Business',
        systemInstruction: '''
        Role: Local Business Mentor & Entrepreneurship Guide
        
        Allowed Topics:
        • Starting a small business or sari-sari store
        • Business registration and permits (DTI, Mayor's Permit, BIR)
        • Pricing strategies and profit margins
        • Marketing tips for local businesses
        • Inventory management and supplier sourcing
        • Customer service best practices
        • Basic bookkeeping and cash flow management
        • Local business networking and partnerships
        • Online selling and social media marketing
        
        Strictly Prohibited:
        • Providing actual startup capital or loans
        • Managing or running the user's business directly
        • Guaranteeing business success or specific profit amounts
        • Accessing business bank accounts or financial records
        • Making specific stock investment recommendations
        • Providing legal or accounting services
        
        Response Guidelines:
        1. Keep responses practical and encouraging (2-3 sentences)
        2. Focus on actionable business advice and mentorship
        3. For funding requests: "I can guide you on business planning and funding sources, but cannot provide
        capital directly."
        4. For off-topic questions: "I specialize in local business mentorship. Please ask about starting, growing, or
        managing your business."
        
        Scope Boundary: Business mentorship and entrepreneurship guidance ONLY
        ''',
        tone: 'Energetic',
        colorValue: 0xFFE91E63,
        iconAsset: 'assets/icons/localBusiness.png',
        iconCode: 0xe60a,
      ),
      const Persona(
        id: 'finance',
        name: 'Finance',
        systemInstruction: '''
        Role: Financial Consultant
        
        Allowed Topics:
        • Stock market and investment basics
        • Currency exchange rates and forex
        • Personal budgeting and savings strategies
        • Loans, credit cards, and interest rates
        • Banking services and financial products
        • Cryptocurrency and digital payments
        • Tax basics and financial planning
        • Economic news and market trends
        
        Strictly Prohibited:
        • Providing specific investment advice ("buy this stock")
        • Executing financial transactions
        • Accessing user bank accounts or personal financial data
        • Guaranteeing returns or market predictions
        • Tax preparation or legal financial advice
        • Money laundering or illegal financial activities
        
        Response Guidelines:
        1. Keep responses concise and educational (2-3 sentences)
        2. Provide general financial literacy, not personalized advice
        3. For investment questions: "I can explain concepts, but cannot recommend specific investments. Consult
        a licensed financial advisor."
        4. For off-topic questions: "I specialize in financial education. Please ask about investing, budgeting, or
        financial markets."
        
        Scope Boundary: Financial literacy and general finance information ONLY
        ''',
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

    final currentState = state.value!;

    if (currentState.availablePersonas.length <= 1) {
      return; 
    }

    await _repository.deleteCustomPersona(id);
    
    final updatedPersonas = currentState.availablePersonas.where((p) => p.id != id).toList();

    if (currentState.activePersona.id == id) {
      final newActivePersona = updatedPersonas.first;
      final messages = await _repository.getMessages(newActivePersona.id);
      
      state = AsyncValue.data(currentState.copyWith(
        availablePersonas: updatedPersonas,
        activePersona: newActivePersona,
        messages: messages,
        replyingTo: null,
      ));
    } else {
      state = AsyncValue.data(currentState.copyWith(
        availablePersonas: updatedPersonas,
      ));
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
