import 'package:flutter/material.dart';
import 'profilepage.dart';
import 'call_dialing_page.dart';

class ScenarioSelectionPage extends StatefulWidget {
  final String userId;
  const ScenarioSelectionPage({super.key, required this.userId});

  @override
  State<ScenarioSelectionPage> createState() => _ScenarioSelectionPageState();
}

class _ScenarioSelectionPageState extends State<ScenarioSelectionPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1D5CFF),
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    InformationsManagementPage(userId: widget.userId),
              ),
            );
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: "Informations",
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              const Text(
                "Select a Scenario",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // 1. Food Delivery
              _buildScenarioCard(
                context,
                "Food Delivery",
                "Order from your favorite restaurants.",
                const Color(0xFFFFE5E5),
                Icons.fastfood_rounded,
              ),

              // 2. Get Info
              _buildScenarioCard(
                context,
                "Get Info",
                "Inquire about services or schedules.",
                const Color(0xFFE5F0FF),
                Icons.info_outline_rounded,
              ),

              // 3. Medical Appointment
              _buildScenarioCard(
                context,
                "Medical Appointment",
                "Book a visit with your doctor.",
                const Color(0xFFE0F7FA),
                Icons.medical_services_rounded,
              ),

              // 4. Book Transport
              _buildScenarioCard(
                context,
                "Book Transport",
                "Call a taxi or shuttle service.",
                const Color(0xFFFFF3E0),
                Icons.directions_car_filled_rounded,
              ),

              // 5. Emergency Services
              _buildScenarioCard(
                context,
                "Emergency Services",
                "Urgent contact with help centers.",
                const Color(0xFFFFEBEE),
                Icons.warning_amber_rounded,
              ),

              // 6. Custom Scenario
              _buildScenarioCard(
                context,
                "Custom",
                "Define your own call context.",
                const Color(0xFFF3E5F5),
                Icons.dashboard_customize_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1D5CFF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome back,",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            "Let's Talk!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Your voice in every conversation.",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(
    BuildContext context,
    String title,
    String sub,
    Color color,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallDialingPage(scenario: title),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.black54, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    sub,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
