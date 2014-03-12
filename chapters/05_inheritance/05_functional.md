## Functional

We continue with implementing a feature we have already learnt about in [04.07.05](#04.07.05): Private instance variables. The solution to achieving privacy is based on closure. Closure allows us to create powerful constructors or factories and now we will combine that with inheritance.

The most important difference may be, that we now write functions, that take care of object creation themselves rather than relying on some exterior object injection. That means that the constructors we have written before all used `this` to refer to the object to be created. The actual object was then created by using `new` or `.bind({})` or our own `create` method. The functions below create their own objects. Some people call those functions factories as opposed to constructors. I will not use these terms very precisely.

### Recipe
The basic recipe for our constructors consists of the following four steps: Create a new object, declare private variables, add public methods to the object and return the object. Creating an object can be done in several ways: Using an object literal, with `Object.create` (possibly inheriting from another object) or calling another constructor. Private variables are simply declared via `var` and thanks to closure, they will be visible to all the other private as well as privileged methods. These methods are attached to the newly created object, which is finally returned by the constructor function.
```javascript
var person = function (name) {
    var that = { };
    var punctuation = '!';
    that.greet = function () {
        return 'Hello, I am ' + name + punctuation;
    };
    return that;
};
```
Now the `name` and `punctuation` properties are invisible from outside of the constructor function but accessible by the privileged `greet` method. But this is nothing new, we already wrote a function like this in [04.07.05](#04.07.05). It gets interesting when we create our new object by calling another constructor, now that we know of inheritance.
```javascript
var child = function (name) {
    var that = person(name);
    var favoriteSweets = 'chocolate';
    that.askForSweets = function () {
        return 'Can I haz ' + favoriteSweets + '?';
    };
    return that;
};
```
The `child` constructor looks a lot like `person`, but creates its object by calling the `person` constructor. When we execute the `child` constructor, we get just what we wanted:
```javascript
var timmy = child('Timmy');
timmy.askForSweets(); // 'Can I haz chocolate?'
timmy.greet(); // 'Hello, I am Timmy!';
```
The object provides all the correct methods, which have access to the private instance variables. But what's very important is, that we created a completely different situation than by using the constructors from [05.04](#05.04.00). The `timmy` object, inherits directly from `Object.prototype` and has a `constructor` property pointing to `Object`. There are no `person.prototype` and `child.prototype` objects. When using the "Functional" approach to factories and inheritance you thus can not longer rely on the `instanceof` operator and writing a replacement would presumably be pretty hard.

When using the pseudoclassical approach, we tried to solve the problem of making one constructor inheriting from another constructor by having the child constructor create a new object of the parent constructor and use that as a prototype for its own objects. This approach behaves like you would expect it, if you are thinking in a classical way, but is agnostic of JavaScript's nature. Objects are highly dynamic and there is no reason to expect two objects created by the same constructor to are similarly structured. It is considered "pseudoclassical" because it resembles the lineage of classes by actually tampering with the lineage of objects. That is because in JavaScript there is no other lineage. But that implies, that a classical way of thinking may not be appropriate. It is not discouraged though. The pseudoclassical pattern allows for small constructors and multiple layers of wrapping functions around them. `this` is bound externally which allows separate functions to handle inheritance. The downside is, that you probably have to standardize a specific pattern for a project for consistency.

The functional approach does not actually create a lineage, but rather deals with one object, being transformed by a cascade of constructors. When a constructor wants to inherit from another constructor, it creates a new object with its parent and then manipulates this object by adding or changing its properties. This results in a less complex situation, where the object has no massive heritage but is an heir of `Object.prototype`. The functional pattern has larger constructors that have to take care of inheritance themselves. That is not required - you could come up with a syntax to pull object creation out of the factory and into a wrapper function - but since there are no complex adjustments of prototype and `constructor` properties to be made there is not really a need for wrapping functions.

### Refinement
When constructors take more than two or three arguments, it gets difficult to remember the correct order in which the arguments need to be applied to the function. We can make that easier by using a single object as a parameter.
```javascript
var person = function (data) {
    return {
        greet : function () {
            return 'Hello, I am ' + data.name + data.punctuation;
        }
    };
};
var bob = person({
    name : 'Bob',
    punctuation : '!'
});
bob.greet(); // 'Hello, I am Bob!'
```
Now the constructor invocation has a lot more meaning to it and without remembering what the constructor signature looked like you can see, what kind of data you are calling the function with.

Since we have public and private variables, we might want to use protected variables as well. These are values shared by every object of the same lineage. Since private variables use function scope they are not visible to the parent class we have to introduce a new variable that gets passed around from constructor to constructor.
```javascript
var person = function (data, shared) {
    var shared = shared || { };
    shared.id = data.id;
    var that = { };
    return that;
};
var child = function (data, shared) {
    var shared = shared || { };
    var that = person({ id: generateID() }, shared);
    that.testId = function (id) {
        return id === shared.id;
    };
    return that;
};
var timmy = child();
```

Because there is no common prototype for all objects of one constructor - there is, but it is `Object.prototype` - its not possible to make changes, that affect all objects created by one constructor. That means, that it is not longer possible to write public static variables. It is still possible though to use private static variables by encapsulating the constructor in an IIFE:
```javascript
var child = (function () {
    var classID = 2; // private static
    return function (data) {
        var that = person(data);
        that.hasClassID = function (id) {
            return id === classID;
        };
        return that;
    };
}());
```
You can use static functions if you want to avoid creating a whole lot of functions each time the constructor is called. The drawback is, that those functions will no longer have access to private instance variables but only to private static variables and `this`, when bound.
```javascript
var child = (function () {
    var classID = 2;
    var hasClassID = function (id) {
        return id === classID;
    };
    var greet = function () {
        return 'Hello, I am ' + this.name + '!';
    };
    return function (data) {
        var that = person(data);
        that.hasClassID = hasClassID;
        that.greet = greet.bind(that);
        return that;
    };
}());
```