VisAnalyticsKit (VAK) - The state logging framework

An iOS framework to log state data in a [backend](https://github.com/HPC-Group/VAKServer) agnostic fashion, that's also able to replay those logged states. 
The framework is configurable - as such it comes with lots of [protocols](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithProtocols/WorkingwithProtocols.html) to be implemented - if one wishes to - so it does not strictly force consumers to use the internal implementations, 
but it comes prepacked with some components: for example a VAKJSONProvider and a VAKConsoleProvider.
Due to it's configurability the actual configuration might be a bit more complex.

# Table of Contents

1. [Platform](#platform)
2. [Requirements](#requirements)
3. [Installation](#installation)
3.1. [Include via Carthage](#include-via-carthage)
3.2. [GIT and Submodules](#git-and-submodules)
4. [DSL and Configuration of the Logger Manager](#dsl-and-configuration-of-the-logger-manager)
5. [License](#license)


## Platform

The framework is written in Objective-C and loosely follows the concept of Domain Driven Design (DDD), hence the folder structure and names.
It uses [carthage](https://github.com/carthage/carthage) to manage dependencies internally. Those dependencies are checked in as submodules
in the Carthage/Checkouts folder, so consumers are not required to use the same tool chain.

## Requirements

iOS 8.x SDK and above because the VisAnalyticsKit is a "Cocoa Touch Framework".
The later were introduced with iOS 8. [Here is some info about that](https://developer.apple.com/library/prerelease/ios/documentation/DeveloperTools/Conceptual/WhatsNewXcode/Articles/xcode_6_0.html).

## Installation

There are currently two ways to install the VisAnalyticsKit Framework.
If you have a package manager installed (namely [carthage], [cocoapods are on the list]) just do as you always do.
But you can just as easily use GIT with submodules, because all hard and soft dependencies are checked in as submodules. 

### Include via Carthage

// This has to be verified, and of course has to have a repository at the mentioned address 
// TODO: I guess the build scheme has to be shared

Can be included in any iOS project via the aforementioned Carthage.

Add the following line to your Cartfile:

```github "HPC-Group/VisAnalyticsKit" ```
Run ```bash carthage update --platform ios ```, and you should now have the latest version of VisAnalyticsKit in your Carthage folder.

### CocoaPods

TODO.

### GIT and Submodules

Of course the framework can be used via git or as a submodule.

GIT < 1.6.5:
```bash 

cd  /path/to/your/project/dependencies
git clone https://github.com/HPC-Group/VisAnalyticsKit.git VisAnalyticsKit # clones the repository into a subfolder called VisAnalyticsKit
git submodule update --init --recursive
```

GIT >= 1.6.5:
```bash 
cd  /path/to/your/project/dependencies
git clone --recursive https://github.com/HPC-Group/VisAnalyticsKit.git VisAnalyticsKit # clones the repository into a subfolder called VisAnalyticsKit
```
Submodules
```bash
cd  /path/to/your/project/
git submodule add https://github.com/HPC-Group/VisAnalyticsKit.git path/to/your/dependencies/VisAnalyticsKit
git submodule update --init --recursive

```
Then include the VisAnalyticsKit.xcodeproj into your project and add the VisAnalyticsKit.framework to your "Linked Frameworks and Libraries" section in your target that wants to consume the framework.

### Aside

The bleeding edge features are on the master branch.
For stable state there will be tags and or branches that are marked release/*.

---

# DSL and Configuration of the Logger Manager

The follwing figure shows all configuration keys, that are used to configure the Logger Manager.
For an overview of everything defined in th DSL, feel free to have a look at [VAKConstants.h](VisAnalyticsKit/Utils/VAKConstants.h)
This part is highly inspired by the [ARAnalytics](https://github.com/orta/ARAnalytics).

```objective-c
@{
  // ---------------------------------------------------
  // -- GENERAL
  // ---------------------------------------------------

  // optional. used in builder to determine which backends to us
  // two options of this key are valid variant one:
  // Array of backend enums
  kVAKConfigWhichBackends: @[
    @(VAKBackendNSLogNoop)
  ],
  // variant two: a single backend enum
  kVAKConfigWhichBackends: @(VAKBackendNSLogNoop),

  // optional.
  // a dictionary of backend names => configured backends that conform to 
  // the VAKBackendProtocol
  kVAKConfigCustomBackends: @{
    @"type1": id<VAKBackendProtocol>,
    ...
  },

  // required, when builder is used this one is generated through the previous key:value pair
  // else must hold fully initialized backendProtocols
  kVAKConfigBackends: @[],
  
  // optional.
  // a whitelist of fields from state or session, that should be logged out to screen when using 
  // the console provider types. note that those fields don't have any effect on the none volatile providers.
  // 
  kVAKConfigConsoleFieldsWhitelist: @[
    kVAKStateData, kVAKStateTags,
    kVAKSessionStart
  ],

  // optional.
  // blacklists the given tags so that they won't show up in
  // the console providers. none-volatile persitence mechanisms are saving those
  // states anyway
  kVAKConfigConsoleTagsBlacklist: @[@"a_tag_to_blacklist"],

  // optional.
  // this feature sets the session life-cycle to auto.
  // being said, you have to pass in your AppDelegate class name as a string
  // because the feature relies on it. 
  // internally it uses the aspects power to register the following hooks
  //@selector(applicationWillResignActive:);
  //@selector(applicationDidEnterBackground:);
  //@selector(applicationWillTerminate:);
  //@selector(applicationWillEnterForeground:);
  //@selector(applicationDidBecomeActive:);
  // currently a message is output if your app delegate is missing one of those selectors from above.
  kVAKConfigRegisterSessionLifecycle:@"AppDelegateClassName",

  // ---------------------------------------------------
  // -- VIEWS
  // ---------------------------------------------------

  // unless stated else, the following keys are all required!

  kVAKConfigViews: @[@{
      kVAKConfigClass: @"FirstViewController",
      kVAKConfigClassContext: {
          kVAKConfigSelector: @"viewDidAppear",

          // optional. an enum that's bound to AspectOptions
          // defaults to "After"
          kVAKConfigIntercept: @(VAKInterceptAfter),

          // optional. defaults to a block given
          kVAKConfigInterceptionBlock: aCustomBlock,

          // optional. an array of tags.
          // only makes sense if you are using the default block
          // else you can specify everything yourself
          kVAKConfigTags: @[ @"tag1", @"tag2" ],

          // optional. defaults to VAKLevelInfo enum
          // only makes sense if you are using the default block
          // else you can specify everything yourself
          // TODO
          kVAKConfigLogLevel: @(VAKLevelInfo) // 6

      }, {

      // Another ViewController
      kVAKConfigClass: [SecondViewController class],
      kVAKConfigClassContext: @[@{
          kVAKConfigSelector: @"viewDidAppear",
          // all keys as seen above. keys omitted for brevity

      }, {
        kVAKConfigSelector: @"anotherCoolMethodToCall",
        // all keys as seen above. keys omitted for brevity

      }]
    }],

  // ---------------------------------------------------
  // -- EVENTS
  // ---------------------------------------------------

  kVAKConfigEvents: @{
    // same options as in VAKConfigViews.
  }

}

```
## Multiple ways to skin a cat

__First: Configuration Dictionary__

Use the configuration file shown above in it's entirety. Use the ```kVAKConfigViews``` and ```kVAKConfigEvents``` sub-dictionaries to configure your logging needs.

Keep in mind that you won't get an immediate feedback from your IDE if an object (eg a view controller) and/or a method with a specific signature doesn't exist. It will however not crash your app. It'll NSLog a message for you to inspect later.
The advantage of this approach is, that you could easily put the complete config in a *.json or *.plist file and load it on app start up, with the disadvantages that you will not get any validation.

__Second: Configuration Partial Dictionary__

You could also just use the general part of the configuration dictionary. This handles some default configuration of shipped backends for you.
Add custom backends etc.

Afterwards you could use the ```NSObject+VAKAspect.h``` category, that comes with the ```vak_intercept```methods (class and instance based) to configure your logging needs in a single spot. This also has the huge advantage that you'll get notifications from your IDE and if something is in fact broken the app won't build.

__Third: Manual__

Or just configure the manager manual. Keep in mind, that no defaults are going to be set this way and the hard work is your's to do.


Either way you configure the logManager it's perfectly fine to mix and match the various methods as you wish to. 
Also keep in mind that you can scatter calls to the logManager all over your code base if you wish to do so, just for the sake of simplicity.

## Convenience

For the developer's convinience there are now some manager macros that help to be less verbose, which can be found in the ```VAKMacros.h```.

```
// this records state by passing in a VAKStateProtocol instance
VAK_RECORD(state);

// records a state by passing in a dictionary
// internally uses the VAK_RECORD
VAK_RECORD_DICT(dict);

// the name says it all: it starts a session 
VAK_START_SESSION();

// again the name hopefully conveys the meaning: calling this macro closes an open session
VAK_CLOSE_SESSION();

```

Also note that if there doesn't exist an open session when adding states, a session is automatically openend for you.

## API Documentation

If you're interested or need to check out something, you could easily do it be looking at the api documentation in the ```documentation``` folder.

# License

[Aspects](https://github.com/steipete/Aspects) by Peter Steinberger is under the MIT license.
[CouchbaseLite](https://github.com/couchbase/couchbase-lite-ios) by the couchbase team is licensed under the Apache License 2.0. For more details on how the subcomponents are licensed feel free to go to the [couchbase lite readme file](https://github.com/couchbase/couchbase-lite-ios#license)
[Specta](https://github.com/specta/specta) and [Expecta](https://github.com/specta/expecta) by the Specta team are under the MIT license.
[OCMock](https://github.com/erikdoe/ocmock) by Erik Dörnenburg is under the Apache License Version 2.0.
