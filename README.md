# Thmanyah 📱

A modern iOS application built with SwiftUI and UIKit, designed to provide an engaging content discovery and search experience. Thmanyah features a beautiful dark theme with Arabic language support and follows iOS design guidelines.

## ✨ Features

- **🏠 Home View**: Curated content sections with beautiful cards and shimmer loading effects
- **🔍 Search Functionality**: Advanced search with debounced input and real-time results
- **🌙 Dark Theme**: Elegant dark mode design with custom color schemes
- **🇸🇦 Arabic Support**: Full Arabic language support with IBM Plex Sans Arabic fonts
- **📱 Modern UI**: SwiftUI and UIKit integration with custom design system
- **⚡ Performance**: Optimized networking, image loading, and smooth animations
- **🧪 Testing**: Comprehensive unit tests and UI tests

## 🏗️ Architecture

Thmanyah follows a clean architecture pattern with clear separation of concerns:

```
Thmanyah/
├── App/                    # App entry point and configuration
├── Features/              # Feature-specific views and view models
│   ├── Home/             # Home screen implementation
│   └── Search/           # Search functionality
├── Domain/               # Business logic and use cases
├── Data/                 # Data layer and repositories
├── Networking/           # Network client and API handling
├── Models/               # Data models
├── DesignSystem/         # UI components and theming
├── Utils/                # Helper utilities
└── Resources/            # Fonts and assets
```

### Key Components

- **MVVM Pattern**: ViewModels manage business logic and state
- **Repository Pattern**: Clean data access abstraction
- **Use Cases**: Business logic encapsulation
- **Dependency Injection**: SwiftUI environment objects for state management

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/Thmanyah.git
cd Thmanyah
```

2. Open the project in Xcode:
```bash
open Thmanyah.xcodeproj
```

3. Configure API endpoints in `Config/Production.xcconfig`:
```xcconfig
API_BASE_URL = https://your-api-endpoint.com
SEARCH_BASE_URL = https://your-search-endpoint.com
```

4. Build and run the project (⌘+R)

## 🎨 Design System

### Colors
- **Primary**: Custom accent colors for brand identity
- **Background**: Dark theme with subtle gradients
- **Text**: High contrast for readability
- **Interactive**: Clear visual feedback states

### Typography
- **IBM Plex Sans Arabic**: Complete font family for Arabic text
- **System Fonts**: Native iOS fonts for English text
- **Hierarchy**: Clear typography scale for content organization

### Components
- **ContentCardView**: Reusable content display cards
- **TagCapsule**: Interactive tag components
- **Shimmer**: Loading state animations
- **SectionHeader**: Content section organization

## 🔧 Configuration

### Environment Setup
The app uses configuration files for different environments:

- `Production.xcconfig`: Production API endpoints
- `AppConfig.swift`: Runtime configuration management

### Font Configuration
Custom Arabic fonts are automatically loaded and available throughout the app:

```swift
// Available font weights
IBMPlexSansArabic-Thin
IBMPlexSansArabic-ExtraLight
IBMPlexSansArabic-Light
IBMPlexSansArabic-Regular
IBMPlexSansArabic-Medium
IBMPlexSansArabic-SemiBold
IBMPlexSansArabic-Bold
```

## 📱 Features in Detail

### Home View
- **Dynamic Sections**: Content organized into logical sections
- **Content Cards**: Rich media display with episode counts and duration
- **Shimmer Loading**: Smooth loading states for better UX
- **Pull to Refresh**: Content refresh functionality

### Search View
- **Debounced Input**: Optimized search performance
- **Real-time Results**: Instant search feedback
- **Content Table**: Organized search results display
- **UIKit Integration**: Seamless SwiftUI/UIKit bridge

### Networking
- **HTTP Client**: Robust network layer with error handling
- **Image Loading**: Efficient image caching and loading
- **API Error Handling**: Comprehensive error management
- **Request Management**: Structured API request handling

## 🧪 Testing

### Unit Tests
- **Model Decoding**: Data model validation tests
- **ViewModels**: Business logic testing
- **Network Layer**: API client testing
- **Utilities**: Helper function testing

### UI Tests
- **App Launch**: Launch performance testing
- **User Flows**: End-to-end user journey testing

### Running Tests
```bash
# Run all tests
⌘+U

# Run specific test target
Product > Test > ThmanyahTests
```

## 📦 Dependencies

The project uses native iOS frameworks and custom implementations:

- **SwiftUI**: Modern declarative UI framework
- **UIKit**: Traditional iOS UI components
- **Foundation**: Core iOS functionality
- **Combine**: Reactive programming (if needed)

## 🚀 Performance Features

- **Image Caching**: Efficient image loading and caching
- **Debounced Search**: Optimized search input handling
- **Lazy Loading**: Content loaded on demand
- **Memory Management**: Proper resource cleanup

## 🔒 Security

- **HTTPS Only**: Secure network communication
- **Input Validation**: User input sanitization
- **Error Handling**: Secure error messages
- **Configuration**: Environment-based API endpoints

## 📱 Device Support

- **iPhone**: iOS 17.0+ (iPhone 15 Pro Max and earlier)
- **iPad**: iPadOS 17.0+ (iPad Pro and earlier)
- **Orientation**: Portrait and landscape support
- **Accessibility**: VoiceOver and Dynamic Type support

## 🎯 Future Enhancements

- [ ] Offline content caching
- [ ] Push notifications
- [ ] User authentication
- [ ] Content sharing
- [ ] Analytics integration
- [ ] A/B testing framework

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Swift API Design Guidelines
- Use meaningful variable and function names
- Add comprehensive documentation
- Include unit tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Developer**: Abdelrahman youssef
- **Created**: August 20, 2025
- **Platform**: iOS

## 📞 Support

For support and questions:
- Create an issue in the GitHub repository
- Contact the development team
- Check the documentation

---

