## BONUS: Automatic Semicolon Insert (ASI)
There are certain types of statesments in JavaScript that need be postfixed by a semicolon `;`. These statements are:

- `break` statement
- `continue` statement
- `do-while` statement
- empty statement
- expression statement
- `return` statement
- `throw` statement
- variable statement

You can and should always terminate these statements with a semicolon like the following examples demonstrate.
```javascript
// break statement
break;
break theLoop;

// continue statement
continue;
continue theOtherLoop;

// do-while statement
do {
    // something
} while ();

// empty statement
;

// expression statement
'express yourself!';
1 + 3 + 3 + 7;
invoke();

// return statement
return false;
return {
    type : 'object'
};

// throw statement
throw '404';

// variable statement
var a;
var b = 'or not 2b';
var ac = 'dc', d, e = 'z';
```
If you do not conclude these statements correctly, there is a convenience mechanism called "Automatic Semicolon Insertion" that will take care of your sloppy code and insert semicolons where needed. ASI follows three basic rules. A semicolon is only inserted after a source code token

1. when the token is one of the above mentioned,
2. when the next token is a new line character `\n`, a closing curly brace `}` or the end of the file,
3. when parsing the next token would result in an error.

According to the second rule, the following example would not invoke ASI:
```javascript
var a = 4 var b = 2;
```
The above is a syntax error, while the following would invoke ASI twice:
```javascript
var a = 4
var b = 2
```
Following the third rule, the following example would not invoke ASI:
```javascript
var a = b
(f(a));
```
Because the opening parenthesis can be a function invocation, the above is equivalent to:
```javascript
var a = b(f(a));
```
On the other hand, the following example invokes ASI because the two statements can not be combined into one.
```javascript
var a = b
f(a)
```
The problem with that is, that if you want to omit semicolons, you always have to consider whether the next line after a statement could be interpreted as a continuation of the above one.

There are four statements that always trigger ASI no matter what the beginning of the next line is. These statements are: `break`, `continue`, `return` and `throw`. When these keywords are followed by a newline character, a semicolon is inserted.
```javascript
var f = function () {
    return
        'foo';
};
// becomes
var f = function () {
    return;
    'foo';
};
```
The function above will always return `undefined` and everything that comes after the `return` statement is never executed. So always keep in mind to put the expression following a `break`, `continue`, `return` or `throw` key on the same line.

Another exception to the three rules above is, that ASI never intervenes inside the head of a `for` loop. A `for` statement requires to have two semicolons, seperating the initialization, condition and final expression and these semicolons will never be inserted automatically.
```javascript
for (var i = 0
    i < n
    i += 1) {
    // something
}
// SyntaxError: missing ; after for-loop initializer
```