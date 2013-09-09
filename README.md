LinkedIn iOS
===

There's no *working* LinkedIn iOS library out there. How about that, uh ? So we extracted this, from a current project we are working on.

Some facts : 

  - You must use ARC
  - No dependencies, it uses NSUrlConnection for the http requests and NSXmlParser for the xml parsing
  - For now, it only allows you to sign in and fetch user first and last name, and also its profile picture url
  - There's still plenty to be done, but it works for simple needs such as mine were

How to use ?
---

It's pretty straightforward. 

  1. Declare an app to [LinkedIn](https://www.linkedin.com/secure/developer)
  2. Copy the content of `LinkedInIos-sample/LinkedInIos-sample/LinkedIn` into your project
  3. In your `.plist`, input the 3 mandatories values
  4. In your view controller, add the `<LISignInDelegate>` (add this : `#import "LISignIn.h"`)
  5. Implement `- (void)finishedLIAuthentificationWithError:(NSError *)error;`
  6. ???
  7. Profit !

Look at the code in the `ViewController`class of the sample project for more details on step 6. Step 7 is optionnal, but recommended.
