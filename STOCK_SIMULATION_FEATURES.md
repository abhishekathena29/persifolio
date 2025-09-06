# Stock Simulation Features

## Overview
This document describes the Buy and Sell features implemented for the stock simulation app.

## Key Features

### 1. Investment Limit
- **Maximum Investment**: ₹1,00,000 (1 lakh rupees)
- **Validation**: Users cannot exceed this limit when buying stocks
- **Available Cash**: Shows remaining cash available for investment
- **Real-time Updates**: Available cash updates after each transaction

### 2. Buy Feature
- **Stock Purchase**: Users can buy stocks from the stock detail page
- **Quantity Input**: Users specify the number of shares to buy
- **Price Validation**: Current market price is used for transactions
- **Limit Checking**: System prevents purchases that would exceed the investment limit
- **Portfolio Integration**: Bought stocks are automatically added to the user's portfolio

### 3. Sell Feature
- **Stock Sale**: Users can sell stocks they own
- **Quantity Validation**: Users can only sell shares they actually own
- **Partial Sales**: Users can sell a portion of their holdings
- **Portfolio Updates**: Sold stocks are removed or updated in the portfolio

### 4. Portfolio Management
- **Holdings View**: Dedicated page showing all current investments
- **Real-time Values**: Current market values and gains/losses
- **Daily P&L**: Shows daily profit or loss for each holding
- **Total Portfolio Value**: Displays overall portfolio performance
- **Investment Tracking**: Shows total invested amount vs. available cash

### 5. Daily Profit/Loss Tracking
- **Real-time Calculation**: Daily P&L calculated based on price changes
- **Per-stock Tracking**: Individual daily P&L for each holding
- **Portfolio Summary**: Total daily P&L across all holdings
- **Visual Indicators**: Color-coded display (green for gains, red for losses)

## Technical Implementation

### Portfolio Service Updates
- Added investment limit validation
- Enhanced buy/sell methods with proper error handling
- Daily P&L calculation functionality
- Portfolio statistics and analytics

### UI Components
- **Simulation Home**: Shows portfolio value, available cash, and daily P&L
- **Stock Detail**: Buy/Sell buttons with quantity input
- **Portfolio Holdings**: Dedicated page for viewing all investments
- **Floating Action Button**: Quick access to portfolio

### Data Structure
```dart
Portfolio {
  totalValue: double,           // Current market value
  totalGain: double,            // Total gains/losses
  gainPercentage: double,       // Percentage gain/loss
  totalInvestment: double,      // Total amount invested
  availableCash: double,        // Remaining cash
  dailyPnL: double,            // Daily profit/loss
  holdings: [                   // Array of stock holdings
    {
      symbol: string,
      name: string,
      shares: int,
      avgPrice: double,
      currentPrice: double,
      totalValue: double,
      gain: double,
      gainPercent: double,
      dailyPnL: double,
      isPositive: boolean,
      lastUpdated: string
    }
  ]
}
```

## Usage Flow

1. **Viewing Stocks**: Users browse available stocks on the simulation home page
2. **Stock Details**: Tap on a stock to view detailed information and charts
3. **Buying Stocks**: 
   - Tap "Buy" button
   - Enter quantity of shares
   - System validates against investment limit
   - Stock is added to portfolio if successful
4. **Selling Stocks**:
   - Tap "Sell" button
   - Enter quantity to sell
   - System validates available shares
   - Stock is removed/updated in portfolio if successful
5. **Portfolio Management**: Use floating action button to view all holdings

## Error Handling

- **Investment Limit Exceeded**: Clear error message with available amount
- **Insufficient Shares**: Validation when trying to sell more shares than owned
- **Invalid Data**: Proper validation for all input fields
- **Network Errors**: Graceful handling of API failures

## Future Enhancements

- Real-time price updates
- Advanced portfolio analytics
- Historical performance tracking
- Risk assessment tools
- Portfolio rebalancing suggestions
