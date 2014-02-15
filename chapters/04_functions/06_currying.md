## Currying and Partials

Currying describes a technique to divide work into multiple function executions and step by step handing in more function parameters. That way, a function that maps (x, y) -> (n) can be written as a curry function that maps (x -> (x, y) -> n). We transform a function with multiple arguments into a chain of functions, each taking only one argument.

For example, a simple add function would look like this:
```javascript
var add = function (x, y) {
    return x + y;
};
```
But if we curry that function, we can use it to create adders that each add a constant amount to their argument parameter.
```javascript
var makeAdder = function (x) {
    return function (y) {
        return x + y;
    };
};
var add1 = makeAdder(1);
var add7 = makeAdder(7);

console.log(add1(9)); // 10
console.log(add7(8)); // 15
```

The greatest benefit of currying is probably improved mainanability. A function that takes just one argument is much easier to reason about. Simplifying functions is a good thing, as bugs hide in complexity, and larger functions are harder to read, harder to memorize and harder to debug. Currying is a great feature of functional programming languages and JavaScript has the virtue of incorporating the functional paradigm as well as the object oriented and procedural style.

We can write an abstract function to transform a function into a curried version of itself.
```javascript
Function.prototype.curry = function () {
    var args0 = Array.prototype.slice.call(arguments),
        fn = this;
    return function () {
        return fn.apply(this, args0.concat(Array.prototype.slice.call(arguments)));
    };
};
```
`Function.prototype.curry` can be called on another function, taking some arguments and returning a new function. When this new function is called, it receives the arguments from the curry call before and any parameters that are given to the current call. Let's see our new curry wrapper in action.
```javascript
var add = function (x, y) {
    return x + y;
};

var add1 = add.curry(1);
var add7 = add.curry(7);

console.log(add1(9)); // 10
console.log(add7(8)); // 15
```
Note that the `add` function's definition is completely agnostic of the fact that it gets curried. If you would give more parameters to either the curry call or the actual function call, those extra parameters would be ignored.

### Partials
Another feature of curried functions is, that you can partially apply them. That means, that you provide as many arguments as you can and hand in the rest later. 
```javascript
var addXYZ = function (x) {
    return function (y) {
        return function (z) {
            return x + y + z;
        };
    };
};
var add3toYZ = addXYZ(3);
var add7toZ = add3toYZ(4);
var add8toZ = addXYZ(2)(6);
var fourteen = addXYZ(4)(7)(3);
```
As soon as you have computed the first argument for a function, you can partially execute the function, saving it for later, when the other arguments are ready. But you always have the alternative of calling a curried function with all the arguments at once, if you want to.

You can use the `bind` method to do partial application, since it not only an object as a parameter, but also an abitrary number of arguments to pass on to the call of the new function.
```javascript
var add = function (x, y) {
    return x + y;
};
var add1 = add.bind(this, 1);
```

### Composition
Sometimes you may want to create a function that is the composition of two other functions. That way you can have a function perform a complex task that constitutes of smaller functions solving parts of the problem. A function that composes two functions can look like this:
```javascript
Function.prototype.compose = function (fn0) {
    var fn1 = this;
    return function () {
        return fn1.call(this, fn0.apply(this, arguments));
    };
};

var square = function (x) { return x * x; };
var double = function (x) { return 2 * x; };

var squareThenDouble = double.compose(square);
var doubleThenSquare = square.compose(double);

console.log(squareThenDouble(3)); // 18
console.log(doubleThenSquare(3)); // 36
```
In the end you don't have to know about the parts that made up the more complex function. So while `squareThenDouble(X)` does the same as `double(square(X))` you no longer have to remember or have access to the simple functions.
