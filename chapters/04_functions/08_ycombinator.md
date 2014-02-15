## BONUS: y-Combinator

Let's do something fun: We leverage the power of JavaScript's first class functions to create a well-known programming construct - the y-Combinator.

The following exercise is meant to demonstrate to power of functions and how well JavaScript supports the functional programming paradigm. The practical use of the y-Combinator in JavaScript is questionable, so if you are in a hurry, just skip over this sub-chapter.

In strictly functional programming languages there are no variables that you can use to temporarily save a value. Functions are selft-contained expressions that evaluate to a function value with can then be passed to another function or be returned by another function or be invoked. If you would want to write a self-recursive function with assigning it to a variable, you have a problem: You do not have any name that the function can use to call itself.

Just to be clear, what we are talking about, here is a conventional factorial function that is assigned to a value.
```javascript
var fact = function (n) { return n === 0 ? 1 : n * fact(n-1); };
```
We want to find a way to make a factorial function that does not know what its own name is. Therefore we will look at some fundamental ways in which functions can be manipulated in functional languages in general and also in JavaScript.

We could wrap the factorial function inside another function that takes the factorial definition as an argument so that it is bound to a local variable of that wrapper function.
```javascript
var makeFactorialFunction = function (fact) {
    return function (n) { return n === 0 ? 1 : n * fact(n-1); };
};
```
But we would then have to call `makeFactorialFunction` with another factorial function as an argument. May we should think about what the `makeFactorialFunction` does or can do. Because it builds on a function that we pass it, it is actually a extension to the factorial.
```javascript
var factExtend = function (partial) {
    return function (n) { return n === 0 ? 1 : n * partial(n-1); };
};
```
Okay, just renaming here, but the point is, that we can use a simple function that calculates the factorial for `0`.
```javascript
var fact0 = factExtend();
fact0(0); // 1
fact0(1); // TypeError: partial is not a function
```
`fact0` worked for the input `0`, but not for `1`. The error message, saying that `partial`, is actually not surprising because we created `fact0` by calling `factExtend` without any arguments. Let's use a more helpful error function to create `fact0`.
```javascript
var error = function () { throw "You've gone too far!"; };
var fact0 = factExtend(error);
```
But let's move on by create functions that are capable of calculating the factorial of `1` and `2`.
```javascript
var fact1 = factExtend(fact0);
fact1(0); // 1
fact1(1); // 1
fact1(2); // "You've gone too far!"

var fact2 = factExtend(fact1);
fact2(1); // 1
fact2(2); // 2
fact3(2); // "You've gone too far!"
```
You could push that further and chain as many calls to `factExtend` together as you wish in order to create a function that can calculate a higher factorial.
```javascript
var factX = factExtend(factExtend(factExtend(factExtend(factExtend(factExtend(factExtend(factExtend(factExtend(factExtend(factExtend(error)))))))))));
factX(10); // 3628800
factX(11); // "You've gone too far!"
```
But that is silly! In order to get closer to our goal of a way to create a self-recursive factorial function that does not know its own name, we have to rearrange the `factExtend` function a bit.
```javascript
var factX = (function (extender) {
    return extender(extender(error));
}(
    function (partial) {
        return function (n) { return n === 0 ? 1 : n * partial(n-1); };
    }
));
factX(1); // 1
factX(2); // "You've gone too far!"
```
What happened? What was the `factExtend` function is now the argument being passed to another function. This other function calls its argument with itself and with the error function; it finally returns the result of calling the parameter with itself multiple times. The return value of this function is then assigned to `factX` which now is a function, capable of calculating the factorial of `0` and `1`.

What happens, if we get rid of the `error` function?
```javascript
var factX = (function (extender) {
    return extender(extender());
}(
    function (partial) {
        return function (n) { return n === 0 ? 1 : n * partial(n-1); };
    }
));
factX(0); // 1
factX(1); // 1
factX(2); // TypeError: partial is not a function
```
We can still calculate the factorial of `0`, but `1` gives us `NaN`. Why is that? We did not provide any arguments to the inner most `extender` so this one represents the function with the factorial definition that has not been passed its `partial` argument. Since this function calls `partial` for recursion, it fails when there is no `partial`. 





```javascript
var factorial = function (f) {
    return function (n) {
        return n === 0 ? 1 : n * f(n-1);
    };
};

var fibonacci = function (f) {
    return function (n) {
        return n <= 1 ? 1 : f(n-1) + f(n-2);
    };
};

var Y = function (f) {
    return function (x) {
        return x(x);
    }(function (p) {
        return (f((
            function (v) { 
                return p(p)(v); 
            })
        ));
    });
};

var Ynot = function (f) {
    return function (x) {
        return f(
            function (v) {
                return x(x)(v);
            }
        );
    }(function (x) {
        return f(
            function (v) { 
                return x(x)(v); 
            }
        );
    });
};
```