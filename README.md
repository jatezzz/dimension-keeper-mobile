# Dimension Keeper App

A Flutter application for exploring and managing characters from the Rick and Morty universe. The app features character details, the ability to save favorite characters, and search functionality.

![image](./content.gif)

<img src="https://github.com/user-attachments/assets/e374aa83-d613-4fe0-97e3-ddc1cbd21bd7" width="200" />

<img src="https://github.com/user-attachments/assets/7ed00d3e-dfef-4276-a544-f818308ee25b" width="200" />

---

## Architecure

![ZLDDRy8m3BttLrWzRGV-maIX0rKQ4g93Eo0E9h4W8asYD6Mhfltt1KhJyYMHK_By_9vjESFIeNLL8QDoBvH1YmKmNHYjIBdSrPB04dEejfAYo23RuvOWNWYs1rGSPjgw6YQoSeui9CR4y1k1FwiP2dK4u6M6FYPG-iVh6WQ3DrZDhJu8JhPSFq5UPf0pIwGy-qGF1K8SX5hVaznuvnjXNgWDdvK2lY2ZI-6qhPi2_cw4EzCB](https://github.com/user-attachments/assets/12b89025-13a3-4f3a-beea-f2ef9a28749f)

---

## 🚀 Features

- **Explore Characters**: Browse through a list of characters with details like name, status, species, and more.
- **Save Favorites**: Mark characters as favorites and access them in a dedicated saved section.
- **Search**: Search for characters by name to quickly find your favorites.
- **Edit Characters**: Update character details dynamically.

---

## 📦 Dependencies

- **Flutter SDK**
- **Provider**: State management.
- **Mockito**: For mocking during tests.
- **Integration Test**: For end-to-end testing.
- **Flutter Dotenv**: For managing environment variables.
- **Build Runner**: For code generation.

---

## 🛠️ Installation

### 1. Clone the Repository
```bash
git clone https://github.com/jatezzz/rick-and-morty-app.git
cd rick-and-morty-app
```
### 2. Install Dependencies
Run the following command to install Flutter dependencies:

```bash
flutter pub get
```
### 3. Generate Code
Before running the tests, generate the necessary files using build_runner:

```bash
flutter pub run build_runner build
```
4. Run the App
Start the app on an emulator or a physical device:

```bash
flutter run
```

### 🧪 Testing
Run all unit tests using:

```bash
flutter test
```

### 🛠️ Environment Variables
The app uses environment variables for configuration. Add a .env file in the root directory with the following structure:
```bash
BASE_URL=https://your-api-url.com
```
