# Shift
A library of custom iOS View Controller Animations and Interactions written in Swift.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/raizlabs/shift)

## Installation with Carthage

Carthage is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with Homebrew using the following commands:

```sh
brew update
brew install carthage
```

To integrate Shift into your Xcode project using Carthage, specify it in your Cartfile:

`github "raizlabs/shift"`

## Installation with CocoaPods

... Coming soon.

## Usage

First, make sure you import the Shift module: `import Shift`.

The rest is easy. If you are pushing a view controller to the navigation stack, follow these three steps:

- Set your navigation controller's delegate :

```swift
navigationController?.delegate = self
```
- Store the transition on your view controller:

```swift
var currentTransition: UIViewControllerAnimatedTransitioning?
``` 

- Extend your view controller to implement `UINavigationControllerDelegateTransitioning`. In your implementation, make sure to set the `currentTransition`:

```swift
extension ViewController: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if (operation == .Push && fromVC == self) {
			/*
			* set currentTransition here
        	*/
        }
        else if (operation == .Pop && toVC == self) {
        }

        return currentTransition
    }
}

```

### SplitAnimation

<p align="center" >
<br/>
<img src="https://raw.github.com/raizlabs/shift/master/SplitTransition.gif" alt="Overview" />
<br/>
</p>

`SplitAnimation` exposes 4 key properties: 

1. `splitLocation` (optional, defaults to `0.0`) - y coordinate where the top and bottom views part
2. `transitionDuration` (optional, defaults to `1.0`) - duration (in seconds) of the transition animation 
3. `transitionDelay` (optional, defaults to `0.0`) - delay (in seconds) before the start of the transition animation
4. `transitionType` (optional, defaults to `.Push`) - `.Push` or `.Pop`

Set these properties in your implementation of	`UINavigationControllerDelegateTransitioning`:

```swift
func navigationController(navigationController: UINavigationController,
    animationControllerForOperation operation: UINavigationControllerOperation,
    fromViewController fromVC: UIViewController,
    toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

    if (operation == .Push && fromVC == self) {
        let splitTransition = SplitTransitionController()
        splitTransition.transitionDuration = 2.0
        splitTransition.transitionType = .Push
        splitTransition.splitLocation = currentCell != nil ? CGRectGetMidY(currentCell!.frame) : CGRectGetMidY(view.frame)
        currentTransition = splitTransition
    }
    else if (operation == .Pop && toVC == self) {
        currentTransition?.transitionType = .Pop
    }

    return currentTransition
}
```


