## Closure

Along with prototypal inheritance, closure is the most important concept in JavaScript. It is easy to learn and very powerful. It allows JavaScript to be written in a very expressive way and to utilize it to facilitate a flexible programming approach as well as to build creative patterns.

A major aspect of closures is lexical scoping, which we have already covered in [04.03](#04.03.00). Lexical scoping is the reason, that in the following code

```javascript
var f0 = function () {
    var priv = 'my secret',
        helper = function () {
            console.log(priv);
        };
    return helper;
};
```

the function `helper` has access to the variable `priv`. But what happens, when `priv` is altered during runtime, or when `f0` has returned?

Closure means, that, when a function is invoked, it gets a reference to its lexical environment. As a consequence, a function will always have access to all the variables that were accessible in the scope in which the function was declared.

Example:
```javascript
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
```javascript
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

### Sealer/Unsealer
Another example for the use of closures is a sealer. You can put values into a vault where nobody can access it, unless they have a key. The key will be an object which makes it unspoofable. The following code describes a function that creates vaults.

```javascript
var vaultmaker = function () {

    var keys = [],
        values = [];

    return {
        seal: function (secret) {
            var key = {},
                l = keys.length;
            keys[l] = key;
            values[l] = secret;
            return key;
        },
        unseal: function (key) {
            for (var i = 0; i < keys.length;
                i = i + 1) {
                if (keys[i] === key) {
                    return values[i];
                }
            }
        }
    };
};
```
Of course the `keys` and `values` arrays are closed over by the `vaultmaker` function and cannot be accessed from the outside. When you seal a secret, you get the key as a return value. This key and only this key can retrieve the value from the vault.

```javascript
var vault = vaultmaker();
var key = vault.seal('this is secret information');

console.log(vault); // { seal: [Function], unseal: [Function] }

console.log(vault.unseal({})); // undefined

console.log(vault.unseal(key)); // 'this is secret information'
```

### Memoization
We can use closure, to speed up algorithms significantly. Take the Fibonacci numbers for example. Tradionally you would write an algorithm, computing the Fibonacci number of n, in a recursive fashion.

```javascript
var fib = function (n) {
    return n < 2 ? 1 : fib(n-1) + fib(n-2);
};
```
While being easy to implement, this solution has the drawback of poor performance. Most of the computation time is spent, calculating the same intermediary results repeatedly. A great speedup could be achieved by simply saving all the results that have been computed so that they can be immediately returned, when they otherwise were calculated again. We can do that, by creating a closure, containing an array to put our results in and the actual formula. We create a new function, that looks up the result for a given input in the result array and only starts the actual calculation if this result has not yet been calculated. This technique is called memoization and our `memoize` function can look like this:
```javascript
var memoize = function (fn) {
    var memo = [],
        self = function (x) {
            if (typeof memo[x] !== 'number') {
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