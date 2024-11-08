# GalleryApp

# Author

Karina Kovaleva

telegram: *@karina_kovaleva_ios*

# Description

An image gallery app displays photos loaded from an API. 


## Main Screen

The main screen Pinterest-style layout dynamically adjusts when the orientation changes.
 
<img src="MainGalleryScreen%20-%20portrait" width="200"> <img src="MainGalleryScreen%20-%20landscape.png" width="500">

If the user likes a photo on the detail screen, the main screen will reflect this change by showing a heart icon in the bottom-right corner of the photo. This gives users a quick visual cue of their liked photos directly from the main screen.

<img src="MainGalleryScreen%20-%20with%20like.png" width="200">

When there is no internet connection, authentication issues, server errors, or other problems, the user will see an alert with relevant information. The app provides informative messages that explain the specific cause of each error, enhancing the user experience by offering clear guidance in case of any issues.

<img src="MainGalleryScreen%20-%20alert.png" width="200"> 

The app also supports offline mode: information about favorite photos, along with the photos themselves, is saved to a local database using Core Data. This allows users to continue viewing their favorite photos even when there is no internet connection.

<img src="MainGalleryScreen%20-%20offline%20mode.png" width="200">

## Detail Screen

The detail screen provides more information about each photo, displaying it in a larger size and higher quality. Users can add photos to their favorites directly from this screen and easily navigate between available photos.

<img src="DetailGalleryScreen%20-%20with%20like.png" width="200"> <img src="DetailGalleryScreen%20-%20without%20like" width="200">


# Technologies

Language: Swift

Architecture: MVVM

Tools: Xcode

Database: Core Data

Networking: URLSession

Features:
+ Custom UI Components: UICollectionView with Custom CollectionViewLayout (Main Screen) and CompositionalLayout (Detail Screen)
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


***Offline mode*** is supported through data saving with ***Core Data***, allowing the app to access stored information when network access is unavailable.

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
