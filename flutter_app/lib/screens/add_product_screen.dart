import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _code;
  String? _tags;
  String? _description;
  File? _image;
  bool _loading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, maxWidth: 800, imageQuality: 65);
    if (picked == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se seleccionó ninguna imagen o se denegó el permiso de cámara.')),
        );
      }
      return;
    }
    setState(() => _image = File(picked.path));
  }

  Future<String> _encodeImageAsDataUrl(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final mimeType = imageFile.path.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';
    return 'data:$mimeType;base64,${base64Encode(bytes)}';
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();
    setState(() => _loading = true);
    try {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await _encodeImageAsDataUrl(_image!);
      }
      await ApiService.createProduct(
        title: _title!,
        code: _code!,
        tags: _tags!,
        description: _description,
        imageUrl: imageUrl,
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar producto')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: _image == null ? const Icon(Icons.camera_alt, size: 48) : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                onSaved: (v) => _title = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Código del producto'),
                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                onSaved: (v) => _code = v,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Etiquetas',
                  hintText: 'Ej: top ventas, nuevo, oferta',
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                onSaved: (v) => _tags = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción'),
                onSaved: (v) => _description = v,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading ? const CircularProgressIndicator() : const Text('Guardar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
