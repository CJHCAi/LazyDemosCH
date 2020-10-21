# iOS Instagram Image Picker

A Instagram image picker providing a simple UI for a user to pick photos from a users Instagram account. It provides an image picker interface that matches the iOS SDK's UIImagePickerController. 

It takes care of all authentication with Instagram as and when necessary. It will automatically renew auth tokens or prompt the user to re-authorize the app if needed. 

## Requirements

* Xcode 6 and iOS SDK 7
* iOS 7.0+ target deployment

## Installation
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like the Kite Print SDK in your projects. If you're using it just add the following to your Podfile:

```ruby
pod "InstagramImagePicker"
```

## Usage

You need to have set up your application correctly to work with Instagram by registering a new Instagram application here: https://instagram.com/developer/ . For the redirect uri use something link `your-app-scheme://instagram-callback`.

To launch the Instagram Image Picker:

```objective-c
#import <OLInstagramImagePicker.h>

OLInstagramImagePickerController *imagePicker = [[OLInstagramImagePickerController alloc] initWithClientId:@"YOUR_CLIENT_ID" secret:@"YOUR_CLIENT_SECRET" redirectURI:@"YOUR-APP-SCHEME://instagram-callback"];
imagePicker.delegate = self;
[self presentViewController:imagePicker animated:YES completion:nil];
```

Implement the `OLInstagramImagePickerControllerDelegate` protocol:

```objective-c

- (void)instagramImagePicker:(OLInstagramImagePickerController *)imagePicker didFinishPickingImages:(NSArray/*<OLInstagramImage>*/ *)images {
    [self dismissViewControllerAnimated:YES completion:nil];
    // do something with the OLInstagramImage objects
}

- (void)instagramImagePickerDidCancelPickingImages:(OLInstagramImagePickerController *)imagePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)instagramImagePicker:(OLInstagramImagePickerController *)imagePicker didFailWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // do something sensible with the error
}

```

### Sample Apps
The project is bundled with a Sample App to highlight the libraries usage. Alternatively you can see the library in action in the following iOS apps:

* [Sticky 9](https://itunes.apple.com/us/app/sticky9-print-your-photos/id974671077?mt=8)
* [HuggleUp](https://itunes.apple.com/gb/app/huggleup-photo-printing-personalised/id977579943?mt=8)
* Get in touch to list your app here

## License
This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.