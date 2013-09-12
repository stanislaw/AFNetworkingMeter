# AFNetworkingMeter

![AFNetworkingMeter demonstration](https://raw.github.com/stanislaw/AFNetworkingMeter/master/AFNetworkingMeter.png)

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

* Stanislaw Pankevich
* Marina Balioura (@mettta) - assistance in working out the design of
the formatted report AFNetworkingMeter produces. Invaluable!

## Copyright

Not yet.
