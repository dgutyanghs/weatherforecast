import Foundation

struct WeatherData {
    let temperature: Int
    let condition: String
    let description: String
    let humidity: Int
    let windSpeed: Int
    let visibility: Int
}

struct DailyForecast {
    let day: String
    let condition: String
    let highTemp: Int
    let lowTemp: Int
    let icon: String
}

// MARK: - OpenWeatherMap API Response Models
struct OpenWeatherResponse: Codable {
    let main: MainWeather
    let weather: [Weather]
    let wind: Wind
    let visibility: Int
    let name: String
}

struct MainWeather: Codable {
    let temp: Double
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
}

struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: TimeInterval
    let main: MainWeather
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather
    }
}

class WeatherManager: ObservableObject {
    @Published var currentWeather: WeatherData
    @Published var weeklyForecast: [DailyForecast]
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Configuration from Config.swift
    private let apiKey = Config.openWeatherMapAPIKey
    private let baseURL = Config.openWeatherMapBaseURL
    
    init() {
        // Default data while loading
        self.currentWeather = WeatherData(
            temperature: 22,
            condition: "多云",
            description: "甲辰龙年三月初三，清明",
            humidity: 50,
            windSpeed: 10,
            visibility: 10
        )
        
        self.weeklyForecast = [
            DailyForecast(day: "今天", condition: "多云", highTemp: 22, lowTemp: 10, icon: "cloud.sun"),
            DailyForecast(day: "周一", condition: "多云", highTemp: 22, lowTemp: 10, icon: "cloud.sun"),
            DailyForecast(day: "周二", condition: "多云", highTemp: 22, lowTemp: 10, icon: "cloud.sun"),
            DailyForecast(day: "周三", condition: "多云", highTemp: 22, lowTemp: 10, icon: "cloud.sun"),
            DailyForecast(day: "周四", condition: "多云", highTemp: 22, lowTemp: 10, icon: "cloud.sun"),
            DailyForecast(day: "周五", condition: "多云", highTemp: 22, lowTemp: 10, icon: "cloud.sun"),
            DailyForecast(day: "周六", condition: "多云", highTemp: 22, lowTemp: 10, icon: "cloud.sun"),
            DailyForecast(day: "周日", condition: "多云", highTemp: 22, lowTemp: 10, icon: "cloud.sun")
        ]
    }
    
    func fetchWeather(for city: String = Config.defaultCity) {
        guard Config.isAPIKeyConfigured else {
            print("⚠️ Please add your OpenWeatherMap API key to Config.swift")
            print("📝 Get your free API key from: https://openweathermap.org/api")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Fetch current weather
        fetchCurrentWeather(for: city)
        
        // Fetch 5-day forecast
        fetchForecast(for: city)
    }
    
    private func fetchCurrentWeather(for city: String) {
        let urlString = "\(baseURL)/weather?q=\(city)&appid=\(apiKey)&units=\(Config.temperatureUnit)&lang=\(Config.language)"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
                self.isLoading = false
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let weatherResponse = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
                    self?.updateCurrentWeather(from: weatherResponse)
                } catch {
                    self?.errorMessage = "Failed to decode weather data: \(error.localizedDescription)"
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
    
    private func fetchForecast(for city: String) {
        let urlString = "\(baseURL)/forecast?q=\(city)&appid=\(apiKey)&units=\(Config.temperatureUnit)&lang=\(Config.language)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.updateForecast(from: forecastResponse)
                }
            } catch {
                print("Forecast decoding error: \(error)")
            }
        }.resume()
    }
    
    private func updateCurrentWeather(from response: OpenWeatherResponse) {
        let chineseCondition = translateWeatherCondition(response.weather.first?.main ?? "Clear")
        
        currentWeather = WeatherData(
            temperature: Int(response.main.temp.rounded()),
            condition: chineseCondition,
            description: "甲辰龙年三月初三，清明", // Keep traditional calendar
            humidity: response.main.humidity,
            windSpeed: Int((response.wind.speed * 3.6).rounded()), // Convert m/s to km/h
            visibility: response.visibility / 1000 // Convert m to km
        )
    }
    
    private func updateForecast(from response: ForecastResponse) {
        let calendar = Calendar.current
        let today = Date()
        
        // Group forecasts by day and get daily highs/lows
        var dailyForecasts: [String: (high: Double, low: Double, condition: String)] = [:]
        
        for item in response.list {
            let date = Date(timeIntervalSince1970: item.dt)
            let dayKey = calendar.dateInterval(of: .day, for: date)?.start ?? date
            let dayString = formatDay(dayKey, relativeTo: today)
            
            let temp = item.main.temp
            let condition = item.weather.first?.main ?? "Clear"
            
            if let existing = dailyForecasts[dayString] {
                dailyForecasts[dayString] = (
                    high: max(existing.high, temp),
                    low: min(existing.low, temp),
                    condition: existing.condition
                )
            } else {
                dailyForecasts[dayString] = (high: temp, low: temp, condition: condition)
            }
        }
        
        // Convert to DailyForecast array
        let sortedDays = ["今天", "周一", "周二", "周三", "周四", "周五", "周六", "周日"]
        
        weeklyForecast = sortedDays.compactMap { day in
            guard let forecast = dailyForecasts[day] else { return nil }
            
            return DailyForecast(
                day: day,
                condition: translateWeatherCondition(forecast.condition),
                highTemp: Int(forecast.high.rounded()),
                lowTemp: Int(forecast.low.rounded()),
                icon: getWeatherIcon(forecast.condition)
            )
        }
        
        // Fill remaining days if needed
        while weeklyForecast.count < 8 {
            weeklyForecast.append(
                DailyForecast(
                    day: "周\(weeklyForecast.count)",
                    condition: "多云",
                    highTemp: 22,
                    lowTemp: 15,
                    icon: "cloud.sun"
                )
            )
        }
    }
    
    private func translateWeatherCondition(_ condition: String) -> String {
        switch condition.lowercased() {
        case "clear": return "晴朗"
        case "clouds": return "多云"
        case "rain": return "雨"
        case "drizzle": return "小雨"
        case "thunderstorm": return "雷雨"
        case "snow": return "雪"
        case "mist", "fog": return "雾"
        case "haze": return "霾"
        default: return "多云"
        }
    }
    
    private func getWeatherIcon(_ condition: String) -> String {
        switch condition.lowercased() {
        case "clear": return "sun.max"
        case "clouds": return "cloud.sun"
        case "rain": return "cloud.rain"
        case "drizzle": return "cloud.drizzle"
        case "thunderstorm": return "cloud.bolt"
        case "snow": return "cloud.snow"
        case "mist", "fog": return "cloud.fog"
        default: return "cloud.sun"
        }
    }
    
    private func formatDay(_ date: Date, relativeTo today: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDate(date, inSameDayAs: today) {
            return "今天"
        }
        
        let weekday = calendar.component(.weekday, from: date)
        let weekdays = ["", "周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        return weekdays[weekday]
    }
}