import Foundation

// MARK: - Configuration Template
// Copy this file to WeatherApp/Config.swift and add your actual API key

struct Config {
    // MARK: - API Configuration
    
    /// OpenWeatherMap API Key
    /// Get your free API key from: https://openweathermap.org/api
    /// Sign up for a free account and replace the placeholder below
    static let openWeatherMapAPIKey = "YOUR_API_KEY_HERE"
    
    // MARK: - API Endpoints
    static let openWeatherMapBaseURL = "https://api.openweathermap.org/data/2.5"
    
    // MARK: - Default Settings
    static let defaultCity = "Beijing"
    static let temperatureUnit = "metric" // metric, imperial, kelvin
    static let language = "zh_cn" // Chinese Simplified
    
    // MARK: - App Configuration
    static let maxForecastDays = 8
    static let apiTimeout: TimeInterval = 10.0
    
    // MARK: - Validation
    static var isAPIKeyConfigured: Bool {
        return !openWeatherMapAPIKey.contains("YOUR_API_KEY_HERE") && !openWeatherMapAPIKey.isEmpty
    }
}

// MARK: - Development/Debug Configuration
#if DEBUG
extension Config {
    static let enableDebugLogging = true
    static let mockDataEnabled = false // Set to true to use mock data instead of API
}
#endif