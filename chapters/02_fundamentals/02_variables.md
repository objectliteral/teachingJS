## Variables

### Identifiers
Variable names have to comply to simple naming restrictions. The name of a variable (or constant) is called an identifier. Identifiers may only be composed of letters, digits, the dollar sign character `$` and the underscore character `_`. Identifiers must not start with a digit.

An identifier must not be one of the following reserved words:
- `break`
- `case`
- `catch`
- `class`
- `const`
- `continue`
- `debugger`
- `default`
- `delete`
- `do`
- `else`
- `enum`
- `export`
- `extends`
- `false`
- `finally`
- `for`
- `function`
- `if`
- `implements`
- `import`
- `instanceof`
- `interface`
- `let`
- `new`
- `package`
- `private`
- `protected`
- `public`
- `return`
- `static`
- `switch`
- `super`
- `this`
- `throw`
- `true`
- `try`
- `typeof`
- `var`
- `void`
- `while`
- `with`
- `yield`

### Variable Declaration
A variable declaration consists of the `var` keyword, followed by a space, followed by an identifier. The declaration can be immediately followed by an assignment to the new variable, in which case the identifier is followed by the assignment operator `=` and an expression. Declaring and instantly assigning a value is called "variable definition". Multiple declarations and and definitions can be chained together by using the comma operator `,`. A declaration or definition or chain of comma separated declarations or definitions has to be followed by a semicolon. 
```javascript
var x = 3;
console.log(x); // 3
x = 'a string value';
console.log(x); // 'a string value'

var y = 'Why not?', z, answer = 42;
console.log(y); // 'Why not?'
console.log(z); // undefined
```
The `var` keyword creates a variable in the local scope of the function. Read more about scope in [04.03](#04.03.00)

### Hoisting
JavaScript uses a concept called "hoisting" that moves every variable declaration to the top of the function, while assignments of values stay where they are.
```javascript
var f = function (d, c) {
    c(d);
    var a = c;
};
// becomes:
var f = function (d, c) {
    var a;
    c(d);
    a = c;
};
```
The result of that is that you can use variables before they are defined in your code without getting any errors. But since only the declaration and not the definition is hoisted and declared variables are initialized with the `undefined` value, that may cause trouble.
```javascript
var f = function () {
    console.log(r2);
    var r2 = 'd2';
    console.log(r2);
    console.log(c3);
};
f();
// undefined
// 'd2'
// ReferenceError: c3 is not defined
```
The declaration of `r2` is hoisted to the top of the function and the variable is initialized with `undefined`. In contrast, accessing `c3` will result in an error, since `c3` was not declared at all.

### Variable Assignment
It is possible to assign a value to a variable that has not previously been declared. There is no error and chances are, the program will work fine. The problem is, that such an assignment creates an implicit declaration of a global variable. Since global variables are visible everywhere inside your program, the probability of a name collision has to be taken into account. It is best, to keep variables as private and local as possible and to always avoid globals. (Read more on scope in [04.03](#04.03.00)).

### Constant Declaration
Another way to create containers for values is by using constants. The `const` keyword behaves syntacially like the `var` keyword, but creates a variable, that can be assigned a value only once. After its initial definition, a constant is readonly. If you try to change a constant you do not get an error message, but the value of the constant will simply not change.
```javascript
const PI = 3.141592653589793;
console.log(PI); // 3.141592653589793
PI = 3;
console.log(PI); // 3.141592653589793
```
If you declare a constant without immediately assigning it a value, that creates a constant with the value of `undefined`, which can not be changed, so you practically have to assign a value right away. Notice that constant declarations are not hoisted!
```javascript
const NOVALUE;
NOVALUE = 'value';
console.log(NOVALUE); // undefined
```
It is syntactically not required that constant names are all caps, but convention is to only use all caps names for constants in order to provide a visual clue about the fact that the value cannot be changed.

Constants are currently not part of the official JavaScript language specification, but they are very likely to be in the next version of the language and they are already supported in the most important environments. Irritatingly, in ECMAScript 6 constants are block scoped, but are function scoped in current implementations.

### Declaration with `let` (ES6)
Similar to `const` and `var`, `let` declares a variable with optional immediate assignment of a value. The difference being, that `let` is block scoped, while `var` is function scoped. More on scope in [04.03](#04.03.00). `let` can be used in different flavors (syntaxes). The first one is called `let` definition and looks just like the `var` or `const` syntax.
```javascript
let answer = 42;
```
The second and third are similar. The `let` keyword is followed by a set of parentheses which contain one or more variable assignments. The third part of the construct is an expression (finishing up the `let` expression) or a statement (concluding the `let` statement).
```javascript
var name = 'Luke';
let (name = 'Anakin') console.log(name); // 'Anakin'
console.log(name); // 'Luke'
```
Since a block is a statement you can execute a piece of code with access to "private" variables.
```javascript
var getSecret;
let (
    secret = 723590
) {
    getSecret = function () {
        return secret;
    };
};
console.log(getSecret()); // 723590
console.log(secret); // ReferenceError: secret is not defined
```

### Call-by-value / Call-by-reference
The way in which variables are passed as function arguments is really simple: All primitive values are passed by value, all objects (including functions, arrays, regular expressions and all your custom objects) are passed by reference.