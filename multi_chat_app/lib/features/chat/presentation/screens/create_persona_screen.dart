import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/providers/chat_provider.dart';
import '../../data/models/persona_model.dart';

class CreatePersonaScreen extends ConsumerStatefulWidget {
  final Persona? persona;
  const CreatePersonaScreen({super.key, this.persona});

  @override
  ConsumerState<CreatePersonaScreen> createState() => _CreatePersonaScreenState();
}

class _CreatePersonaScreenState extends ConsumerState<CreatePersonaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _instructionCtrl = TextEditingController();
  final _toneCtrl = TextEditingController();
  Color _selectedColor = Colors.blue;
  XFile? _selectedIcon;
  final ImagePicker _picker = ImagePicker();

  final List<Color> _colorOptions = [
    Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal
  ];

  @override
  void initState() {
    super.initState();
    if (widget.persona != null) {
      _nameCtrl.text = widget.persona!.name;
      _toneCtrl.text = widget.persona!.tone;
      _instructionCtrl.text = widget.persona!.systemInstruction;
      _selectedColor = widget.persona!.themeColor;
      // Note: We can't easily convert asset path to XFile for preview here without more logic, 
      // but the UI will show the existing icon if we adjust it.
    }
  }

  Future<void> _pickIcon() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedIcon = image);
    }
  }

  ImageProvider? _getAvatarImage() {
    if (_selectedIcon != null) {
      return kIsWeb ? NetworkImage(_selectedIcon!.path) : FileImage(File(_selectedIcon!.path)) as ImageProvider;
    }
    if (widget.persona != null) {
      if (widget.persona!.iconAsset.startsWith('assets/')) {
        return AssetImage(widget.persona!.iconAsset);
      } else {
        return kIsWeb ? NetworkImage(widget.persona!.iconAsset) : FileImage(File(widget.persona!.iconAsset)) as ImageProvider;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.persona != null;
    
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Persona" : "Create New Persona")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickIcon,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: _selectedColor.withOpacity(0.2),
                    backgroundImage: _getAvatarImage(),
                    child: _getAvatarImage() == null
                        ? Icon(Icons.add_a_photo, size: 40, color: _selectedColor)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(child: Text("Tap to select Icon/Avatar")),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Persona Name", hintText: "e.g., Fitness Coach"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _toneCtrl,
                decoration: const InputDecoration(labelText: "Tone", hintText: "e.g., Aggressive, Calm"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: "System Instruction",
                    hintText: "You are a fitness coach. You yell at the user to do pushups...",
                    border: OutlineInputBorder()
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 24),
              const Text("Theme Color"),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: _colorOptions.map((color) => GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 20,
                    child: _selectedColor == color ? const Icon(Icons.check, color: Colors.white) : null,
                  ),
                )).toList(),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16)
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final personaName = _nameCtrl.text;
                      ref.read(chatNotifierProvider.notifier).addPersona(
                        personaName,
                        _instructionCtrl.text,
                        _toneCtrl.text,
                        _selectedColor.value,
                        iconAsset: _selectedIcon?.path ?? widget.persona?.iconAsset,
                        id: widget.persona?.id, // Pass existing ID if editing
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isEditing ? "Persona '$personaName' updated!" : "Persona '$personaName' created successfully!"),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: _selectedColor,
                        ),
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: Text(isEditing ? "Update Persona" : "Create Persona")
              )
            ],
          ),
        ),
      ),
    );
  }
}
