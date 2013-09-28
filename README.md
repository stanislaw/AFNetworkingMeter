# AFNetworkingMeter

![AFNetworkingMeter demonstration](https://raw.github.com/stanislaw/AFNetworkingMeter/master/AFNetworkingMeter.png)

## Overview

AFNetworkingMeter is a grateful child of AFHTTPRequestOperationLogger created by Mattt Thompson (@mattt) for AFNetworking library. It is not the one: there is also its closest brother and companion [AFNetworkingLogger](https://github.com/stanislaw/AFNetworkingLogger) - they share similar design and are both built for the same purpose: to make a HTTP-logging routine for a daily basis of iOS/Mac development easy and informative.

Docs are coming...

## Installation

The recommended way is to install via Cocoapods:

Add into your Podfile:

```ruby
pod 'AFNetworkingMeter', :git => 'https://github.com/stanislaw/AFNetworkingMeter'
```

And run 

```
pod update
```

or you can just clone `AFNetworkingMeter` repository using `git clone` and copy the contents of its `AFNetworkingMeter/` folder to your project.

## Usage

You need to start `AFNetworkingMeter` somewhere. For example, your app's delegate is a good place to do this:

```objective-c
#import <AFNetworkingMeter.h>

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkingMeter sharedMeter] startMeter];

    return YES;
}
```

Then, whereever you need to know statistics for AFNetworking HTTP interactions, ask `AFNetworkingMeter` to produce a formatted report and feel free to print it into your Xcode console.

```objective-c
NSString *HTTPReport = [AFNetworkingMeter sharedMeter].formattedReport;
NSLog(@"Let's see the HTTP Report: %@", HTTPReport);
```

## Lazy reporting

...

## TODO

...

## Credits

AFNetworkingMeter was created by Stanislaw Pankevich.

Thanks to Marina Balioura (@mettta) for her assistance in working out the design of
the formatted report `AFNetworkingMeter` produces. Invaluable!

`AFNetworkingMeter` is a plugin for [AFNetworking](https://github.com/AFNetworking/AFNetworking) library created by [Mattt Thompson](http://github.com/mattt).

AFNetworkingMeter is inspired by the design of another `AFNetworking` plugin [AFHTTPRequestOperationLogger](https://github.com/AFNetworking/AFHTTPRequestOperationLogger), that was as well created by [Mattt Thompson](http://github.com/mattt).

## Copyright

Not yet.
