# FutCoach - Firebase & HealthKit Setup Guide

## ⚠️  Required Setup Steps

### 1. Firebase Configuration

You need to configure Firebase for authentication and Firestore database:

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Add project" and follow the wizard
   - Choose a project name (e.g., "FutCoach")

2. **Enable Authentication**
   - In Firebase Console, go to "Authentication"
   - Click "Get Started"
   - Enable "Email/Password" sign-in method

3. **Create Firestore Database**
   - Go to "Firestore Database"
   - Click "Create database"
   - Start in "Test mode" (you can change rules later)
   - Choose a location close to your users

4. **Download Configuration File**
   - Go to Project Settings (gear icon)
   - Scroll to "Your apps" section
   - Click iOS icon to add an iOS app
   - Register bundle ID: `com.yourcompany.futcoach` (or your own)
   - Download `GoogleService-Info.plist`
   - **IMPORTANT**: Replace the placeholder file at `/futcoach/GoogleService-Info.plist` with your downloaded file

5. **Add Firebase SDK**
   - Open your project in Xcode
   - Go to File → Add Package Dependencies
   - Enter: `https://github.com/firebase/firebase-ios-sdk`
   - Select version 10.0.0 or later
   - Add these packages:
     * FirebaseAuth
     * FirebaseFirestore
     * FirebaseCore

### 2. HealthKit Configuration

1. **Enable HealthKit Capability**
   - Open project in Xcode
   - Select your target → "Signing & Capabilities"
   - Click "+ Capability"
   - Add "HealthKit"

2. **Add Privacy Descriptions**
   - Open `Info.plist`
   - Add these keys:
     ```xml
     <key>NSHealthShareUsageDescription</key>
     <string>FutCoach needs access to your health data to track your fitness progress and generate personalized training plans.</string>
     <key>NSHealthUpdateUsageDescription</key>
     <string>FutCoach needs permission to save your manually entered health data.</string>
     ```

### 3. AI Service (Optional)

The app includes an AIService for generating training plans via Firebase Functions.

1. **Set up Firebase Functions**
   - Install Firebase CLI: `npm install -g firebase-tools`
   - Login: `firebase login`
   - Initialize functions: `firebase init functions`

2. **Update Endpoint URL**
   - Open `Services/AIService.swift`
   - Replace `baseURL` with your actual Firebase Functions endpoint

3. **Deploy Function** (example endpoint):
   ```javascript
   exports.generateTrainingPlan = functions.https.onRequest(async (req, res) => {
     const { user_id, health_data } = req.body;
     // Your AI/ML logic here
     res.json({ plan: "Your training plan text", week_number: 1 });
   });
   ```

### 4. Testing

**Note**: HealthKit only works on physical iOS devices, not the simulator.

1. **Build and Run**
   - Connect a physical iPhone
   - Select it as thetarget device
   - Run the app (⌘R)

2. **Test Authentication**
   - Sign up with email/password
   - Select Player or Coach role
   - Sign out and sign in again

3. **Test HealthKit (Player only)**
   - Grant HealthKit permissions when prompted
   - Tap "Sync" button on dashboard
   - Verify health data appears

## Project Structure

```
futcoach/
├── App/
│   └── futcoachApp.swift (Entry point with Firebase init)
├── Models/
│   ├── User.swift
│   ├── DailyStats.swift
│   ├── TrainingPlan.swift
│   └── HealthData.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── RoleSelectionViewModel.swift
│   ├── PlayerDashboardViewModel.swift
│   ├── CoachDashboardViewModel.swift
│   └── HealthDataViewModel.swift
├── Views/
│   ├── Authentication/
│   ├── Player/
│   ├── Coach/
│   └── Components/
├── Repositories/
│   ├── AuthRepository.swift
│   ├── UserRepository.swift
│   └── DailyStatsRepository.swift
├── Services/
│   ├── FirebaseService.swift
│   ├── HealthKitManager.swift
│   └── AIService.swift
└── Utilities/
    └── Extensions.swift
```

## Troubleshooting

- **Build Error: "No such module 'FirebaseCore'"**
  - Make sure you added Firebase packages via Swift Package Manager
  - Clean build folder (⇧⌘K) and rebuild

- **HealthKit not working**
  - Ensure HealthKit capability is enabled
  - Test on a physical device (not simulator)
  - Check privacy descriptions in Info.plist

- **Firebase Authentication failing**
  - Verify `GoogleService-Info.plist` is in project
  - Check bundle ID matches Firebase console
  - Enable Email/Password auth in Firebase Console

## Next Steps

1. Customize bundle ID and app name
2. Set up Firebase project and download config
3. Configure HealthKit capabilities
4. Deploy Firebase Functions for AI training plans
5. Test on physical device
6. Customize UI colors and branding
