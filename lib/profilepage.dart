import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InformationsManagementPage extends StatefulWidget {
  final String userId;
  const InformationsManagementPage({super.key, required this.userId});

  @override
  State<InformationsManagementPage> createState() =>
      _InformationsManagementPageState();
}

class _InformationsManagementPageState
    extends State<InformationsManagementPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInformations();
  }

  Future<void> _fetchInformations() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      _nameController.text = data['full_name'] ?? "";
      _ageController.text = data['age'] ?? "";
      _addressController.text = data['home_address'] ?? "";
      _cityController.text = data['city'] ?? "";
      _phoneController.text = data['phone'] ?? "";
      _emergencyController.text = data['emergency_contact'] ?? "";
      _notesController.text = data['medical_notes'] ?? "";
      setState(() {});
    }
  }

  Future<void> _updateInformations() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
            'full_name': _nameController.text,
            'age': _ageController.text,
            'home_address': _addressController.text,
            'city': _cityController.text,
            'phone': _phoneController.text,
            'emergency_contact': _emergencyController.text,
            'medical_notes': _notesController.text,
            'updated_at': FieldValue.serverTimestamp(),
          });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Informations Updated Successfully!")),
        );
        Navigator.pop(context);
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
      appBar: AppBar(
        title: const Text("Edit Informations"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "Modify Informations",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildField("Full Name", _nameController),
            _buildField("Age", _ageController, keyboard: TextInputType.number),
            _buildField("Home Address", _addressController),
            _buildField("City", _cityController),
            _buildField(
              "Phone Number",
              _phoneController,
              keyboard: TextInputType.phone,
            ),
            _buildField("Emergency Contact", _emergencyController),
            _buildField("Medical Notes", _notesController),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: _updateInformations,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D5CFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Change",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
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
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
