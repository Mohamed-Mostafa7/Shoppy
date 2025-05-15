# Shoppy

**Shoppy** is a shopping app that allows users to browse products fetched from an online store, toggle between list and grid layouts, and view detailed information for each product.

## Installation

To install and run Shoppy on your device, follow these steps:

1. Clone the repository:
```bash
git clone https://github.com/Mohamed-Mostafa7/Shoppy.git
```
2. Open the project:
```bash
cd Shoppy
```
3. Open the project in Xcode.
4. Update Packages
5. Build and run the project.

## Features

- Fetch product data from an external API and display it with a clean UI.
- Toggle between grid view and list view of products using a navigation bar button.
- Tap on a product to see its detailed information.
- Show loading indicators while data is being fetched.
- Handle network errors gracefully, and load products from cache when offline.
- Save the most recent products locally for quick access.

## Technologies Used

The following technologies were used in the development of Shoppy:
- MVVM Architecture Pattern
- Combine framework for reactive bindings
- UIKit: UICollectionView, UIScrollView
- Async/Await Networking
- API Integration with custom Endpoint abstraction
- Image caching (can integrate Kingfisher or similar if needed)
- UserDefaults caching for offline access
- Dependency Injection for testing and flexibility
- Unit Testing with XCTest

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

