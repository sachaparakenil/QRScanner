# QR Scanner

![version](https://img.shields.io/badge/version-1.0.5-blue)

A QR Scanning application which saves all scanned QR codes and let you copy result whenever you want.

## Tech Stack

- ***Framework***: Flutter

- ***Language***: Dart

- ***Database***: Firebase

## Features

<details>
<summary>Click to see features</summary>

</br>

- [x] Login/Signup
  - [x] Email validation
  - [x] Password should be between 6 to 15 character
- [x] Forgot Password feature
  - [x] You will recieve email for resetting password
  - [x] Link gets expire
- [x] Email verification
  - [x] Email verification link sends when you register
  - [x] At login time it checks if email is verified then it let login user
  - [x] Rate limit if user do many times
- [x] QR code scan
  - [x] Beep sound when QR gets scanned
  - [x] Vibration when QR gets scanned
  - [x] Flash light turn ON/OFF
  - [x] Check if the QR is previous scanned
- [x] QR data at homepage
  - [x] Saves scanned result into database
  - [x] Can copy scanned result by swiping right
  - [x] Can delete scanned result by swiping left
- [x] Profile feature
  - [x] Can set profile picture
  - [x] Supports photo from gallary
  - [x] Supports photo from direct camera
  - [x] Can set name
  - [x] Can set mobile number
  - [x] Can change password
- [x] Setting menu
  - [x] Can set if user wants beep sound at QR scan
  - [x] Can set if user wants vibration at QR scan
  - [x] Privacy policy
  - [x] Version information
- [x] Logout

</details>

## Screenshot

<details>
<summary>Click to see screenshots</summary>

</br>

<img src="./docs/screenshots/login_empty.png" height="512em" alt="Login" /><img src="./docs/screenshots/signup_empty.png" height="512em" alt="Signup"/><img src="./docs/screenshots/forgot_password_empty.png" height="512em" alt="Forgot Password"/><img src="./docs/screenshots/verify_email.png" height="512em" alt="Verify Email"/><img src="./docs/screenshots/menubar.png" height="512em" alt="Menu"/><img src="./docs/screenshots/profile.png" height="512em" alt="Profile"/><img src="./docs/screenshots/profile_choose.png" height="512em" alt="Profile Choose"/><img src="./docs/screenshots/camera_permisson.png" height="512em" alt="Camera Permission"/><img src="./docs/screenshots/profile_update.png" height="512em" alt="Profile Update"/><img src="./docs/screenshots/updated_profile.png" height="512em" alt="Updated Profile"/><img src="./docs/screenshots/change_password.png" height="512em" alt="Change Password"/><img src="./docs/screenshots/password_changed.png" height="512em" alt="Password Changed"/><img src="./docs/screenshots/setting.png" height="512em" alt="Setting"/><img src="./docs/screenshots/privacy_policy.png" height="512em" alt="Privacy Policy"/><img src="./docs/screenshots/version.png" height="512em" alt="Version"/><img src="./docs/screenshots/qr_scanning.png" height="512em" alt="QR Scanning"/><img src="./docs/screenshots/copy_swipe.gif" height="512em" alt="Copy Result"/><img src="./docs/screenshots/delete_swipe.gif" height="512em" alt="Delete Result"/>

</details>

## Available on
[![Release](https://img.shields.io/badge/release-1.0.5-blue)](https://github.com/rugvedkoshiya/QR-Scanner/releases)

## License

QR Scanner is distributed under the MIT Licence, See [Licence](LICENCE).