# Stock Simulator - Flutter App

## Overview
A comprehensive stock trading simulator built with Flutter that allows users to practice trading stocks in a risk-free environment. The simulator provides real-time market data visualization, portfolio management, and trading functionality.

## Features

### 🏠 Simulation Home Page
- **Portfolio Overview**: Displays total portfolio value with gain/loss indicators
- **Quick Actions**: Buy, Sell, and Portfolio management buttons
- **Market Overview**: Real-time stock listings with price changes
- **Modern UI**: Clean, intuitive interface with gradient cards and smooth animations

### 📊 Portfolio Management
- **Holdings Display**: Shows all owned stocks with detailed information
- **Performance Tracking**: Real-time gain/loss calculations
- **Portfolio Summary**: Total value and percentage changes
- **Stock Details**: Individual stock performance metrics

### 📈 Stock Detail Page
- **Price Information**: Current price with change indicators
- **Timeframe Selector**: 1D, 1W, 1M, 3M, 1Y, ALL views
- **Chart Integration**: Placeholder for price charts (ready for integration)
- **Stock Information**: Market cap, volume, P/E ratio, dividend yield
- **Trading Actions**: Buy and sell functionality with quantity input

### 🎯 Key Features
- **Risk-Free Trading**: Practice trading without real money
- **Real-Time Data**: Simulated market data for realistic experience
- **Portfolio Tracking**: Monitor your virtual investments
- **Performance Analytics**: Track gains, losses, and overall performance
- **User-Friendly Interface**: Modern, responsive design

## Navigation

### Accessing the Stock Simulator
1. Open the app and log in
2. Navigate to the Home page
3. Click the trending chart icon (📈) in the top-right corner
4. This will open the Stock Simulator home page

### Navigation Flow
```
Login → Home Page → Stock Simulator → Portfolio/Stock Details
```

## Technical Implementation

### File Structure
```
lib/feature/simulation/
├── pages/
│   ├── simulation_home.dart      # Main simulator page
│   ├── portfolio.dart           # Portfolio management
│   └── stock_detail.dart        # Individual stock details
└── provider/                    # State management (future)
```

### Dependencies Used
- `flutter/material.dart` - UI components
- `flutter_svg` - SVG icons and assets
- Custom gradient designs and animations

### State Management
- Uses `StatefulWidget` for local state management
- Ready for integration with state management solutions (Provider, Bloc, etc.)

## Future Enhancements

### Planned Features
- [ ] Real-time stock data integration
- [ ] Advanced charting with technical indicators
- [ ] News feed integration
- [ ] Watchlist functionality
- [ ] Trading history and analytics
- [ ] Social features (leaderboards, sharing)
- [ ] Push notifications for price alerts

### Technical Improvements
- [ ] State management integration (Provider/Bloc)
- [ ] API integration for real market data
- [ ] Chart library integration (fl_chart, syncfusion_charts)
- [ ] Local storage for portfolio persistence
- [ ] Firebase integration for user data

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

### Usage
1. Launch the app
2. Complete the login process
3. Navigate to the Home page
4. Click the stock simulator icon to start trading

## Design System

### Color Palette
- **Primary**: `#6366F1` (Indigo)
- **Secondary**: `#8B5CF6` (Purple)
- **Success**: `#22C55E` (Green)
- **Error**: `#EF4444` (Red)
- **Background**: `#F8F9FA` (Light Gray)

### Typography
- **Headings**: Bold, 18-32px
- **Body**: Regular, 14-16px
- **Captions**: Light, 12-14px

### Components
- **Cards**: Rounded corners (12px), subtle shadows
- **Buttons**: Rounded (12px), gradient backgrounds
- **Icons**: Material Design icons with custom colors

## Contributing

### Development Guidelines
1. Follow Flutter best practices
2. Use consistent naming conventions
3. Add proper documentation
4. Test on multiple devices
5. Maintain responsive design

### Code Style
- Use meaningful variable names
- Add comments for complex logic
- Follow Flutter linting rules
- Use proper widget composition

## License
This project is part of the Persifolio app. All rights reserved.

---

**Note**: This is a simulation environment. No real money is involved in trading activities. 