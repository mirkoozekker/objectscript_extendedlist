# XList
Extended list for ObjectScript with support for functional programming

## Introduction
Besides extended methods to instatiate lists, insert and remove items the XList provides support for functional programming.
Key to this feature is wrapping methods as objects itself to be able to pass them to other methods. Therefore with the XList comes a bunch of classes to express methods as objects.
For example if you want to use methods or properties of the items contained in your list you would use the InstanceMethod- and InstanceProperty-classes. If you want all items in the list being passed to any classmethod just create a corresponding ClassMethod-Object and pass it to the dedicated function of the XList.

Functional programming has a massive impact on understanding what a piece of code tries to achieve because it is more human readable than a couple of lines iterating through list items and and checking and setting some values.

## Examples
Imagine you have a list of objects and then think about the amount of code you have to write to get the biggest value for the property "Height" of all items in the list.
In the extended list you can program it functionally as a one-liner and it looks like this:
```
set biggestHeight = xListOfObjects.max(##class(util.InstancePropertyConverter).create("Height"))
```
In the same manor you can get the item having the biggest value:
```
set biggestHeightItem = xListOfObjects.maxItem(##class(util.InstancePropertyConverter).create("Height"))
```

Getting a sublist with all items that have their property "Description" empty:
```
set subXList = xList.select(##class(util.InstancePropertyEqualsConverter).create("Description",""))
```

How about summing up the item's prices (Property "Price"):
```
set sum = xList.sum(##class(util.InstancePropertyConverter).create("Price"))
```

Also the XList provides functions to deal with usual lists.
Let's say you have a ususal %ListOfDataTypes containing Ids (primary keys) and you want to gather all the corresponding objects:
```
set xListOfObjects = ##class(util.XListOfDataTypes).listConvertAll(usualList, ##class(util.ClassMethodConverter).create("myPackage.MyClassName", "%OpenId", 0))
```

Or just pass all items to your coolServiceMethod which expects a listItem as parameter:
```
do xListOfObjects.foreach(##class(util.ObjectMethodAction).create(myCoolServiceInstance, "myCoolMethod"))
```

## Installation
Just import the classes to your namespace in your favourite way.

## Additional
Of course you can use the method and property wrapper classes of this project not only with the XList but in any case you could think of in which passing a method or a property-getter to another method would be helpful.
