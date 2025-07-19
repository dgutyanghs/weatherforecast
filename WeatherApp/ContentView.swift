import SwiftUI

struct ContentView: View {
    @StateObject private var weatherManager = WeatherManager()
    
    var body: some View {
        TabView {
            // 首页 - Home
            HomeView()
                .environmentObject(weatherManager)
                .tabItem {
                    Image(systemName: "house")
                    Text("首页")
                }
            
            // 城市 - Cities
            CitiesView()
                .tabItem {
                    Image(systemName: "location")
                    Text("城市")
                }
            
            // 详情 - Details
            DetailsView()
                .environmentObject(weatherManager)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("详情")
                }
            
            // 设置 - Settings
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("设置")
                }
        }
        .accentColor(.mint)
        .onAppear {
            weatherManager.fetchWeather()
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header with location
                        HeaderView()
                        
                        // Mountain landscape illustration
                        MountainView()
                        
                        // Current weather
                        CurrentWeatherView(weather: weatherManager.currentWeather)
                        
                        // Weather details
                        WeatherDetailsView(weather: weatherManager.currentWeather)
                        
                        // Today and weekly forecast
                        ForecastView(forecasts: weatherManager.weeklyForecast)
                    }
                }
            }
        }
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("北京")
                .font(.title2)
                .fontWeight(.medium)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "line.horizontal.3")
                    .font(.title2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

struct CurrentWeatherView: View {
    let weather: WeatherData
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(weather.temperature)°")
                .font(.system(size: 72, weight: .thin))
                .foregroundColor(.primary)
            
            Text(weather.condition)
                .font(.title3)
                .fontWeight(.medium)
            
            Text(weather.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)
        }
        .padding(.vertical, 20)
    }
}

struct WeatherDetailsView: View {
    let weather: WeatherData
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 40) {
                WeatherDetailItem(title: "湿度", value: "\(weather.humidity)%")
                WeatherDetailItem(title: "风速", value: "\(weather.windSpeed)km/h")
            }
            
            WeatherDetailItem(title: "能见度", value: "\(weather.visibility)km")
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
    }
}

struct WeatherDetailItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3)
                .fontWeight(.medium)
        }
    }
}

struct ForecastView: View {
    let forecasts: [DailyForecast]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("今天")
                .font(.title3)
                .fontWeight(.medium)
                .padding(.horizontal, 20)
            
            ForecastRow(forecast: forecasts[0])
                .padding(.horizontal, 20)
            
            Text("一周预报")
                .font(.title3)
                .fontWeight(.medium)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            LazyVStack(spacing: 12) {
                ForEach(Array(forecasts.dropFirst().enumerated()), id: \.offset) { index, forecast in
                    ForecastRow(forecast: forecast)
                        .padding(.horizontal, 20)
                }
            }
        }
        .padding(.bottom, 100)
    }
}

struct ForecastRow: View {
    let forecast: DailyForecast
    
    var body: some View {
        HStack {
            Image(systemName: forecast.icon)
                .font(.title3)
                .foregroundColor(.mint)
                .frame(width: 30)
            
            Text(forecast.condition)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(forecast.highTemp)° / \(forecast.lowTemp)°")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// 城市 - Cities View
struct CitiesView: View {
    let cities = [
        CityWeather(name: "北京", temperature: 25),
        CityWeather(name: "上海", temperature: 28),
        CityWeather(name: "广州", temperature: 30),
        CityWeather(name: "深圳", temperature: 29),
        CityWeather(name: "成都", temperature: 26),
        CityWeather(name: "杭州", temperature: 27),
        CityWeather(name: "南京", temperature: 28),
        CityWeather(name: "武汉", temperature: 29),
        CityWeather(name: "天津", temperature: 26),
        CityWeather(name: "重庆", temperature: 31)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header image
                    AsyncImage(url: URL(string: "https://picsum.photos/400/200")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.mint.opacity(0.3))
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.mint)
                            )
                    }
                    .frame(height: 200)
                    .clipped()
                    
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(cities, id: \.name) { city in
                                CityRow(city: city)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                
                                if city.name != cities.last?.name {
                                    Divider()
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                    
                    Spacer()
                }
                
                // Floating add button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("城市")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CityRow: View {
    let city: CityWeather
    
    var body: some View {
        HStack {
            Text(city.name)
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            Text("\(city.temperature)°")
                .font(.title3)
                .fontWeight(.medium)
        }
    }
}

// 详情 - Details View
struct DetailsView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Current weather summary
                        VStack(spacing: 8) {
                            Text("北京")
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            Text("26°")
                                .font(.system(size: 48, weight: .thin))
                            
                            Text("多云")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            Text("今天，多云，最高28°，最低20°")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        // 未来几天
                        VStack(alignment: .leading, spacing: 16) {
                            Text("未来几天")
                                .font(.title3)
                                .fontWeight(.medium)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                DetailsForecastRow(day: "今天", condition: "多云", high: 28, low: 20)
                                DetailsForecastRow(day: "明天", condition: "多云", high: 29, low: 21)
                                DetailsForecastRow(day: "后天", condition: "多云", high: 30, low: 22)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // 每小时预报
                        VStack(alignment: .leading, spacing: 16) {
                            Text("每小时预报")
                                .font(.title3)
                                .fontWeight(.medium)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 8) {
                                Text("气温")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 20)
                                
                                Text("26°")
                                    .font(.system(size: 32, weight: .thin))
                                
                                Text("今天 +1%")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                // Temperature chart placeholder
                                HourlyChart()
                                    .frame(height: 100)
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        // 空气质量
                        VStack(alignment: .leading, spacing: 12) {
                            Text("空气质量")
                                .font(.title3)
                                .fontWeight(.medium)
                                .padding(.horizontal, 20)
                            
                            HStack {
                                Image(systemName: "wind")
                                    .font(.title3)
                                    .foregroundColor(.mint)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("AQI 50")
                                        .font(.body)
                                        .fontWeight(.medium)
                                    
                                    Text("空气质量一般")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("详情")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DetailsForecastRow: View {
    let day: String
    let condition: String
    let high: Int
    let low: Int
    
    var body: some View {
        HStack {
            Image(systemName: "sun.max")
                .font(.title3)
                .foregroundColor(.orange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(day)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text("\(condition)，最高\(high)°，最低\(low)°")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct HourlyChart: View {
    var body: some View {
        ZStack {
            // Simple wave chart
            Path { path in
                let width: CGFloat = 300
                let height: CGFloat = 60
                let points: [CGFloat] = [0.3, 0.7, 0.4, 0.8, 0.2, 0.9, 0.5]
                
                path.move(to: CGPoint(x: 0, y: height * (1 - points[0])))
                
                for (index, point) in points.enumerated() {
                    let x = (width / CGFloat(points.count - 1)) * CGFloat(index)
                    let y = height * (1 - point)
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(Color.mint, lineWidth: 2)
            
            // Time labels
            HStack {
                ForEach(["12:00", "13:00", "14:00", "15:00", "16:00", "17:00"], id: \.self) { time in
                    Text(time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    if time != "17:00" {
                        Spacer()
                    }
                }
            }
            .padding(.top, 80)
        }
    }
}

// 设置 - Settings View
struct SettingsView: View {
    @State private var weatherNotifications = false
    @State private var dataUpdateNotifications = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // 常规 section
                        SettingsSection(title: "常规") {
                            SettingsRow(title: "温度单位", subtitle: "显示温度的单位", value: "摄氏度")
                            SettingsRow(title: "风速单位", subtitle: "显示风速的单位", value: "千米/小时")
                            SettingsRow(title: "气压单位", subtitle: "显示气压的单位", value: "百帕")
                            SettingsRow(title: "降水量单位", subtitle: "显示降水量的单位", value: "毫米")
                            SettingsRow(title: "能见度单位", subtitle: "显示能见度的单位", value: "千米")
                            SettingsRow(title: "时间格式", subtitle: "显示时间的格式", value: "24小时")
                        }
                        
                        // 通知 section
                        SettingsSection(title: "通知") {
                            SettingsToggleRow(
                                title: "天气变化通知",
                                subtitle: "当天气发生变化时接收通知",
                                isOn: $weatherNotifications
                            )
                            SettingsToggleRow(
                                title: "数据更新通知",
                                subtitle: "当有新的天气数据更新时接收通知",
                                isOn: $dataUpdateNotifications
                            )
                        }
                        
                        // 外观 section
                        SettingsSection(title: "外观") {
                            SettingsRow(title: "外观", subtitle: "应用的外观模式", value: "系统默认")
                            SettingsRow(title: "主题", subtitle: "应用的主题颜色", value: "绿色")
                            SettingsRow(title: "字体", subtitle: "应用的字体", value: "系统默认")
                        }
                        
                        // 其他 section
                        SettingsSection(title: "其他") {
                            SettingsNavigationRow(title: "关于", hasArrow: true)
                            SettingsNavigationRow(title: "帮助与反馈", hasArrow: true)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.title3)
                .fontWeight(.medium)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 12)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.white.opacity(0.8))
            .cornerRadius(12)
            .padding(.horizontal, 20)
        }
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let value: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct SettingsNavigationRow: View {
    let title: String
    let hasArrow: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            if hasArrow {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct CityWeather {
    let name: String
    let temperature: Int
}

#Preview {
    ContentView()
}