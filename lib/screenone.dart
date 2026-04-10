import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import this
import 'package:masterfaster/screentwo.dart';

class InformationsSetupPage extends StatefulWidget {
  const InformationsSetupPage({super.key});

  @override
  State<InformationsSetupPage> createState() => _InformationsSetupPageState();
}

class _InformationsSetupPageState extends State<InformationsSetupPage> {
  final _formKey = GlobalKey<FormState>(); // 1. Added Form Key
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  Future<void> _saveInformations() async {
    // 2. Trigger Validation
    if (!_formKey.currentState!.validate()) {
      return; // Stop if form is invalid
    }

    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('users')
          .add({
            'full_name': _nameController.text,
            'age': _ageController.text,
            'home_address': _addressController.text,
            'city': _cityController.text,
            'phone': _phoneController.text,
            'emergency_contact': _emergencyController.text,
            'medical_notes': _notesController.text,
            'created_at': FieldValue.serverTimestamp(),
          });

      // 3. Save "Login" state locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSetupComplete', true);
      await prefs.setString('userId', docRef.id);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ScenarioSelectionPage(userId: docRef.id),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            // 4. Wrap Column in a Form
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Welcome to VoiceFor",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Set up your informations for accurate AI assistance.",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                _buildField(
                  "Full Name",
                  "Enter full name",
                  _nameController,
                  isRequired: true,
                ),
                _buildField(
                  "Age",
                  "Enter age",
                  _ageController,
                  keyboard: TextInputType.number,
                  isRequired: true,
                ),
                _buildField(
                  "Home Address",
                  "Street address",
                  _addressController,
                  isRequired: true,
                ),
                _buildField(
                  "City",
                  "City and country",
                  _cityController,
                  isRequired: true,
                ),
                _buildField(
                  "Phone Number",
                  "+1...",
                  _phoneController,
                  keyboard: TextInputType.phone,
                  isRequired: true,
                ),
                _buildField(
                  "Emergency Contact",
                  "Name and number",
                  _emergencyController,
                  isRequired: true,
                ),
                _buildField(
                  "Medical Notes",
                  "Optional",
                  _notesController,
                  isRequired: false,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _saveInformations,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D5CFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    bool isRequired = false, // 5. Added isRequired flag
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            // 6. Added Validator logic
            validator: (value) {
              if (isRequired && (value == null || value.trim().isEmpty)) {
                return "$label is required";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
