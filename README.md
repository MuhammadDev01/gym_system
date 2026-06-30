# Gym System

A comprehensive Flutter-based gym management application with Arabic RTL UI for managing members, subscriptions, attendance, store products, and alerts.

## Features

### Admin Panel
- **Member Management** — Add, edit, delete members with subscription details
- **Attendance Recording** — Mark attendance by phone number; view attendance history per member with delete support
- **Store Management** — Add, edit, delete products (supplements/tools) with images
- **Alerts Management** — Send push notifications to all members via Firebase Cloud Messaging
- **Subscription History** — View all subscription changes per member

### Member App
- **Home** — View remaining subscription days, profile info, and latest alerts
- **Subscription** — Check subscription status and type
- **Profile** — View/edit profile info and QR code
- **Store** — Browse products (supplements & tools) with filtering
- **Settings** — App settings and subscription history

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter (Dart) |
| State Management | Bloc / Cubit |
| Routing | GoRouter |
| Backend | Firebase Firestore |
| Auth | Firebase Authentication |
| Push Notifications | Firebase Cloud Messaging (HTTP v1) |
| Dependency Injection | get_it (Service Locator) |
| Local Storage | SharedPreferences |
| Images | Base64 storage in Firestore |

## Project Structure

```
lib/
├── core/
│   ├── components/        # Shared widgets (GlassWidget, CustomButton, etc.)
│   ├── constants/         # App constants and assets
│   ├── DI/               # Service locator setup
│   ├── helper/           # Utility helpers (image cache, validators, etc.)
│   ├── routes/           # GoRouter configuration
│   ├── service/          # Firebase, FCM, local cache services
│   └── theme/            # App colors and theme
├── features/
│   ├── admin/            # Admin dashboard views
│   ├── alerts/           # Alerts feature (CRUD + display)
│   ├── auth/             # Authentication (member login + admin login)
│   ├── market/           # Store feature (admin + user views)
│   ├── members/          # Members feature (CRUD + attendance)
│   └── user/             # User-facing features
│       ├── general/      # Home tab, bottom navigation
│       ├── profile/      # Profile management
│       ├── settings/     # Settings, subscription history
│       └── subscription/ # Subscription status
```

## Getting Started

### Prerequisites

- Flutter SDK (see `pubspec.yaml` for version)
- Firebase project with Firestore, Auth, and Messaging enabled
- Android Studio / VS Code

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/MuhammadDev01/gym_system.git
   cd gym_system
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**:
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the appropriate directories
   - Enable Email/Password authentication in Firebase Console

4. **FCM Notifications (optional)**:
   - Place your Firebase service account JSON in `assets/cloud_messages.json`
   - This file is gitignored — never commit it

5. Run the app:
   ```bash
   flutter run
   ```

### Build APK

```bash
flutter build apk --release
```

## Performance Notes

- Images are stored as base64 strings in Firestore and cached in-memory via `BaseImageCache` to avoid re-decoding on rebuilds
- All list views use `addAutomaticKeepAlives: false` to reduce memory
- `buildWhen`/`listenWhen` filters are applied to all `BlocBuilder`/`BlocConsumer` widgets

## Security

- Service account credentials (`assets/cloud_messages.json`) are gitignored
- Firebase API keys should be restricted in the Firebase Console
- Environment-specific configuration is handled via Firebase project settings

## License

All rights reserved.
