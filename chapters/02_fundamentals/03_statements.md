## Statements

Let us look at the building blocks of a JavaScript (or actually any) program: Statements. A JavaScript program consists of zero or more statements. A statement usually involves using a keyword and some special syntax.

This sub-chapter will introduce all the statements in JavaScript and explain them briefly. Some of them are more important than others, some are dangerous and some are weird. Some of them should not be used at all. Finally, there are some of them, which are being introduced to the language in its next version.

### Declarations

In most programming languages you assign values to names. These names are often variables that can contain different values over time. In JavaScript there is one important way to define such a variable (and another two ways that will become available in the future).

#### `var`
A `var` statement declares a variable and optionally assigns it a value. Variables are function scoped (more on that in 04.03).
```javascript
var x = 3;
console.log(x); // 3
x = 'a string value';
console.log(x); // 'a string value'
```

#### `const` (ES6)
A `const` statement declares a readonly variable and assigns it a value.
```javascript
const pi = 3.141592653589793;
console.log(pi); // 3.141592653589793
pi = 3;
console.log(pi); // 3.141592653589793
```
Constants are currently not part of the official JavaScript language specification, but they are very likely to be in the next version of the language and they are already supported in the most important environments. 

#### let (ES6)
Similar to `const` and `var`, `let` declares a variable with optional immediate assignment of a value. The difference being, that `let` is block scoped, while `var` is function scoped. More on scope in [04.03](#04.03.00).
```javascript
let answer = 42;
```
There are some special flavored syntaxes for `let` which have been discussed in subchapter [02.05]().

### Structuring statements

While it is possible to write code that consists of a linear series of statements that are executed one-by-one and in order, you usually want to structure your program and use conditional or repeated execution of certain parts. The following statements help you with that. These statements are mostly straightforward and behave just like you would expect them to do (which is kind of a rare thing in JavaScript).

#### block
Just pro forma: A Block is a list of zero or more statements, surrounded by curly braces. Statements inside a block are executed in order unless this execution order is altered by a statement.

Example:
```javascript
{
    var foo = 'bar';
    console.log('hi');
}
```
Some of the following definitions will mention a statement, that conditionally or repeatedly executes; it is always possible that this statement is a block including more statements.

#### if ... else
An `if` statement describes a condition that is an expression getting evaluated to either true or false. If it is `true` the statement following the condition is executed. If it is `false` an optional second statement is executed that is preceded by the `else` keyword. It is also possible to use `else if` to chain more alternative conditions together.
```javascript
if (condition0) {
    // do something
} else if (condition1) {
    // do something else
} else {
    // or at least do this
}
```

#### Loops

There are several ways to iterate over a statement and execute it repeatedly.

##### while
`while` executes a given statement as long as a condition evaluates to `true`. The condition is checked, each time before the statement is run, and as soon as it is `false`, the next statement after the `while`-block will be executed.
```javascript
while (i < n) {
    i += 1;
}
// now, i is equal to n
```

##### for
A for statement consists of a statement, preceded by a group of three expressions. The first of these expressions is evaluated, when the `for` statement is first encoutered, and is usually used for inizializing a counter variable. If the second expression evaluates to `true`, the statement is executed and the expression is checked again, until it finally evaluates to `false` and the next statement after the `for` statement is executed. The third expression is evaluated each time after the statement was executed and usually does something like incrementing the counter variable.
```javascript
for (var i = 0; i < n; i += 1) {
    console.log(i);
}
```
All the three expressions in the head of the loop are optional. If the middle one is missing, it is assumed to be always true (which is almost never what you want). The two semicolons are required, even if one of the expressions is left out. 

If you are used to writing `for` loops in other languages, you might write something like this:
```javascript
for (var i = 0; i < n1; i += 1) {
    for (var i = 0; i < n2; i += 1) {
        // do something
    }
}
```
This will not work like you would expect it to do. The two `i` variables are the same because in JavaScript variables are function scoped and not block scoped. We will cover scoping in a bit more detail in [chapter 04.05](#04.05.00). The above code would create and infinite loop if `n2` is greater than `n1`.

##### for ... in
A for ... in statement iterates over all enumerable properties of an object and consecutively assigns the current property name to a variable. After the `for` keyword there are parentheses enclosing a variable to that the property names will be assigned to, the `in` keyword and the object to iterator over, followed by a statement to be executed on each iteration.
```javascript
var person = { name : 'Bob', age : 30 };
for (var i in person) {
    console.log(i + ': ' + person[i]);
}
// 'name: Bob'
// 'age: 30'
```
First thing to mention is, that `for ... in` iterates over all enumerable properties of an object, including inherited ones. That is often not what you want, so you always use the `has.OwnProperty` method to filter out all of the inherited properties and only execute your code for the direct members of the object you iterate over:
```javascript
for (var i in obj) {
    if (obj.hasOwnProperty(i)) {
        // only run your code here
    }
}
```
Remember that the loop variable contains the property names and not the values. The code below will log `1`, `2` and `3`.
```javascript
for (var i in [ 9, 8, 7 ]) {
    console.log(i);
}
```
This is one reason, why using `for ... in` loops is not recommended for iterating over arrays. Another one is, that when using `for ... in`, the order, in which the properties are visited, is not guaranteed. When iterating over arrays you want to visit the array's elements in the correct order most of the time, so you should not use `for ... in` with arrays. Use a `for` loop with a numeric counter instead.

Warning: When altering the object that is being iterated over from inside the loop, you will experience inconsistent behavior. Do not alter any of the objects properties except the currently visited one!

##### for ... of (ES6)
The `for ... of` statement is similar the `for ... in` with the major differences being, that the loop variable is not assigned the property name of the currently visited property but its value, and that the iteration happens in the correct order for numeric indices.
But since this feature currently only exists in Firefox, you can not yet use it, although it might be part of the language some day.

#### function related statements

##### function
A function definition consists of the `function` keyword, a comma-seperated, parentheses-enclosed list of identifiers being function parameters and a block containing the function body with zero or more statements in it. Function definitions can be written as expressions or statements. A function statement declares a variable in the current scope and assigns it a newly created function object that has the specified parameter list and function body. More on function declaration in [04.01](#04.01.00).
```javascript
var add = function (x, y) {
    return x + y;
};
```

##### return
Every function returns a value, when its execution is terminated. To specify a return value or terminate a function early, you can use the return statement.
```javascript
var add = function (x, y) {
    return x + y;
};
```

Warning: There must not be a line break between the `return` keyword and the expression of the return value, because Automatic Semicolon Insertion will step in an the return value will be `undefined`;

### Less important or dangerous statements

#### Loops and loop related statements

##### label
A label can be used to name loops and blocks. These names are used by break, continue and switch statements, but have no other meaning. See [02.01.01](#02.01.01) and [02.01.02](#02.01.02) for examples.
Blocks can also have labels:
```javascript
test : {
    console.log('hi');
}
```

##### break
The `break` statement interrupts the execution of the current loop, switch statement or any labeled statement and resumes program execution at the next statement of the one that was terminated.
```javascript
loop0:
for (var i = 0; i < n; i += 1) {
    while (f(i)) {}
        if (i === f(n)) {
            break loop0;
        }
    }
    if (foo(n)) { break; }
}
```
Since breaking in loops makes the execution flow harder to understand, it is best practice, to avoid the `break` statement.

##### continue
A continue statement in a loop, terminates the execution of the current loop iteration and starts with the next iteration.
```javascript
for (var i = 0; i < n; i += 1) {
    if (f(i)) {
        continue;
    }
}
```
Continue statements can also include a label just like `break` statements.

##### do ... while
A do while statement specifies a statement, that is executed at least once and then as long as a given condition is fulfilled. The condition is an expression that is evaluated to one of the values `true` or `false`.
```javascript
do {
    console.log(i);
    i += 1;
} while (i < n);
```

##### for each ... in
If you ever see someone mention a `for each ... in` statement, just ignore him. This statement was meant to perform iteration over object properties, but it has been removed from the language and most implementations.

#### debugger
The `debugger` statement has no defined behavior but can be used by implementors to provide some kind of debugging means.

#### switch
Switch evaluates an expression and matches it against labels. To each label there is an associated statement and when the expression matches a label, the associated statement is executed. If no match is found, an optional `default` clause is executed. You can use `break` in a statement, to step out of the clause's execution and continue after the `switch` statement. After a labeled statement is executed, instead of the switch statement's execution being terminated, the following labeled statement inside the switch statement (if there is another labeled statement) is executed - this is called "cases falling through". You shoud absolutely prevent that from happening and so, while using `break` in clauses is syntactically optional, it is semantically mandatory.

```javascript
switch (name) {
    case 'Bob' :
        console.log('Good day, Sir!');
        break;
    case 'Alice' :
        console.log('Mylady!');
        break;
    default : console.log('Do I know you?');
}
```

Because of the questionable behavior of `switch`, it is best to avoid using it.

Note: The `switch` statement uses the [strict comparison operator](#XX.XX) internally.

#### throw
JavaScript has exceptions and `throw` is used to throw one. This will result in the immediate termination of the current execution context (function) giving control to the previous context until a `try ... catch` clause is found. Execution is then continued in the block following the `catch` statement and the value that was thrown is bound to the `catch` block's parameter. Any value can be thrown.
```javascript
throw "Houston, we got a problem.";
```

#### try ... catch
If you want to catch an exception, you have to wrap the statements that might throw it in a `try` block. Following has to be a `catch` or a `finally`. The `catch` clause is executed when an exception is thrown, the `finally` clause is always executed whether the try was successful or whether an exception was thrown.
```javascript
try {
    dangerousFunction();
} catch (errorvariable) {
    dealWithIt(errorvariable);
} finally {
    cleanUp();
}
```
While JavaScript generally uses function scope for its variables, the variable that gets caught by `catch` (`errorvariable` in the example above) is block scoped to the `catch` block.

#### with
`with` executes a statement in the scope of a given object. So any unqualified variable names inside the statement will be looked up in the object (following the prototype chain, more on that in [XX.XX](#XX.XX)).
```javascript
with (obj) {
    a = b;
}
```
This would be the same as:
```javascript
if (obj.a === undefined) {
    if (obj.b === undefined) {
        a = b;
    } else {
        a = obj.b;
    }
} else {
    if (obj.b === undefined) {
        obj.a = b;
    } else {
        obj.a = obj.b;
    }
}
```
This code is far too hard to understand and very hard to predict. For the sake of your code's clarity, do not use `with`.

`with` also comes with a performance penalty for all variables that are not properties of the object. That is because the interpreter will try to find them on the object and on every object, the first one inherits from. For high inheritance hierarchies that is a lot of lookups that will fail anyway.

#### yield (ES6)
[...]