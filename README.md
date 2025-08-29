Weatherly (iOS · SwiftUI)
A modern, production‑ready weather app demonstrating MVVM, Coordinator, Dependency Injection, SOLID design, an async/await network layer, OpenWeather integration, geocoding-based type‑ahead search, and a polished UI with glassmorphism.

Table of contents

Features
Architecture
Project structure
Requirements
Setup and run
API notes
Design notes
Persistence
Error handling
App Icon
Troubleshooting
Roadmap
Features

Splash → Home → Details flow via Coordinator
City search with type‑ahead suggestions (OpenWeather Geocoding API)
Tap a suggestion to fetch and navigate immediately (uses lat/lon for precision)
Weather Details: temperature, description, feels like, min/max, humidity, icon
Favorites: save up to 3 locations, heart‑based design, one‑tap open or remove
Debounced suggestions and in‑flight cancellation to protect rate limits
Clean error alerts (e.g., city not found)
Simple DI container and protocol‑driven services for easy testing and swaps
Network logging in DEBUG builds


Architecture
MVVM per feature (Home, Details): testable, UI‑agnostic view models
Coordinator (NavigationStack + AppRoute): centralizes navigation
Dependency Injection (AppContainer): wires services and stores
Services: WeatherService, GeocodingService (protocol + implementation)
Core: NetworkManager with typed HTTP errors, DTO→Domain mapping
Persistence: UserDefaults store for up to 3 favorites
SOLID: small protocols, single responsibility, dependency inversion


Requirements
Xcode 15 or newer
iOS 16.0+ (NavigationStack, AsyncImage)
Swift 5.9+
OpenWeather API key
Setup and run

Clone the repo and open the project in Xcode.

Add your OpenWeather API key:

Xcode → Target → Info → “Custom iOS Target Properties”
Add:
Key: OPENWEATHER_API_KEY
Type: String
Value: YOUR_KEY
Alternatively, use xcconfig:

Create Debug.xcconfig/Release.xcconfig:
OPENWEATHER_API_KEY = your_key
Assign the xcconfigs to the target (Project → Info)
In Info.plist set OPENWEATHER_API_KEY to $(OPENWEATHER_API_KEY)
Build & Run on iOS 16+ simulator or device.
API notes

Current Weather by city
GET https://api.openweathermap.org/data/2.5/weather?q={city}&units=metric&appid={API_KEY}
Current Weather by coordinates
GET https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&units=metric&appid={API_KEY}
Geocoding autocomplete (type‑ahead)
GET https://api.openweathermap.org/geo/1.0/direct?q={query}&limit={n}&appid={API_KEY}
Why geocoding? Selecting a suggestion gives precise lat/lon, removing ambiguity (e.g., “Paris, FR” vs “Paris, US”).

Design notes

Modern glassmorphism, gradient backgrounds, and iconography
Heart‑based favorites for an approachable, premium feel
One‑tap actions with subtle haptics (when available)
Dynamic type friendly and Dark Mode‑compatible
AsyncImage loads OpenWeather icons when provided


Persistence
FavoriteCityStore stores up to 3 favorites in UserDefaults (JSON‑encoded)
Favorites prefer saving coordinates (from suggestions) for accurate retrieval
Duplicate detection by coordinates or normalized text


Error handling
Typed HTTPError for network/decoding/server errors
User‑friendly messages (e.g., “City not found…”)
SwiftUI alert surfaced from HomeViewModel
DEBUG logging prints requests and pretty JSON responses

App Icon
Included under Assets.xcassets/AppIcon
For Xcode 15+, a single 1024×1024 PNG is sufficient
Optional script (scripts/generate-app-icons.sh) can produce a full multi‑size set and Contents.json from one 1024×1024 input

Troubleshooting
401 Invalid API key: Wait up to ~10 minutes after creating your key, or verify the value.
404 city not found: Use suggestions or include country code (e.g., “Sydney, AU”).
No icons appear: Some responses may omit an icon; AsyncImage shows a placeholder in that case.
Navigation doesn’t occur after tapping a suggestion: Ensure HomeView calls viewModel.fetchWeather(for: suggestion) and pushes Details on success.
Roadmap (nice-to-have improvements)

OpenWeather for the weather and geocoding APIs
SF Symbols for high‑quality system icons

The project demonstrates MVVM + Coordinator , with protocol‑driven services and SOLID boundaries.
Geocoding suggestions are debounced and in‑flight canceled to respect rate limits and ensure a responsive UI.
Favorites support up to three entries and use coordinates when available for exact weather retrieval.
