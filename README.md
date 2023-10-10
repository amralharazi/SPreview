{\rtf1\ansi\ansicpg1252\cocoartf2757
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww20420\viewh14100\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # SPreview\
A SwiftUI application to preview and play Spotify songs.\
\
\
| Liked songs        | Player | Search Result\
| --------------- | --------------- |  --------------- |\
| <img src="" width="240"> | <img src="" width="240"> | <img src="" width="240"> \
\
\
## Getting Started\
1. Make sure you have Xcode 15 or higher installed on your computer.\
2. Download/clone SPreview to a directory on your computer.\
3. Configure the app using your credentials and then run the current scheme.\
\
## Usage\
1. Create a Spotify developer account and get your Client ID and Secret Key.\
2. Encrypt the auth tokens using a PBKDF2 key using AES.\
3. Convert the encrypted tokens into their corresponding binary array and add them to SpotifyAuthController file.\
4. Launch the app on a simulator or a device running on iOS 17 or higher.\
5. Grant access to your Spotify account to be able to use the app\
6. Now you can start listening to your liked songs\'92 previews or search for new songs.\
## Limitations\
1. You need to have a premium Spotify account to create a developer account and to play songs.\
2. Since the app was developed using the latest SwiftUI updates announced, the minimum deployment target is set to iOS 17.\
\
#Architecture \
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0
\cf0 SPreview has been implemented utilizing the MVC architecture.\
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0
\cf0 \
## Structure\
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0
\cf0 * Presentation folder includes all screens and views files.\
* MusicProvider folder includes the protocol and error for providers.\
* Network folder includes models, API controllers and data parser.\
* MusicPlayer folder includes the files responsible for managing sounds on the app.\
* Utils folder includes security files, extensions, view modifiers, error handling and constants.\
* Resource folder includes info.plist and app assets.\
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0
\cf0 \
## Dependencies\
Cocoapods is used to manage dependencies in this app. Integrated dependencies are:\
* Alamofire\
* SDWebImageSwiftUI\
}