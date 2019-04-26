# Guestlogix Challenge

by [Luiz Fernando Dias](http://www.linkedin.com/in/luizfernandodias)

### About

Guestlogix Challenge is an iOS App made for a Programming Test for Guestlogix, written in Swift.

## Instructions

1. Browse the git [repository](https://github.com/luizdias/ios-test-task-for-guestlogix)
2. Clone locally using `git clone https://github.com/luizdias/ios-test-task-for-guestlogix.git`
3. At the folder, double click the file **GuestlogixChallenge.xcodeproj** or, on your terminal window type `open GuestlogixChallenge.xcodeproj`
4. Press CMD + R to **Build and Run** the project on your selected device (or Simulator)
5. Press CMD + U to **Run Tests** on the Xcode

## Notes

I used iOS native APIs only in order to keep the project clean and easy to run.
In a enterprise and more guaranteed approach I could use CocoaPods (or Carthage) and integrate some well-known and stable lib or consume a Maps API.

## Worth mentioning

- I tried to focus on meeting all user requirements. Therefore, UI/UX were not really my main concern at this time;
- Although Airlines names were provided, they are not mentioned in any User Store, threfore they are not being shown;
- Some parts of the code could be divided into smaller parts and functions, although I tried to follow the _Clean Code_ principles;
- The code style is following Xcode original presets. But a code formatting tool could assure consistent styling through all codebase;
- CSV Parsing logic could be more tolerant to inconsistent data (i.e accepting boolean values as true, "true" and 1). The use the adapter pattern would provide reusability of the CSV reader function;
- Unit Tests could include more scenarios. I did test CVS Reading, but I could implement a variety of other cases, mocking objects to reproduce actual user behavior;
- In real life cse, user input handling code could be more robust and cover as many scenarios as possible, considering more cases like incorrect, invalid or missing values, for instance.
- Did not include code //comments on purpose, in order to keep things clean and let the code explain itself.

## Requirements

- Mac OS
- XCode 10.x
- Swift 4.2
