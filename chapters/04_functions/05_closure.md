## Closure

Along with prototypal inheritance, closure is the most one of the most important concepts in JavaScript. It is easy to learn and very powerful. It allows JavaScript to be written in a very expressive way and to utilize it to facilitate a flexible programming approach as well as to build creative patterns.

A major aspect of closures is lexical scoping, which we have already covered in [04.03](#04.03.00). Lexical scoping is the reason, that in the following code

```
var f0 = function () {
    var priv = 'my secret';
    return helper = function () {
        ...
    };
};
```

the function `helper` has access to the variable `priv`. But what happens, when `priv` is altered during runtime, or when `f0` has returned?

Closure means, that, when a function is invoked, it gets a reference to its lexical environment. As a consequence, a function will always have access to all the variables that were accessible in the scope in which the function was declared.

Example:
```
var counter = (function () {
    var count = 0;
    return {
        get : function () {
            return count;
        },
        incr : function () {
            count = count + 1;
        }
    };
}());
```
We create an object, that can increment a counter and return the current counter value. The `counter` variable is assigned the result of calling an anonymous function, that declares a local variable `count` and returns an object with two methods. Because of closure, these have (and will always have) access to the `count` variable. While the anonymous function immediately returns, its local variables are not destroyed.

This example leads to the question, whether there is a new `count` variable, everytime that anonymous function would be called, or whether all of the objects returned, share the same `count` variable. In order to investigate, let us rewrite the previous code.
```
var makeCounter = function () {
    var count = 0;
    return {
        getCount : function () {
            return count;
        },
        incr : function () {
            count = count + 1;
        }
    };
};

var counterA = makeCounter();
var counterB = makeCounter();

counterA.incr();

counterA.getCount(); // 1
counterB.getCount(); // 0
```
Every time `makeCounter` is called, a new execution context is created and thus a new count variable, which is visible to everything, defined in that same execution context, but nowhere outside of it including different executions of the `makeCounter` function.

SEALER/UNSEALER EXAMPLE

### Memoization
We can use closure, to speed up algorithms significantly. Take the Fibonacci numbers for example. Tradionally you would write an algorithm, computing the Fibonacci number of n, in a recursive fashion.

```
var fib = function (n) {
    return n < 2 ? 1 : fib(n-1) + fib(n-2);
};
```
While being easy to implement, this solution has the drawback of poor performance. Most of the computation time is spent, calculating the same intermediary results repeatedly. A great speedup could be achieved by simply saving all the results that have been computed so that they can be immediately returned, when they otherwise were calculated again. We can do that, by creating a closure, containing an array to put our results in and the actual formula. We create a new function, that looks up the result for a given input in the result array and only starts the actual calculation if this result has not yet been calculated. This technique is called memoization and our `memoize` function can look like this:
```javascript
var memoize = function (fn) {
    var memo = [],
        self = function (x) {
            if (typeof memo[x] !== 'number')  {
                memo[x] = fn(self, x);
            }
            return memo[x];
        };
    return self;
};

var memoizedFib = memoize(function (fib, n) {
    return n < 2 ? 1 : fib(n-1) + fib(n-2);
});
```