# Gym Management System 💪⚙️

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**Gym Management System** is a comprehensive Flutter-based application for managing gym operations. It connects to **Firebase Firestore** for real-time data and uses **Bloc/Cubit** state management. The app features both **Admin** and **Member** modes for a complete gym management experience.

## ✨ Features

- **Admin/User Switch**: Toggle between admin and member views — admins manage everything, members browse their data.
- **Member Management**: Add, edit, delete members with subscription details (fitness/gym/private).
- **Attendance Tracking**: Record attendance by scanning member QR codes or manual phone lookup; view and delete attendance history.
- **Subscription Management**: Track subscription start/end dates, remaining days, and renewal history.
- **Store Management**: Add, edit, delete products (supplements & tools) with compressed base64 images.
- **Alerts & Notifications**: Send push notifications to all members via Firebase Cloud Messaging.
- **QR Code**: Each member has a unique QR code (phone-based) for quick attendance scanning.
- **Profile Management**: Members can update their profile photo.
- **Arabic RTL UI**: The entire interface is in Arabic for a seamless local experience.

## 📱 Screenshots


### Admin View

https://github.com/user-attachments/assets/066f7ff6-ccd5-4dab-ba69-7f2ba675e4df


<img width="360" height="780" alt="Admin view" src="https://github.com/user-attachments/assets/57c38b3d-30a1-435b-ae94-720a604a5d46" /> 

### User View

https://github.com/user-attachments/assets/12b8d07e-d2c0-40dc-bd97-850963f0c58d

| Subscription | Market | Profile | Home |
|--------------|--------|---------|------|
<img width="360" height="780" alt="Subscription" src="https://github.com/user-attachments/assets/f5d024f0-5d0f-4be4-9420-779d55b5d4ba" />| <img width="360" height="780" alt="Market" src="https://github.com/user-attachments/assets/28a9045d-98cf-4d1f-bb3a-6565b7195cf8" />|<img width="360" height="780" alt="Profile" src="https://github.com/user-attachments/assets/b9f4b45f-d5dd-40eb-a76a-969a7e819341" />| <img width="360" height="780" alt="Home" src="https://github.com/user-attachments/assets/bb431e1b-59fb-4f9f-9157-97a6a6847a56" />

## ⚙️ App Structure

```
lib/
├── core/
│   ├── components/        # Shared widgets (GlassWidget, CustomButton, etc.)
│   ├── constants/         # App constants and assets
│   ├── DI/               # Service locator (get_it)
│   ├── helper/           # Utility helpers (image cache, validators)
│   ├── routes/           # GoRouter configuration
│   ├── service/          # Firebase, FCM, local cache services
│   └── theme/            # App colors and theme
├── features/
│   ├── admin/            # Admin dashboard
│   │   ├── alerts/       # Alerts (CRUD + FCM push)
│   │   ├── dashboard/    # Admin shell with navigation
│   │   ├── market/       # Store products (admin CRUD)
│   │   └── members/      # Members CRUD + attendance + QR scan
│   ├── auth/             # Login (admin email + member name/phone)
│   ├── data/             # Shared data models (MarketItem, etc.)
│   └── user/             # Member-facing features
│       ├── general/      # Home + bottom navigation shell
│       ├── profile/      # Profile update + QR code
│       ├── settings/     # Settings + subscription history
│       ├── subscription/ # Subscription status
│       └── market/       # Store browsing (user view)
```

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter (Dart) |
| **State Management** | Bloc / Cubit |
| **Routing** | GoRouter |
| **Backend** | Firebase Firestore |
| **Authentication** | Firebase Authentication |
| **Push Notifications** | Firebase Cloud Messaging (HTTP v1) |
| **Dependency Injection** | get_it (Service Locator) |
| **Local Storage** | SharedPreferences |
| **Image Handling** | Compressed base64 + in-memory cache |
| **QR Code** | qr_flutter + mobile_scanner |

## 🔧 Key Decisions

- **Images stored as compressed base64 in Firestore** — avoids the cost of Firebase Storage while keeping documents small via client-side compression (`maxWidth: 600`, `maxHeight: 600`, `imageQuality: 30`).
- **QR codes encode the member's phone number** — the phone number is also the Firestore document ID, enabling quick lookups on scan.
- **All cubits check cache before emitting loading state** — prevents UI flicker when navigating between admin pages.
- **Arabic RTL UI** — fully localized for Arabic-speaking gym owners and members.

## 👤 Author

**Muhammad Khaled** — [LinkedIn](https://www.linkedin.com/in/muhammad-khaled-811a9431a/) | [GitHub](https://github.com/MuhammadDev01) | [protofolio](https://muhammaddev01.github.io/Muhammad-Khaled/)

📧 muhammadbenkhaled@gmail.com

## 💬 Feedback

If you have any feedback, please reach out at muhammadbenkhaled@gmail.com

---

**Happy Coding!** 🚀
