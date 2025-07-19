# 🌤️ WeatherApp - iOS Weather Application

A beautiful iOS weather application built with SwiftUI, featuring real-time weather data, elegant Chinese UI design, and stunning mountain landscape illustrations.

## ✨ Features

### 🏠 Main Features

- **Real-time Weather Data** - Powered by OpenWeatherMap API
- **Beautiful UI Design** - Elegant Chinese interface with mountain landscape
- **4-Tab Navigation** - Home, Cities, Details, and Settings
- **Chinese Localization** - Full Chinese language support
- **Custom Illustrations** - Hand-crafted mountain landscape views

### 📱 App Screens

1. **首页 (Home)** - Main weather display with mountain illustration
2. **城市 (Cities)** - City selection and management
3. **详情 (Details)** - Detailed weather information and forecasts
4. **设置 (Settings)** - App configuration and preferences

### 🌡️ Weather Data

- Current temperature and conditions
- 7-day weather forecast
- Humidity, wind speed, and visibility
- Air quality information
- Hourly temperature charts

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0 or later
- Swift 5.9 or later

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd weatherforcast
   ```

2. **Set up API Key**

   ```bash
   # Copy the sample config file
   cp Config.sample.swift WeatherApp/Config.swift
   ```

3. **Get OpenWeatherMap API Key**

   - Visit [OpenWeatherMap API](https://openweathermap.org/api)
   - Sign up for a free account
   - Get your API key from the dashboard

4. **Configure API Key**

   - Open `WeatherApp/Config.swift`
   - Replace `YOUR_API_KEY_HERE` with your actual API key:

   ```swift
   static let openWeatherMapAPIKey = "your_actual_api_key_here"
   ```

5. **Build and Run**
   - Open `WeatherApp.xcodeproj` in Xcode
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## 🏗️ Project Structure

```
WeatherApp/
├── WeatherApp/
│   ├── WeatherApp.swift          # App entry point
│   ├── ContentView.swift         # Main UI with tab navigation
│   ├── MountainView.swift        # Custom mountain landscape
│   ├── WeatherModel.swift        # Data models and API integration
│   └── Config.swift              # Configuration (not in Git)
├── WeatherApp.xcodeproj/         # Xcode project file
├── Config.sample.swift           # Configuration template
├── README.md                     # This file
└── .gitignore                    # Git ignore rules
```

## 🔧 Configuration

### API Settings

Edit `WeatherApp/Config.swift` to customize:

```swift
static let defaultCity = "Beijing"           // Default city
static let temperatureUnit = "metric"       // metric, imperial, kelvin
static let language = "zh_cn"               // Language code
static let apiTimeout: TimeInterval = 10.0  // Request timeout
```

### Debug Settings

```swift
#if DEBUG
static let enableDebugLogging = true        // Enable debug logs
static let mockDataEnabled = false          // Use mock data instead of API
#endif
```

## 🌐 API Integration

This app uses the [OpenWeatherMap API](https://openweathermap.org/api) for weather data:

- **Current Weather API** - Real-time weather conditions
- **5-Day Forecast API** - Extended weather predictions
- **Free Tier** - 1,000 API calls per day
- **Chinese Language Support** - Weather descriptions in Chinese

### API Endpoints Used

- `GET /weather` - Current weather data
- `GET /forecast` - 5-day weather forecast

## 🎨 Design Features

### Visual Elements

- **Mountain Landscape** - Custom SwiftUI shapes creating layered mountain views
- **Chinese Typography** - Proper Chinese font weights and spacing
- **Mint Color Scheme** - Consistent green accent colors throughout
- **Gradient Backgrounds** - Subtle gradients for depth and elegance

### UI Components

- Custom weather detail cards
- Animated temperature charts
- Floating action buttons
- Settings toggles and navigation rows

## 🔒 Security

- **API Key Protection** - Config.swift is excluded from Git
- **Sample Configuration** - Config.sample.swift provides template
- **Environment Separation** - Debug vs production configurations
- **Input Validation** - Proper API key validation before requests

## 🛠️ Development

### Adding New Cities

1. Update the cities array in `CitiesView`
2. Add proper temperature data
3. Implement city selection logic

### Customizing Weather Conditions

1. Edit `translateWeatherCondition()` in WeatherModel.swift
2. Add new condition mappings
3. Update corresponding weather icons

### Adding New Settings

1. Add properties to Config.swift
2. Create UI elements in SettingsView
3. Implement setting persistence if needed

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

If you have any questions or issues:

1. Check the [Issues](../../issues) page
2. Create a new issue with detailed information
3. Include screenshots if reporting UI problems

## 🙏 Acknowledgments

- [OpenWeatherMap](https://openweathermap.org/) for weather data API
- Apple for SwiftUI framework
- Chinese weather app design inspiration

---

**Made with ❤️ and SwiftUI**
