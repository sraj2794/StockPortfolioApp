# Stock Portfolio App
This is a stock portfolio app for iOS developed using Swift. It follows the MVVM architecture to ensure a clean, scalable, and maintainable codebase. The app fetches stock data from a provided endpoint, calculates various portfolio metrics, and displays them in a user-friendly interface with expandable and collapsible sections.

# Features
Fetch Stock Data: Retrieve stock holdings data from a remote API.
Expandable/Collapsible UI: Show detailed stock information in an expandable and collapsible format.
Portfolio Calculations: Calculate current value, total investment, total PNL, and today’s PNL.
MVVM Architecture: Separate business logic from the UI for better maintainability and testability.
Programmatic UI: Build the UI programmatically using UIKit without storyboards or xibs.
Unit Tests: Ensure code reliability with unit tests for ViewModel logic.
# Screenshots
<img src="https://github.com/sraj2794/StockPortfolioApp/assets/41502704/81757d2a-70c5-4636-b02b-6c242c5bc991" width="300">
<img src="https://github.com/sraj2794/StockPortfolioApp/assets/41502704/d2b3196b-a21c-4bfa-9ca5-ad787b0ef64d" width="300">
<img src="https://github.com/sraj2794/StockPortfolioApp/assets/41502704/c2bc9656-f262-4f6d-a265-5c25b02db5b5" width="300">

# Installation
Clone the Repository:

sh
Copy code
git clone https://github.com/sraj2794/StockPortfolioApp.git
cd StockPortfolioApp
Open in Xcode:
Open the .xcodeproj file in Xcode.

# Install Dependencies:
This project does not use any third-party dependencies, ensuring lightweight and easy setup.

# Run the App:
Select a simulator or a connected device and hit the run button in Xcode.

# Usage
The app will fetch stock data from the provided endpoint.
Expand or collapse sections to view detailed information about each stock.
View calculated metrics at the top of the portfolio.
Calculations
Current Value: Sum of (Last traded price * quantity of holding) of all holdings.
Total Investment: Sum of (Average Price * quantity of holding) of all holdings.
Total PNL: Current value - Total Investment.
Today’s PNL: Sum of ((Close - LTP) * quantity) of all holdings.
# Development
# Architecture
The app uses MVVM architecture:

Model: Represents the data and business logic.
View: Represents the UI components.
ViewModel: Acts as a mediator between Model and View, handling business logic and preparing data for the View.

# UI Design
Built programmatically using UIKit.
Ensures no constraint warnings or errors.
Follows Apple’s Human Interface Guidelines for a clean and intuitive user interface.

# Unit Testing
Includes unit tests for ViewModel to ensure correctness of business logic.
Tests cover various edge cases and error scenarios.

# Contributing
Fork the repository.
Create a new branch for your feature (git checkout -b feature-name).
Commit your changes (git commit -m 'Add some feature').
Push to the branch (git push origin feature-name).
Create a Pull Request.

# License
This project is licensed under the MIT License.

# Contact
For any questions or suggestions, feel free to open an issue or contact the repository owner.
