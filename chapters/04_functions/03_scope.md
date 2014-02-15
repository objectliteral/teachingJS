## Scope

The concept of scope describes the visibility of variables in a program. Whether a function can access a certain variable is a question of scope. Think of a scope as a container in which variables reside. The general rule is that variables cannot be accessed from outside this container but from everywhere inside. Scopes can be nested.

### Function scope
Many languages implement what is called block scope, where a new scope is induced by a block such as a class, a function or an if statement. In JavaScript there is function scope hence the only way to create a new scope is by defining a function. This is really simple: A variable that gets declared inside a function is visible inside of that function but not outside of it.
```javascript
var f = function () {
    var iam = 'batman';
    console.log(iam);
};
f(); // 'batman'
console.log(iam); // ReferenceError: iam is not defined
```
The function `f` has its own scope in which `iam` is declared. This variable is visible inside the `f` function but not on the outside. But what is the scope in which `f` is declared?

### Global scope
I already mentioned that scopes can be nested. There is one scope on top of the scope hierarchy and that is the global scope. I also already talked about the global object and basically there is not much of a difference. Any variable declaration that is not happening inside of a function adds a variable to the global scope as well as a property to the global object.
```javascript
var a = 'a';
b = 'b';
window.c = 'c';

console.log(window.a); // 'a'
console.log(window.b); // 'b'
console.log(c); // 'c'
```
Notice that `window` is the name of the global object in web browsers; in nodejs the global object can be referred to as `root` or `GLOBAL`. Cluttering the global scope is not recommended. Especially when your applications grow larger or your code runs alongside third party code, it is a serious issue that name collisions of variables can occur. There is no error when you accidentally write to a global variable so you have to be cautious all the time.


Like many other popular languages, JavaScript uses lexical scoping, meaning, that scope inheritance is statically defined. Everything inside a function that is nested inside of another function has access not only the scope of the inner one but also the one of the outer one. 

```javascript
var f0 = function () {
    var val0 = 1;
    var f1 = function () {
        console.log(val0); // 1
    };
};
```

Here, f1 has access to all variables, declared inside of f0. Notice that a function's scope contains *references* to and not the values of variables from its lexical environment.

When the inner of two nested functions declares a variable, that has the same name as one, defined in the outer function, the new value of that variable will be attached to the scope of the function that it was declared in. The consequence being, that everywhere inside the inner function, the variable will now have a different value. This is called shadowing.

```javascript
var f0 = function () {
    var val0 = 1;
    var f1 = function () {
        var val0 = 'Shadow';
        console.log(val0); // 'Shadow'
    };
    console.log(val0); // 1
};
```

A different approach to scoping would be dynamic scoping, where a function inherits the scope of the function that calls it. That makes for less maintainable code and we are lucky to have lexical scoping in JavaScript.

But function scope only applies to variables defined with a variable declaration, so let us revisit the ways to define a variable.

- Variable Declaration
    This is the most important one and it was already defined in [XX.XX](#XX.XX). As mentioned above, variables defined via variable declaration obey the rules of function scope.
    
- Variable Assignment
    Assigning a value to a variable that was not previously declared with `var`, results in the initialization of a new global variable with the given value. Global variables are visible in every scope.

- Variable Declaration with `let`
    Introduced in [XX.XX](#XX.XX), the `let` keyword works similar to `var` but creates a variable with block scope.

Since `let` is new in ES6, which is neither fully specified nor sufficiently implemented, using `let` is not safe yet.

The use of global variables is generally to be kept to a minimum. If you are writing web applications, your code will run in the same global scope as any libraries you include or any code that gets loaded on the same page. You should therefore try to use as few global variables (if any) as possible. You should strictly modularize your code.

### Modules

There is no built-in module functionality in JavaScript. But you can avoid scattering the global scope and protect your module's variables by enclosing a module within a immediately executed function (as introduced in [04.01.06](#04.01.06)):

```javascript
var myModule = (function () {
    return {
        f0 : function () { ... },
        f1 : ...
    };
}());
```

The module simply returns an object, containing all the properties and methods that you want to export. Any other code can then access them like this:

```javascript
myModule.f0();
```

It is even possible and generally recommended to wrap the whole program in such a function. If that gets loaded and executed in a web page context, variable scope guarantees, that there are no conflicts with any other code, running on the same page.

### Special variables
There are two variables, that are not affected by the rules of scope: `arguments` and `this`. These are initialized for every function each time it is called. More on `arguments` in [04.04.01](#04.04.01) and more on `this` in [04.02](#04.02.00). Sometimes, you have nested functions where you want an inner function to have access to the object, pointed to by the `this` of the outer function. Since the inner function always gets its own `this`, you have to declare a new variable for that object. This variable is conventionally called `that`.

```javascript
var f0 = function () {
    var that = this;
    var helper = function () {
        var a = that.getA();
    };
};
```