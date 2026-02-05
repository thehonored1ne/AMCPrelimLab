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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatStateAsync = ref.watch(chatNotifierProvider);

    return Drawer(
      child: chatStateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (state) {
          final notifier = ref.read(chatNotifierProvider.notifier);

          return Column(
            children: [
              DrawerHeader(
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
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ...state.availablePersonas.map((persona) {
                      final isSelected = state.activePersona.id == persona.id;
                      final isDefault = _isDefaultPersona(persona.id);
                      
                      return ListTile(
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
                      );
                    }).toList(),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text("Create Custom Persona"),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreatePersonaScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserSettingsScreen()),
                  );
                },
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
                navigator.pop(); // Close dialog
                navigator.pop(); // Close drawer
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text("Failed to delete persona: $e"),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ),
                );
                navigator.pop(); // Close dialog
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
