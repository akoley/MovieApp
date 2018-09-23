# MovieApp

Pre- requisites :

1. Xcode 10.1 beta. You can download it here - https://developer.apple.com/download/
2. Carthage is used for package managerment. To install carthage:
  Install Carthage via Homebrew
  $ brew update
  $ brew install carthage
  
  
Once the project is downloaded / cloned run the project.
1. If you have problems with libraries please run the following command on terminal in Assignment folder.
  carthage update --platform iOS --no-use-binaries
2. API Endpoint can be changed from Info.plist
  

Libraries used:

1. Alamofire
2. ObjectMapper
3. Kingfisher
4. RxSwift
6. Reachability

Design: 

1. This project is structured using MVVM-C and Reactive programming.
