## Arguments

Let us now look at the way functions can receive arguments. Arguments that are passed to a function call are bound to local variables of the function execution context (scope). If a function is called, with too many arguments, the additional arguments are ignored. If a function is called, with too few arguments, the left-out parameters are initialized with `undefined`. In both cases there is no error that gets thrown or anything like that.

Since there are (especially in newer versions of the language specification) some creative ways for parameter definitions, they deserve their own sub-chapter.

One important thing to remember is, that primitives are always call-by-value and objects are always call-by-reference.

### `arguments`
`arguments` is an array-like object containing all values, that were passed to the function invocation. It is unrelated to the number of parameters defined in the function definition and thus makes it possible to write function that take an arbitrary number of arguments like the following:
```javascript
var add = function () {
    var i = 0, l = arguments.length, total = 0;
    for (; i < l; i += 1) {
        total += arguments[i];
    }
    return total;
};
```
Sadly, `arguments` is not an array. The only things it has in common with arrays is that its property names are integers starting from 0, and that it has a `length` property. In constrast to real arrays this `length` property is not magic in that changing it does not affect the contents of the `arguments` object. `arguments` inherits none of the array methods, that `Array.prototype` provides so these methods have to be called on `arguments` with `call`/`apply`. In cases where you want `arguments` to be a real array, you can convert it to one by using array methods. The common way to do the conversion is by something like this:
```javascript
var args = Array.prototype.slice.apply(arguments);
```
`slice` returns an array and since it was invoked with `arguments` as `this` but without any parameters, it does not alter the original data structure.

The values in the `arguments` object are coupled with the function's local parameter values. Changing a property on the `arguments` object affects the local variable it is tied to.
```javascript
(function (a) {

    console.log(a);

    arguments[0] = 'Batman';
    console.log(a);

    a = 'Green Lantern';
    console.log(arguments[0]);

}('Captain America'));

// 'Captain America'
// 'Batman'
// 'Green Lantern'
```
This binding does not work for parameters that were not passed to the function call (some older versions of Chrome did create the binding in those cases too, but that was not standard-compliant and got fixed). The coupling is only valid for parameters that were actually passed to the function.
```javascript
(function (a) {

    console.log(a);

    arguments[0] = 'Batman';
    console.log(a);

}());

// undefined
// undefined
```

The `arguments` object also has a property called `callee`. This property points to the function that the `arguments` object belongs to. This property was introduced to the language in order to enable anonymous functions to call themselves recursively. There once were no named function expressions in JavaScript which is why `arguments.callee` was necessary. It is no longer and its use is deprecated. In ES5 strict mode `arguments.callee` is forbidden.

Another deprecated property is `arguments.caller` which points to the function, the current function was called from. In current brwoser versions this no longer works so you can ignore that this feature once existed.

NOTICE: This `arguments` variable is not the same as `Function.prototype.arguments`. The later will mostly do the same, but its use is deprecated.

Chances are, the `arguments` object will eventually be replaced by something better. The object will sure be around for a long time (for compatability reasons), but so called "rest parameters" offer more convenience.

### Default Parameters
As of ES5.1 there is no syntax for default parameter values, but the logical OR operator `||` can be used to write short default assignments.
```javascript
(function (obj) {
    var o = obj || {};
    o.solve = function () { };
    return o;
}());
```
The above function adds a `solve` function to a given object. If no object is supplied to the function invocation a new one is created. If no argument is given to the function call, `obj` is `undefined` which is a falsy value. Because of that the `||` operator returns the result of evaluating the right hand side expression. This works just fine, but in ES6 there will be a builtin syntax for default parameters. The above would then be written as:
```javascript
(function (obj = {}) {
    obj.solve = function () { };
    return obj;
}());
```

### BONUS: Rest Parameter (ES6)
The current draft of ES6 proposes an alternative to `arguments` for dealing with indefinite number of arguments. The last parameter of a function in a function definition can be written with a prefix of three dots `...args` designating it as an array that contains all additional parameters that were passed to the function.
```javascript
(function (a, b, ...rest) {
    console.log(rest.map(function (val) {
        return val * 10;
    }));
}(9, 8, 7, 6));

// [70, 60]
```
At the time of writing, the above code will only work in Firefox (according to kangax also in IE10+ but that does not seem to work), but as more ES6 features are implemented, rest parameters are likely to find their way into all implementations.

### BONUS: Destructuring

