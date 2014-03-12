## Constructors

We want to be able to write powerful patterns for object creation and to accomplish that, we need constructors. Learning how to write them concludes our chapter on functions, but the real power of constructors comes with inheritance which will be our topic in the next chapter. To prepare ourselves, we will look at constructors and how to use them.

JavaScript has no classes, but constructors can work similarly while providing more flexibility and expressiveness than classes. That is because traditional classes can not be altered after their definition and because objects can only be instances of one class. JavaScript allows you to only work with useful objects and to construct and combine them without too much restrictions.

### Definition
The first thing to mention is, that there is no type of constructor in JavaScript and basically every function can be a constructor. We call a function a constructor, if it creates an object in some way or the other, optionally modifies the object and then returns it. Constructors are often used in conjunction with the `new` keyword, in which case the `new` operator takes care of creating an object and returning it. But we will look also look at constructors that take care of everything themselves. The name capitalization convention does not apply to all constructors, but only those, that do not handle object creation themselves. That includes all functions, that are meant to be called with `new`. It is possible to write functions, that take a constructor as an argument, create a new object and invoke the constructor with that object. To indicate, whether a constructor function creates its own object or not, those that don't are assigned names with capital first letters. You can call any function as a constructor by using `new` (as previously discussed in [04.02.03](#04.02.03)), but that does not generally makes sense.

```javascript
var myConstructor = function () {
    return { };
};
```
Above, you can see a minimal constructor function that just creates a new object using the object literal and then returns that object. Inside a constructor, you can build an object to your liking, adding properties and methods to it.
```javascript
var person = function (name) {
    var that = { };
    that.name = name;
    that.greet = function () {
        return 'Hello, I am ' + this.name + '!';
    };
    return that;
};
```
Here, we use `that` as our internal name for the new object. Remember that `this` is a readonly variable and cannot be assigned a new value. But it does not really matter, what our new object is called inside its constructor.

---

In [04.02.03](#04.02.03) I talked about how I don't like the `new` operator, because it obfuscates JavaScripts internal logic. While you will encouter `new` in books and on the internet, it bugs me to see the `new` operator and so I will replace it with the following function:
```javascript
Function.prototype.create = function () {
    var that = Object.create(this.prototype || { }),
        theOther = this.apply(that, arguments);
    that.constructor = this;
    return (typeof theOther === 'object' && theOther) || that;
};
```
Calling the `create` method on a constructor function results in almost the exact same constellation of objects and their connections as if the constructor was invoked with `new`. So, while it technically does not matter, the `create` method makes for a less confusing reading of code. We will come back to the `create` method in a moment.

### Using Constructors
Instead of classes, we define functions that can be used as constructors:
```javascript
var Movie = function (title, director) {
    this.title = title;
    this.director = director;
};
var pulpFiction = Movie.create('Pulp Fiction', 'Quentin Tarantino');
```
The constructor function takes two arguments that it attaches to `this`. In [04.02.03](#04.02.03) we learned, that using the `new` keyword creates a new object, that is bound to the constructor's `this`, and returns the new object.

To make the objects, we create, more interesting and useful, we can add a method to it. Just like we can add string properties to the new object, we can add function properties (methods) to it:
```javascript
var Movie = function (title, runtime) {
    this.title = title;
    this.runtime = runtime;
    this.isLong = function () {
        return this.runtime > 120;
    };
};
var psycho = Movie.create('Psycho', 109);
psycho.isLong(); // false
```
Adding methods seems easy. But the problem with the above is, that the function expression is evaluated each time the constructor is called. That means, that there will be multiple instances of the same function in memory. Because of the late binding of `this`, that would not be necessary. `this` is bound, when the function executes, so we could use the function, without attaching it as a member to the object.
```javascript
var isLong = function () {
    return this.runtime > 120;
};
isLong.call(psycho); // false
```
But is this a better solution? It feels awkward to call a function like this and we would also like the function to have a closer syntactical relationship with the objects it is working with. We will look at two ways of using one function that is available to all `movie` objects.

### Altering the prototype
A common pattern is to attach methods to a constructor's prototype.
```javascript
var Movie = function (title, runtime) {
    this.title = title;
    this.runtime = runtime;
};
Movie.prototype.isLong = function () {
    return this.runtime > 120;
};
var pulpFiction = Movie.create('Pulp Fiction', 154);
pulpFiction.isLong(); // true
```
A method, defined this way, behaves a bit like a public static method in Java. It is accessible to every instance, created by the `Movie` constructor, and is visible to the outside. The difference is, that static methods in Java have no access to instance variables like `this`, whereas in JavaScript, they have (again, because of the late binding of `this`). This feature is essential to building constructors and objects in JavaScript.

Another one of those essential features will help us complement the public static method with a pattern for writing private static methods as well as private instance variables.

### Using closure
The second way of exposing a method to every object with a given constructor, without creating multiple function objects for that method, uses one of the most powerful features of JavaScript: Closure. Using closures with constructors will be our topic for almost every other pattern in this chapter. Since we just created a public static method, we can now create a private static method.
```javascript
var Movie = (function () {
    var isLong = function () { return this.runtime > 120; };
    return function (title, runtime) {
        this.title = title;
        this.runtime = runtime;
        console.log(this.title + ' is' + (isLong.call(this) ? '' : ' not') + ' a long movie.');
    };
}());
```
Again, "static" means, that it is shared by all instances of that "class", but that it can have access to instance variables.

### Private Variables
The most important use for closures in constructors is for creating private instance variables.
```javascript
var Movie = function (title, runtime) {
    this.title = title;
    this.isLong = function () { return runtime > 120; };
};
var memento = Movie.create('Memento', 113);
memento.isLong(); // false
```
The `runtime` variable is accessible inside the constructor function even when it has returned. But the variable is not added as a member to `this` or any object and is thus not visible from the outside. The `isLong` function can use the `runtime` variable because of closure and everytime, you call that method, it gives you the correct result. The scope, in which `runtime` exists, lives on, but is unnaccessible from code outside of the constructor. 

Some people attach variables they consider private to the object and prefix their name with an underscore to indicate that it is a private variable. It does not really make sense to use privacy by convention when there is also privacy by technology. When you see variables, starting with underscores, in someone else's code, respect their proclamation of privacy for these variables, but do not rely on it in your own code - use closure instead.

### BONUS: `create`
Above, I proposed a function to be used instead of the `new` keyword. I find it convenient to save this function as `Function.prototype.create`.
```javascript
Function.prototype.create = function () {
    var that = Object.create(this.prototype || { }),
        theOther = this.apply(that, arguments);
    that.constructor = this;
    return (typeof theOther === 'object' && theOther) || that;
};
```
Because I personally dislike the use of `new` for obscuring what is going on behind the scenes and because building a replacement can teach you a lot, I stick with the `create` method. Sadly, there are a few issues with this function. One of them is, that this function cannot be used to create objects from builtin constructors like `Boolean`, `String` or `Date`. That is because the objects, created by these constructors, are internally being differentiated from standard "Object" objects.
```javascript
var b0 = Boolean.create('true');
b0.valueOf(); // TypeError: valueOf method called on incompatible Object

var n0 = Number.create('1337');
+n0; // TypeError: valueOf method called on incompatible Object

var d0 = Date.create();
console.log(d0); // undefined
typeof d0; // 'object'
```
The `Date` constructor is especially interesting: Its prototype is a `Date` object with the information `Invalid Date`. When the constructor is invoked (without `new`, but with `apply`), it returns a string representation of the current date. This string fails the condition in the return statement and thus `that` is returned which still holds the invalid date. So the new object is an object, but it logs `undefined` to the console.

The above version of `create` does work with the `Array` and `RegExp` constructors, but the wrappers for primitive values and the `Date` constructor are not.

While you should not really use the wrapper objects anyway, there is no way around a `Date` object. The best solution is probably, to catch this special case.
```javascript
Function.prototype.create = function () {
    if (this === Date) {
        return new (Function.prototype.bind.apply(this, Array.prototype.slice.call(arguments)));
    }

    var that = Object.create(this.prototype || { }),
        theOther = this.apply(that, arguments);
    that.constructor = this;
    return (typeof theOther === 'object' && theOther) || that;
};
```
The same trick sadly does not work for `Boolean`, `String`, `Number` and `Function`, but again, why would you use these functions anyway? To make our `create` function more robust, we can catch all the cases in which invoking it would not make too much sense.
```javascript
Function.prototype.create = (function () {

    var incompatibleBuiltins = [
        Boolean,
        Function,
        Number,
        String
    ];

    return function () {
        if (typeof this === 'function' && incompatibleBuiltins.indexOf(this) === -1) {
            if (this === Date) {
                return new (Function.prototype.bind.apply(this, Array.prototype.slice.call(arguments)));
            }

            var that = Object.create(this.prototype || { }),
                theOther = this.apply(that, arguments);
            that.constructor = this;
            return (typeof theOther === 'object' && theOther) || that;
        } else {
            throw new TypeError('Cannot use Function.prototype.create on non-function or builtin constructor.');
        }
    };
}());
```
As you can see, we use the builtin `TypeError` function with `new`. It generally works with `create`, but when it is thrown, it does not include information about the code that triggered the exception.

Another difference between `new` and `create` is, that `new` does not attach a `constructor` property to the object that is created.