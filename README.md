# GalleryApp

# Author

Karina Kovaleva

telegram: *@karina_kovaleva_ios*

# Description

An image gallery

<div style="display: flex; gap: 10px; justify-content: center;">
  <div style="border: 2px solid #ccc; padding: 10px; border-radius: 8px; display: inline-block;">
    <img src="https://github.com/kovalevakarinaios/GalleryApp/blob/develop/DemonstrationPhoto/DetailGalleryScreen%20-%20with%20like.png" alt="Image 1" style="width: 200px; height: auto;">
  </div>
  <div style="border: 2px solid #ccc; padding: 10px; border-radius: 8px; display: inline-block;">
    <img src="https://github.com/kovalevakarinaios/GalleryApp/blob/develop/DemonstrationPhoto/DetailGalleryScreen%20-%20with%20like.png" alt="Image 2" style="width: 200px; height: auto;">
  </div>
</div>
![Alt text](https://github.com/kovalevakarinaios/GalleryApp/blob/develop/DemonstrationPhoto/DetailGalleryScreen%20-%20with%20like.png)
![Alt text](https://github.com/kovalevakarinaios/GalleryApp/blob/develop/DemonstrationPhoto/DetailGalleryScreen%20-%20without%20like.png)
![Alt text](https://github.com/kovalevakarinaios/GalleryApp/blob/develop/DemonstrationPhoto/MainGalleryScreen%20-%20alert.png)
![Alt text](https://github.com/kovalevakarinaios/GalleryApp/blob/develop/DemonstrationPhoto/MainGalleryScreen%20-%20landscape.png)
![Alt text](https://github.com/kovalevakarinaios/GalleryApp/blob/develop/DemonstrationPhoto/MainGalleryScreen%20-%20offline%20mode.png)
![Alt text](https://github.com/kovalevakarinaios/GalleryApp/blob/develop/DemonstrationPhoto/MainGalleryScreen%20-%20portrait.png)
![Alt text](https://github.com/kovalevakarinaios/GalleryApp/blob/develop/DemonstrationPhoto/MainGalleryScreen%20-%20with%20like.png)


# Technologies

Language: Swift

Architecture: MVVM

Tools: Xcode

Database: Core Data

Networking: URLSession

Features:
+ Custom UI Components: UICollectionView with Custom CollectionView Layout (Main Screen) and CompositionalLayout (Detail Screen)
+ Offline Support: Core Data
+ Error Handling & Alerts: UIAlertController
+ Custom Animations: Custom Navigation Transition (CustomTransitionAnimator, CustomNavigationControllerDelegate)

Homebrew:
+ SwiftLint

SPM:
+ SDWebimage

# Dependencies

The app uses native solutions wherever possible, with only essential external dependencies:

**SDWebImage**: Integrated via Swift Package Manager, used for asynchronous image loading and caching.

# Features

For the main screen, a UICollectionView with a custom CollecctionViewLayout was implemented to achieve ***a Pinterest-like*** grid. This layout adapts dynamically, calculating cell sizes and column counts based on content and screen size. This dynamic approach provides a fluid, visually appealing gallery view.

To create this layout, the following materials and concepts were particularly useful:

**Ray Wenderlich**: https://www.kodeco.com/4829472-uicollectionview-custom-layout-tutorial-pinterest

The app has a custom animation for moving between screens, which makes navigation smoother and more interesting. This animation was created using two main parts: **CustomNavigationControllerDelegate** and **CustomTransitionAnimator**. These let us control how and when the animation plays, creating a unique look as users open photo details or go back to the main gallery.

The following material was particularly useful:

**Medium**: https://medium.com/@tungfam/custom-uiviewcontroller-transitions-in-swift-d1677e5aa0bf

**A refresh button** was added to the navigation bar on Main Screen. This button allows users to reload the content if the internet connection is lost or if they want to update the data manually.

**Different error alerts** have been implemented to inform the user when something goes wrong (for example server errors, authentication errors, lost internet connection and more). These alerts help to improve the user experience by clearly informing the user about the issue. This way, the user knows what happened and can take the necessary steps to resolve the problem.

# Requirements for the Project

## Image Gallery Screen

:white_check_mark: Display a grid of thumbnail images fetched from the Unsplash API

:white_check_mark: Each thumbnail should be tappable and lead to the Image Detail Screen.

:white_check_mark: Implement pagination to load more images as the user scrolls to the bottom of the screen.

## Image Detail Screen

:white_check_mark: Show the selected image in a larger view with additional details, such as the image title and description.

:white_check_mark: Allow the user to mark the image as a favourite by tapping a heart-shaped button.

:white_check_mark: Implement navigation between images in the detail view.

## Networking

:white_check_mark: Use the Unsplash API (https://unsplash.com/developers) to fetch the images.

:white_check_mark: Use the "List Photos" endpoint to retrieve a list of curated photos. Fetch the images in pages of **30** images per request.

:white_check_mark: Implement basic data persistence to store and retrieve the user's favorite images locally - **CoreData**.

:white_check_mark: Display a visual indicator on the thumbnail images in the gallery screen for the user's favorite images.

:white_check_mark: Design the user interface with attention to usability and aesthetics. Ensure a clean and intuitive layout, considering different device sizes and orientations.

:white_check_mark: Use appropriate UI components and image caching techniques for smooth scrolling and image loading.

## Technical Guidelines

:white_check_mark: Use Swift as the programming language.

:white_check_mark: Support iOS 15 and above.

:white_check_mark: Use UIKit for building the user interface.

:white_check_mark: Utilize URLSession for network requests.

:white_check_mark: Structure the codebase with appropriate separation of concerns and modularity.

:white_check_mark: Implement proper error handling and data parsing. Demonstrate proficiency in asynchronous programming. 

:negative_squared_cross_mark: Basic unit tests are encouraged but not mandatory.

:white_check_mark: Implement proper error handling and data parsing. Demonstrate proficiency in asynchronous programming. 

:white_check_mark: Try to use SOLID principles throughout your development process.

:white_check_mark: Use MV(x) pattern or any other complex Clean-architecture. NOT MVC! - **MVVM**

:white_check_mark: Use swiftlint or any other linter for code formatting. - **Swiftlint**
