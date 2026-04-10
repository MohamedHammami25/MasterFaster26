# VoiceFor 🚀

**VoiceFor** is an AI-powered assistive communication application built with Flutter. It is designed to empower individuals with verbal disabilities to conduct phone calls independently by using real-time AI to bridge the gap between text input and vocal conversation.

---

## ✨ Key Features

* **Contextual Call Scenarios:** Pre-defined personas (Food Delivery, Medical, Emergency) that guide the AI's behavior.
* **Real-time AI Dialogue:** Integration with **Ollama (Llama 3)** to generate natural, human-like responses.
* **Smart Suggested Replies:** Dynamic "Action Chips" that allow users to respond instantly with one tap, generated with AI that understands the context.
* **Conversational Memory ("Memory Job"):** The AI maintains full awareness of the conversation history to provide relevant follow-ups.
* **Profile Persistence:** Built-in integration with **Firebase Firestore** to store user details and medical notes.
* **Multi-Language Support:** Optimized for English, French, and Arabic.
* **Dual-Voice Synthesis:** Uses distinct vocal pitches via `flutter_tts` to differentiate between the user and the recipient.

---

## 🏗️ System Architecture

The app operates on a client-server model to keep the mobile client lightweight while utilizing heavy AI models on a local workstation.



1.  **Frontend:** Flutter (Dart) manages the UI, state, and local audio playback.
2.  **Database:** Firebase Firestore handles user authentication and persistent profile data.
3.  **AI Engine:** A local server running Ollama processes the "Memory Job" and generates JSON-structured responses.

---

## 🛠️ Installation & Setup

### 1. Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
* [Ollama](https://ollama.com/) installed on your local PC.
* A Firebase project created in the [Firebase Console](https://console.firebase.google.com/).

### 2. Ollama Setup (The AI Brain)
To allow your mobile device to communicate with your PC's AI engine:
1.  Download the Llama 3 model: `ollama pull llama3`.
2.  Expose Ollama to your local network:
    * **Windows (CMD):** `set OLLAMA_HOST=0.0.0.0` then `ollama serve`.
3.  Ensure port `11434` is open in your PC's firewall.

### 3. Firebase Configuration
1.  Run `flutterfire configure` to generate your `firebase_options.dart`.
2.  Enable **Cloud Firestore** and ensure the `users` collection is accessible.

### 4. Audio Assets
Add a ringing sound to your project:
1.  Place `ringing.mp3` in the `assets/` folder.
2.  Update `pubspec.yaml`:
    ```yaml
    flutter:
      assets:
        - assets/logo.png
        - assets/ringing.mp3
    ```

---

## 🚀 Running the App

1.  **Get Dependencies:**
    ```bash
    flutter pub get
    ```
2.  **Update Endpoint:**
    Open `lib/call_simulation_page.dart` and update the `ollamaUrl` with your PC's local IP address:
    ```dart
    final String ollamaUrl = "http://192.168.1.XX:11434/api/chat";
    ```
3.  **Launch:**
    ```bash
    flutter run
    ```

---

## 📂 Project Structure

* `main.dart`: Entry point and navigation logic.
* `splash_screen.dart`: Branded entry animation.
* `screenone.dart`: User onboarding and Firebase profile setup.
* `screentwo.dart`: Scenario selection dashboard.
* `call_dialing_page.dart`: Dialpad and language selection.
* `call_simulation_page.dart`: Core logic for AI calls, Memory Job, and TTS.
* `profilepage.dart`: Management of saved user information.

---

## 📜 License
This project is licensed under the BSD 3-Clause License.
