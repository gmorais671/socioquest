# Socioeconomic Survey App

A mobile application developed with Flutter to streamline socioeconomic data collection in the field.

### 🚀 Key Features:
- **Offline-First:** Full data collection capability without internet using SQLite.
- **GPS Integration:** Automatic capture of Latitude and Longitude for every survey.
- **Data Management:** Complete CRUD (Create, Read, Update, Delete) for survey records.
- **Smart Export:** Generate and share XLSX (Excel) reports directly from the device.
- **Modern UI:** Clean, sectioned forms designed for high usability.

### 🛠 Tech Stack:
- **Framework:** Flutter
- **Database:** SQLite (sqflite)
- **Language:** Dart
- **Platform:** Android

- ## 📥 Installation & Setup

### For Users (Quick Install)
If you just want to install the app on your Android device:
1. Go to the [Releases](https://github.com/SEU_USUARIO/SEU_REPO/releases) section of this repository.
2. Download the `app-release.apk` file.
3. Transfer it to your phone and open it to install (you may need to allow "Installation from Unknown Sources").

---

### For Developers (Local Build)
To run this project locally, ensure you have the Flutter SDK installed and configured.

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/your-repo-name.git
   cd your-repo-name

2. **Install dependencies:**
   ```bash
   flutter pub get
   
3. **Check for connected devices:**
   ```bash
   flutter devices

4. **Run the app:**
   ```bash
   flutter run

5. **Build the APK:**
   ```bash
   flutter build apk --release
