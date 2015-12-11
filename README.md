# Shift
A library of custom iOS View Controller Animations and Interactions written in Swift.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/raizlabs/shifter)

<p align="center" >
<br/>
<img src="https://raw.github.com/raizlabs/shift/master/SplitTransition.gif" alt="Overview" />
<br/>
</p>

## Installation with Carthage

Carthage is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with Homebrew using the following command:

```
$ brew update
$ brew install carthage
```

To integrate Shift into your Xcode project using Carthage, specify it in your Cartfile:

`github "raizlabs/shift"`

## Installation with CocoaPods

... Coming soon.

## Usage

First, make sure you import the Shift Module: `import Shift`.

The rest is east. If you are pushing a view controller to the navigation stack, all you need to do 

### SplitAnimation

`SplitAnimation` exposes 4 key properties: `splitLocation`, `transitionDuration`, `transitionDelay`, and `transitionDuration`.

```
override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    navigationController?.delegate = self
    currentCell = tableView.cellForRowAtIndexPath(indexPath)
    let destinationViewController = DestinationViewController()
    destinationViewController.view.backgroundColor = colors[indexPath.row]
    navigationController?.pushViewController(destinationViewController, animated: true)
}

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


