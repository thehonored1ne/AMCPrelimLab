import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/chat_provider.dart';
import '../../data/models/persona_model.dart';
import '../screens/create_persona_screen.dart';
import '../screens/user_settings_screen.dart';

class PersonaDrawer extends ConsumerWidget {
  const PersonaDrawer({super.key});

  ImageProvider _getIconProvider(String? assetPath) {
    if (assetPath == null) return const AssetImage('assets/icons/default.png');
    if (assetPath.startsWith('assets/')) {
      return AssetImage(assetPath);
    } else {
      return kIsWeb ? NetworkImage(assetPath) : FileImage(File(assetPath)) as ImageProvider;
    }
  }

  bool _isDefaultPersona(String id) {
    return const [
      'youth_mentor',
      'dev_senior',
      'legal_council',
      'local_business',
      'finance'
    ].contains(id);
  }

  Widget _buildAnimatedItem({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 80)),
      curve: Curves.easeOutQuint,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - value)),
            child: Transform.scale(
              scale: 0.9 + (0.1 * value),
              child: child!,
            ),
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatStateAsync = ref.watch(chatNotifierProvider);

    return Drawer(
      child: chatStateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (state) {
          final notifier = ref.read(chatNotifierProvider.notifier);
          final personas = state.availablePersonas;

          return Column(
            children: [
              _buildAnimatedItem(
                index: 0,
                child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: state.activePersona.themeColor,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: _getIconProvider(state.activePersona.iconAsset),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          state.activePersona.name,
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: personas.length,
                  itemBuilder: (context, index) {
                    final persona = personas[index];
                    final isSelected = state.activePersona.id == persona.id;
                    final isDefault = _isDefaultPersona(persona.id);
                    
                    return _buildAnimatedItem(
                      index: index + 1,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: persona.themeColor,
                          backgroundImage: _getIconProvider(persona.iconAsset),
                        ),
                        title: Text(
                          persona.name,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(persona.tone),
                        selected: isSelected,
                        selectedTileColor: persona.themeColor.withOpacity(0.1),
                        trailing: isDefault ? null : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreatePersonaScreen(persona: persona),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                              onPressed: () => _confirmDelete(context, ref, persona),
                            ),
                          ],
                        ),
                        onTap: () {
                          notifier.switchPersona(persona);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              _buildAnimatedItem(
                index: personas.length + 1,
                child: ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text("Create Custom Persona"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreatePersonaScreen()),
                    );
                  },
                ),
              ),
              _buildAnimatedItem(
                index: personas.length + 2,
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Settings"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserSettingsScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Persona persona) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Persona"),
        content: Text("Are you sure you want to delete '${persona.name}'? This will also clear its chat history."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              try {
                await ref.read(chatNotifierProvider.notifier).deletePersona(persona.id);
                messenger.showSnackBar(
                  SnackBar(
                    content: Text("Persona '${persona.name}' deleted successfully"),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                  ),
                );
                navigator.pop();
                navigator.pop();
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text("Failed to delete persona: $e"),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ),
                );
                navigator.pop();
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
