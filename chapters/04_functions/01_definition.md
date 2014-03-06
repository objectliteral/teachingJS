## Definition

When a function definition is evaluated by the compiler, a new object is created, that inherits from `Function.prototype`. A function can be defined in three ways.

### Function Expression (function literal)

A function expression can be used anywhere where an expression is expected. It produces a new value representing the function and when you do not get hold of it, it is gone. The standard way to define a simple function is this:
```javascript
var f = function (param) {
    console.log(param);
};
```
It consists of 
1. the `function` keyword, 
2. zero or more parameters enclosed in parentheses,
3. zero or more statements enclosed in curly braces (the function body).
The fact that we assign the function value to a variable here is irrelevant.

Parameters are optional. They are local variables to the function body and are initialized with the values, passed as arguments when the function is invoked.

The function body can be empty. It can contain an arbitrary number of statements that will be executed in order unless the execution order is altered by loops, conditional statements or function invocations.

The return statement is optional. You can use the return statement to terminate the function's execution early and/or to specify a return value. A return value can be any expression. Any function without a return statement will return the `undefined` value (unless the function was invoked with the `new` prefix). NOTICE: If the `return` keyword and the expression you want to return are separated by one or more newline characters, the function will return the `undefined` value and the expression after the `return` will be ignored. (That is because of Automatic Semicolon Insertion on which you can read more about in XX.XX).

#### BONUS: Named Function Expression
Function expressions can optionally contain a name. The name is not visible outside of the function but inside of it and can be used by the function to call itself recursively. A function expression with a name is conveniently called a named function expression (NFE).
```javascript
var g1883r15h = function factorial (n) {
    return n < 2 ? 1 : factorial(n-1) * n;
};
```
Due to a bug in the ES3 spec that required implementations to create an object for the scope of NFEs, all properties of Object.prototype were visible inside the NFE's function body. That circumstance lead to weirdness like the following:
```javascript
var constructor = function () {
    return 42;
};
var other = function other () {
    return constructor();
};
other(); // {}
```
The call to `other` above would return an empty object in older browsers because the scope of `other` inherited all the properties from `Object.prototype`, one of them being `constructor`, a function that returns an empty object.

Also, Internet Explorer 8 and prior creates an additional local variable with the name in the function expression.
```javascript
var f = function g () { };
typeof g; // 'function'
f === g; // false
```
Even worse, it creates two distinct function objects (thus allocating twice as much memory).

In modern browsers, both of the above issues no longer exists and you can use NFEs to your liking.

### Function Constructor

Functions are objects and objects can be created by constructors. In JavaScript there is even a constructor for functions. You can use it to define new functions.

```javascript
    new Function('arg', 'console.log(arg)');
```

The `new` keyword is optional, but omitting it leads to easier confusing with this notation and an anonymous function expression. You can specify the parameters, that your new function expects, as individual strings or as an array of strings. The function body is also expected to be a string.

Functions defined by a function constructor do not inherit any scope other than the global scope. (More on scope in XX.XX)

A function constructor's function body string is parsed every time it is evaluated, which makes this approach slower than using function expressions or function declarations.

### Function Declaration (function statement)

A function declaration looks very similar to a function expression.
```javascript
function logger (val) {
    console.log(val);
}
```
The difference between this and a function expression is, that the `function` keyword is the first token in the declaration and that the `function` keyword is followed by a name (where the name has to comply with the identifier rules in JavaScript). *When the interpreter encouters a function declaration it creates a new local variable with the name of the function and assigns it a new function object*.

Some people use the term "function statement" when they mean "function declaration", but there is no such thing as a function statement.

Function declarations are hoisted to the top of the enclosing function by the interpreter with the consequence that you can use them before they are defined. (Which shows that function declarations are not statements, since these are always executed in order). Do not take advantage of this behavior, but rather put function declarations on top of the enclosing function for improved readability.
```javascript
console.log(theText); // 'You must use the force!'
function theText () { return 'You must use the force!'; }
```

Function declarations are not allowed inside of non-function blocks. Most implementations do allow them but behave inconsistently. Example:
```javascript
if (true) {
    console.log(test);
    function test () {

    }
}
```
will log `[Function: test]` in nodeJS but `"test" is not defined` in Firefox. (Firefox converts those occurrences of function declarations to function expressions, which means that `if (true) { function test () { } console.log(test); }` will output [object Function] as expected);

To be precise: According to the ECMAScript standard, `FunctionDeclaration` is a `SourceElement`, just like `Statement` is a `SourceElement`, but `FunctionDeclaration` is not a `Statement`. A `Block` can only contain `Statement` tokens, while `Program` and `FunctionBody` can contain `SourceElement` tokens include `FunctionDeclaration`.

Do not use function declarations inside of non-function blocks like `if` statements or loops or other non-function blocks!

### What to use?

The Function constructor approach may be the closest to JavaScript's internal workings, but it is rather unintuitive to write, has the worst performance and most of all: It does create scope. The function declaration has no real benefit and is actually a bit irritating because it is semantically different from a function expression without looking any different. Therefore, you should be only using function expressions. (They are also the fastest alternative according to this [jsperf test](http://jsperf.com/function-declaration-vs-function-expression2/4)).

### Examples

I want to illustrate the difference between the function expression and the function declaration with an example.
```javascript
function add (x, y) {
    return x+y;
}
```
This function declaration does basically the same like the following function expression:
```javascript
var add = function (x, y) {
    return x+y;
};
```
The function statement creates a local variable with its name and assigns it a function. The only difference is, that the function defined with a declaration can be used before its appearance in the source code.

The following will produce a `SyntaxError`:
```javascript
function (x, y) {
    return x+y;
}
```
because the interpreter assumes a function declaration, which has to have a name.

The following will not produce a `SyntaxError`, but if you try to access `add` afterwards, you will get a `ReferenceError`:
```javascript
(function add (x, y) {
    return x+y;
})
```
That is because the parentheses make the compiler believe that it is dealing with a function expression. And the name you give a function in a function expression is not automatically used as a variable name for the function.

### Immediately Invoked Function Expressions (IIFE)

On a side note, the following pattern should be mentioned:

```javascript
(function () {
    console.log('ready!');
    // ...or whatsoever
}());
```

This is called a immediately invoked function expression, but it is often referred as a self-invoking function or self-executing function, which is wrong. It is a function expression (indicated by the outer parentheses) directly followed by an empty pair of parentheses. When the interpreter evaluates the function expression he replaces it with a function value. That way it is syntactically legal to append the pair of parentheses to it, that are indicating to the interpreter to invoke the function. (More on function invocation in [the next subchapter](#04.02.00)).

It is recommended to use the outer parentheses even in places, where the function expression could not be confused with a function declaration, because they make for better readability. So instead of
```javascript
var res = function () { 
    console.log('ready!');
    // ...or whatsoever
}();
```
use
```javascript
var res = (function () {
    console.log('ready!');
    // ...or whatsoever
}());
```
While syntactically and semantically correct, omitting those parentheses easily leads to confusion about the intention of the code. The first one looks more like a function definition, while you quickly get used to recognizing the second as an IIFE.

(It does not matter, whether you put the closing parenthesis that matches the one in front of the `function` keyword before or after the invocation parentheses, but choose a style and stick with it.)