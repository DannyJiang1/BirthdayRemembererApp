# RememberBirthday - iOS Birthday Tracker App

A beautiful and intuitive iOS application built with SwiftUI that helps users never forget important birthdays. The app features Firebase authentication, real-time data synchronization, and push notifications.

## Features

### 🔐 Authentication
- **User Registration**: Create new accounts with email and password
- **User Login**: Secure authentication with Firebase Auth
- **User Profile**: Store user information in Firestore
- **Auto-login**: Persistent authentication state

### 🎂 Birthday Management
- **Add Birthdays**: Add birthdays with names, dates, and optional notes
- **Edit Birthdays**: Update existing birthday information
- **Delete Birthdays**: Remove birthdays with confirmation
- **Real-time Sync**: All data syncs automatically across devices

### 📅 Smart Organization
- **Today's Birthdays**: Special highlighting for birthdays happening today
- **Upcoming Birthdays**: View birthdays in the next 30 days
- **Age Calculation**: Automatically calculates and displays ages
- **Days Until**: Shows how many days until each birthday

### 🔔 Notifications
- **Push Notifications**: Get notified on birthday days
- **Smart Scheduling**: Automatically schedules notifications for upcoming birthdays
- **Permission Handling**: Graceful permission request flow

### 🎨 Beautiful UI
- **Modern Design**: Clean, intuitive interface with SwiftUI
- **Color-coded Cards**: Different colors for today's vs upcoming birthdays
- **Responsive Layout**: Works on all iOS device sizes
- **Smooth Animations**: Delightful user interactions

## Technical Architecture

### Models
- **User**: Firebase user data with name, email, and creation date
- **BirthdayItem**: Birthday data with name, date, notes, and calculated properties
- **Item**: Legacy SwiftData model (kept for compatibility)

### ViewModels
- **MainViewModel**: Handles authentication state and user data
- **LoginViewModel**: Manages login functionality and validation
- **RegisterViewModel**: Handles user registration and data persistence
- **BirthdayItemViewModel**: Manages birthday CRUD operations
- **AddBirthdayViewModel**: Handles adding new birthdays
- **UpcomingBirthdayViewModel**: Manages upcoming birthday display and notifications

### Views
- **MainView**: Root view with authentication flow
- **HomeView**: Main dashboard after login
- **LoginView**: User login interface
- **RegisterView**: User registration interface
- **AddBirthdayView**: Form for adding new birthdays
- **BirthdayItemView**: Individual birthday display with edit/delete
- **UpcomingBirthdayView**: Dedicated view for upcoming birthdays
- **HeaderView**: Reusable header component
- **ButtonView**: Custom button component

## Firebase Integration

### Authentication
- Uses Firebase Auth for user authentication
- Supports email/password login and registration
- Automatic session management and persistence

### Firestore Database
- **Users Collection**: Stores user profile information
- **Birthdays Collection**: Stores birthday data with user association
- Real-time listeners for automatic data synchronization
- Proper data validation and error handling

### Security Rules (Recommended)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Birthdays are user-specific
    match /birthdays/{birthdayId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

## Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- Firebase project with Authentication and Firestore enabled

### Installation
1. Clone the repository
2. Open `RememberBirthday.xcodeproj` in Xcode
3. Add your `GoogleService-Info.plist` to the project
4. Configure Firebase Authentication and Firestore in your Firebase console
5. Build and run the project

### Firebase Configuration
1. Create a new Firebase project
2. Enable Authentication with Email/Password provider
3. Enable Firestore Database
4. Download `GoogleService-Info.plist` and add to project
5. Configure Firestore security rules (see above)

## Usage

### Getting Started
1. Launch the app
2. Create a new account or sign in
3. Add your first birthday by tapping the "+" button
4. View upcoming birthdays on the main screen
5. Enable notifications when prompted

### Adding Birthdays
1. Tap the "+" button on the main screen
2. Enter the person's name
3. Select their birthday date
4. Add optional notes
5. Tap "Add Birthday"

### Managing Birthdays
- **Edit**: Long press on a birthday card and select "Edit"
- **Delete**: Long press on a birthday card and select "Delete"
- **View Details**: Tap on any birthday card to see full information

## Key Features Explained

### Age Calculation
The app automatically calculates ages based on birth dates and shows:
- Current age
- Age they'll turn on their next birthday
- Days until their next birthday

### Notification System
- Automatically schedules notifications for upcoming birthdays
- Requests permission on first launch
- Schedules up to 10 upcoming birthday notifications
- Notifications appear on the actual birthday

### Data Persistence
- All data is stored in Firebase Firestore
- Real-time synchronization across devices
- Offline support with automatic sync when online
- Secure user-specific data access

## Future Enhancements

- [ ] Photo support for birthday contacts
- [ ] Birthday gift tracking
- [ ] Social sharing features
- [ ] Calendar integration
- [ ] Reminder customization
- [ ] Birthday statistics and insights
- [ ] Dark mode support
- [ ] Widget support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support or questions, please open an issue in the GitHub repository.

---

Built with ❤️ using SwiftUI and Firebase
