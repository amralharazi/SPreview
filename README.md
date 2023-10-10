
 # SPreview
A SwiftUI application to listen and play Spotify songs preview.

| Liked songs        | Song player | Search for songs
| --------------- | --------------- |  --------------- |
| <img src="https://github.com/amralharazi/SPreview/assets/55652499/16e936ab-7e7e-4dc1-91f8-1258912f8c05" width="240"> | <img src="https://github.com/amralharazi/SPreview/assets/55652499/3fc31709-f27f-45c2-a838-324373b6f303" width="240"> | <img src="https://github.com/amralharazi/SPreview/assets/55652499/47a1f8f4-4b78-4590-bf70-bf90db440613" width="240"> 

## Getting Started
1. Make sure you have Xcode 15 or higher installed on your computer.
2. Download/clone SPreview to a directory on your computer.
3. Configure the app using your credentials and then run the current scheme.

## Usage
1. Create a Spotify developer account and get your Client ID and Secret Key.
2. Encrypt the auth tokens using a PBKDF2 key using AES.
3. Convert the encrypted tokens into their corresponding binary array and add them to SpotifyAuthController file.
4. Launch the app on a simulator or a device running on iOS 17 or higher.
5. Grant access to your Spotify account to be able to use the app
6. Now you can start listening to your liked songs\'92 previews or search for new songs.
   
## Limitations
1. You need to have a premium Spotify account to create a developer account and to play songs seamlessly.
2. Since the app was developed using the latest SwiftUI updates announced, the minimum deployment target is set to iOS 17.

## Architecture 
SPreview has been implemented utilizing the MVC architecture.

## Structure
 * Presentation folder includes all screens and views files.
* MusicProvider folder includes the protocol and error for providers.
* Network folder includes models, API controllers and data parser.
* MusicPlayer folder includes the files responsible for managing sounds on the app.
* Utils folder includes security files, extensions, view modifiers, error handling and constants.
* Resource folder includes info.plist and app assets.
  
## Dependencies
Cocoapods is used to manage dependencies in this app. Integrated dependencies are:
* Alamofire
* SDWebImageSwiftUI
