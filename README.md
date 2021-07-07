<h1>SafexPay iOS SDK</h1>


  [![Language](https://img.shields.io/badge/Swift-5-red?style=plastic)]()
  [![Language](https://img.shields.io/badge/Objective--C-compatible-blue?style=plastic)]()
  [![License](https://img.shields.io/github/license/antinolabsdev/WddOnboarding-SDK-iOS?style=plastic)]()
  
## Requirements

- iOS 10.0+
- Xcode 10.2.1+
- Swift 4.2 or Objective-C

## CocoaPods

To use the SafexPay SDK we recommend to use Cocoapods 1.7.0 or later

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate the SafexPay SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:


```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

pod 'SafexPay', :git =>"https://github.com/antinolabsdev/SafexSDK.git"
```

Then, run the following command:

```bash
$ pod install
```

## Usage
First of all, if you don't have an Xcode project yet, create one, then install the SDK following the paragraph `Cocoapods`.

**1)** Navigate to the root directory of your project in Terminal (the directory that contains your .xcodeproj file) using the cd command:
- Create an empty Cartfile with the `touch` command:
```
touch Cartfile
```
- This will create an empty Cartfile in your project. Open the cartfile and add these lines:
```
github "hackiftekhar/IQKeyboardManager"
github "rushisangani/RSSelectionMenu" ~> 7.1
github "krzyzanowskim/CryptoSwift"
github "Alamofire/Alamofire" ~> 5.2
github "Krimpedance/KRProgressHUD"
github "onevcat/Kingfisher" ~> 5.8.0
github "Flight-School/AnyCodable" ~> 0.4.0
```

- Close your Cartfile in Xcode and head back to Terminal. Run the following command:
```
carthage update --platform iOS
```

- This instructs Carthage to clone the Git repositories that are specified in the Cartfile, and then build each dependency into a framework.

- A Cartfile.resolved file and a Carthage directory will appear in the same directory where your .xcodeproj or .xcworkspace is.

- Back in Xcode, Go to the project in the Project Navigator. Select the your target, choose the General tab at the top, and scroll down to the Linked Frameworks and Libraries section at the bottom.
- In the Carthage Finder window, navigate into Carthage/Build/iOS. Drag the IQKeyboardManager.framework,IQKeyboardManagerSwift.framework, RSSelectionMenu.framework, CryptoSwift.framework, Alamofire.framework, KRProgressHUD.framework,KRActivityIndicatorView.framework, Kingfisher.framework and AnyCodable.framework into the Linked Frameworks and Libraries section in Xcode.
- This tells Xcode to link your app to these frameworks, allowing you to make use of them in your own code.
- Next, switch over to Build Phases and add a new Run Script build phase by clicking the + in the top left of the editor. Add the following command:
```
/usr/local/bin/carthage copy-frameworks
```
- Click the + under Input Files and add an entry for each framework:
```
$(SRCROOT)/Carthage/Build/iOS/IQKeyboardManager.framework
$(SRCROOT)/Carthage/Build/iOS/RSSelectionMenu.framework
$(SRCROOT)/Carthage/Build/iOS/CryptoSwift.framework
$(SRCROOT)/Carthage/Build/iOS/Alamofire.framework
$(SRCROOT)/Carthage/Build/iOS/KRProgressHUD.framework
$(SRCROOT)/Carthage/Build/iOS/Kingfisher.framework
$(SRCROOT)/Carthage/Build/iOS/AnyCodable.framework
```


**2)** Import the Safex_Pay iOS SDK module in your UIApplicationDelegate subclass:

```
import SafexPay
```
**3)** Configure a Safex_Pay iOS SDK shared instance, in your App Delegate, inside **application:didFinishLaunchingWithOptions:** method:

```
SafexPay.sharedInstance.configure(MerchantId: "", MerchantKey: "") 
```

### Using SafexPay
**1)** To initialize the SDK on view controller call this method :

```
SafexPay.sharedInstance.showPaymentGateway(on: self, price: "", orderId: "", custName: "", custEmail: "", custNumber: "", country: "", currency: "")
```
- Here **self** is your current view controller
- price is the amount to be paid
- orderId will be the Order ID
- custName will be the name of the Customer
- custEmail will be the email of the Customer
- custnumber will be the number of the Customer
- country will be the country of the Customer
- currency will be the currency to be used


## Contributing

- If you **need help** or you'd like to **ask a general question**
- If you **found a bug**, open a service request.
- If you **have a feature request**, open a service request.
- If you **want to contribute**, submit a pull request.


## Acknowledgements

Made with ❤️ by [Antino Labs](https://www.antino.io/).


## License
SafexPay is released under the MIT license. [See LICENSE](https://github.com/antinolabsdev/SafexSDK/blob/main/LICENSE) for details.
