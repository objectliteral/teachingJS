## Invocation

Invoking a function means stepping out of the execution order of the current function and entering the execution of the invoked function. Additionally, variables can be bound to function parameters. A function is invoked by an invocation expression. That is an expression that, when evaluated will call the function. There are four invocation expressions.

They all have in common that they use a pair of parentheses to indicate the function invocation. Inside these parentheses can be a comma-seperated list of values that are passed to the function invocation. It does not matter whether the number of arguments passed matches the number of formal parameters of the function. In JavaScript there is no way to require function parameters to have certain types. Basically you can pass a function anything you want and you will never get an error from the interpreter.

### Special variables
To understand the difference between them, it is important to realize, that besides the parameters, that are explicitly passed to the function in the invocation expression, two special variables are available inside every function: `this` and `arguments`.

`arguments` is an array-like object that contains a list of all values, passed to the function, when invoked. This is completely independent of what parameters are mentioned in the function definition. (More on `arguments` in [04.04.01](#04.04.01))

`this` is a variable containing a reference to the object the function is concerned with. Calling a method on an object for example lets the method's `this` be that object. The binding of `this` does not happen at compile time nor at the time a function is defined. The binding happens, when the function is executed. The following invocation expression are different in the way they bind `this`.

### Method invocation
When a function is a member of an object, it is usually called a method. A method is called by appending a pair of parentheses to a qualified function value.

```javascript
obj.func();
obj['func']();
```
If the function does not use `this`, then it might not matter that it was called like this. But when it does, `this` is bound to the object, on which the method is called on; meaning the object whose property the function is. 
This way a function can access its parent object and all of its other properties.
```javascript
var cantina = {
    location : 'Mos Eisley',
    where : function () { return 'The Cantina is in ' + this.location; }
};
cantina.where(); // 'The Cantina in Mos Eisley'
```

Of course, methods can not only read but also write properties of their `this`.
```javascript
var status = {
    message : 'I am not quite ready yet',
    getMessage : function () {
        return this.message;
    },
    setMessage : function (update) {
        this.message = update;
    }
};
status.setMessage('Let\'s go!');
status.getMessage(); // 'Let\'s go!'
getMessage(); // ReferenceError: getMessage is not defined
```
Keep in mind that the `this` object does not necessarily have to be an object containing the function. Soon we will learn ways to bind any object to any function so liberate yourself from the sense that their is a very special relationship between objects and their methods.

### Function invocation

If a function does not concern itself with a certain object or is not even a member property of one, it might aswell be invoked as a simple function. The identifier that resolves to the function value will not contain any refinements in such cases.
```javascript
var func = function () {
    console.log('Invocation successful');
};
func(); // 'Invocation successful'
```

Unfortunately, in most implementations of the language, function invocation makes `this` be bound to the global object. In web browsers that is the `window` object.
```javascript
var getGlobal = function () {
    return this;
};
getGlobal() === window; // true
```
This is almost always unintended behavior. You would also expect, that scoping applies to `this`, but it does not, which means that an outer functions `this` is not visible inside an inner function.
```javascript
var obj = {
    outer : function () {
        console.log(this === obj);
        var inner = function () {
            console.log(this === window);
        };
        inner(); // true
    }
};
obj.outer(); // true
```
The interpreter binds an individual value to every function invocation even if that value does not make sense. Because the implicit binding of the global object to `this` it is very easy to accidentally add properties to the global object. This is generally not good and especially when unintended. In ES5 strict mode, `this` is bound to the `undefined` value in functions that are being invoked via function invocation. This is not great, but better than the previous solution. (More on strict mode in XX.XX).
```javascript
var getUndef = function () {
    'use strict';
    return this;
};
getUndef() === undefined; // true
```

### Constructor invocation
This invocation mechanism makes use of the `new` keyword. If a method invocation or function invocation is prefixed with `new`, that tells the compiler to treat the function being called as a constructor. What constructors really are will be our topic very soon, but let's look at how they are called. All you need to know now is that constructors are functions. They are not inherently special but become special because of the way they are invoked: Using `new`.

The `new` operator does some magic, but step-by-step we will uncover its secrets. There are mainly three things, `new` does:
1. Creating a new object,
2. calling the function that `new` is used with, binding the function's `this` to the new object and
3. returning the object (unless the constructor has its own return value).
Let's see that in action!
```javascript
var Spacestation = function (name) {
    this.name = name;
};
var deathstar = new Spacestation('Death Star');
console.log(deathstar); // { name : 'Death Star' }
```
The constructor invocation returned an object that has the property that was assigned to it from inside the function. In future chapters we will be talking a lot about constructors. What you need to understand is, that they are just functions. If the `new` keyword irritates you, you could write a function to replace the `new` keyword; a very simple version would look somewhat like this:
```javascript
var construct = function (fn) {
    var that = { };
    fn.apply(that);
    return that;
};
```
It takes a constructor function as an argument, creates a new object, calls the function, binding the object to the function's `this` and returns the new object. This function is simplified and we will enhance it to be capable of dealing with inheritance in [chapter 04.07](#04.07.01). For now it would be great if it could accept additional parameters and pass them on to the constructor function.
```javascript
var construct = function (fn) {
    var args = Array.prototype.slice.call(arguments, 1),
        that = { };
    fn.apply(that, args);
    return that;
};
```
This `construct` function passes every additional argument it receives on to the actual constructor function. Don't worry if that "Array" things looks cryptic: You will get to know it in one of the next subchapters. Let's use our newly created helper function.
```javascript
var Spacestation = function (name) {
    this.name = name;
};
var deathstar = construct(ConstructionService, 'Death Star');
console.log(o); // { name : 'Death Star' }
```


Using functions that expect to be called via constructor invocation has a serious drawback: When you omit the `new`, when calling such a function that was intended to be used as a constructor, it might fail to return a new object. It relies on the `new` keyword to create an object for it and if that is left out, there will be no object. Even worse: Remember that when a function is called without an object to be concerned with, `this` is bound to the global object. Constructors usually add properties to `this` so these will end up becoming global variables inside your program. You do not want that.

It is a common convention (not just in JavaScript) to start the name of a constructor function with a capital letter and to not use capital letters at the beginning of any other variable name. 

Another issue with the `new` operator is, that it obscures JavaScript's nature and disguises it as being a classical language. But since JavaScript does not use classical inheritance, related programming patterns may not be adequate. More on inheritance in [chapter 5](#05.00.00). While looking familiar to programmers, coming from classical languages like Java, the `new` prefix is likely to be the source of confusion. In the following I will not use `new` anymore but our `construct` function from above. We will see an advanced version of `construct` that does exactly the same as the `new` prefix does and in examining the `construct` function you can see, what `new` does under the hood.

### Call/Apply Invocation
The fourth invocation expression for functions is maybe less commonly used but offers a great deal of flexibility. Inheriting from `Function.prototype`, every function has an `apply`- and a `call`-method (remember that functions are objects and can have their own methods). These allow you to explicitly specify the value of `this`.
```javascript
var cantina = {
    location : 'Mos Eisley'
};
var where = function () { return 'The Cantina is in ' + this.location; };
cantina.where(); // TypeError: cantina.where is not a function
where.apply(cantina); // 'The Cantina in Mos Eisley'
where.call(cantina); // 'The Cantina in Mos Eisley'
```
The function `where` is invoked with `cantina` as `this`. So while the `where` function is defined completely independent of any object, it can access one as `this` when called with the `call` or `apply` method. These methods illustrate the late binding of `this`, happening not until the function is executed.

The difference between `call` and `apply` is the way in which they receive arguments. `apply` expects exactly two arguments: The object to be bound to `this` and an array with values to be passed as arguments to the function. `call` expects an arbitrary number of elements, of which the first is being bound to `this` and the rest is being passed as arguments to the function.
```javascript
var spacestation = function (name, system) {
    this.name = name;
    this.system = system;
};
var yavin = spacestation.apply({}, ['Yavin Station', 'Yavin System']);
var forge = spacestation.call({}, 'Star Forge', 'Lehon System');
```

### Binding `this`
In some cases, the automatic binding of `this` is not what you want. You control the binding by using `call`/`apply`. Consider the following example:
```javascript
var Person1 = {
    name : 'Bob',
    getName : function () { return this.name }
};

var Person2 = {
    name : 'Alice'
};
```
Alice has no `getName` method, but we can use the one, Bob has, to return Alice's name. Therefore, we use `apply` to bind `Person2` to `getName`'s `this` property:
```javascript
Person1.getName.apply(Person2); // 'Alice'
```
The automatic binding of `this` is a serious pitfall for people, new to JavaScript, (and more often than not even for experienced JavaScripters). Special care has to be taken, when passing around callbacks and attaching those to event handlers.

Another way to control the binding of `this` is by using the `Function.prototype`'s `bind` property. Calling `bind` on a function returns a new function, that, when executed, uses the first argument that was passed to the `bind` call, as `this`. An alternate solution to the previous example would then look like this:
```javascript
var getPerson2sName = Person1.getName.bind(Person2);
getPerson2sName(); // 'Alice'
```
We created a new function, that returns the `name` property of the `Person2` object. You could write `bind` yourself, if you wanted to.
```javascript
Function.prototype.binding = function (obj) {
    var args0 = Array.prototype.slice.call(arguments, 1),
        def = this;
    return function () {
        return def.apply(obj, args0.concat(Array.prototype.slice.call(arguments)));
    };
};
```