## Types and Literals

Types are sets of rules that apply to programming constructs such as variables, expressions or return values. They can help prevent bugs because they enable a compiler to perform consistency checks. In languages like C and Java types restrict variables to only contain values of a certain type. While JavaScript as well has types, it is rather lax about it. For instance it does not make any restrictions to variables or function invocations which is why JavaScript is often mistakenly referred to as a type-agnostic language. It is not.

When types are not enforced on variables or function parameters, what reason is there to have types after all? Some operations only make sense when applied to operands of a certain type. For example it is obvious to see how to numbers can be added, but what should happen, when to objects are added? When you use a value of the wrong type with a JavaScript operator, the interpreter will automatically convert it to a type for that the operation is defined. JavaScript does a lot of work for you when it comes to types, so it is not surprising that it doesn't always get it right. Talking about types in JavaScript always means talking about the language's quirks.

Below is a brief introduction to the 6 types that are in the language. Throughout this whole chapter we will talk a lot about types in conjunction with operators and how types are converted to one another.

### Undefined
The type undefined has just one value, which is also called `undefined`. It is the default value of all variables that have been declared but have not (yet) been assigned a value. You can also use the `undefined` value by simply using it literally.
```javascript
var a;
console.log(a); // undefined
var b = 0;
b = undefined;
console.log(b); // undefined
```

### Null
Just like Undefined the type of Null only has one value: `null`. It can be used to indicate, that a variable is intentionally set to something that is not really anything. Also just like `undefined`, `null` can be used literally.
```javascript
var a = null;
console.log(a); // null
```

### Boolean
The type Boolean represents two values of Boolean logic: `true` and `false`. These values can be used literally.
```javascript
var right = true;
var wrong = false;
```

### String
A value of the String type is a sequence of zero or more Unicode characters. There is no character type in JavaScript, single characters are simply Strings with a length of 1.

In order to use string in your code, you can also rely on a literal. Conveniently the string literal is a pair of `"` double quotes or `'` single quotes. These two mean absolutely the same: They create a string value with the contents of the text, enclosed in the quotation marks.
```javascript
var hi = "Hello";
var earth = 'World';
console.log(hi + earth); // 'Hello World'
```
But how can you represent a string, containing a double or single quotation mark? This is done by using the escape character `\` (backslash). Some characters are treated differently, when inside a string and preceded with the escape character.

escape sequence     | description
--------------------|--------------------------------
`\"`                | double quote character (`"`)
`\'`                | single quote character (`'`)
`\n`                | line break
`\t`                | tab
`\r`                | carriage return
`\b`                | backspace
`\f`                | formfeed
`\v`                | vertical tab
`\\`                | backslash character (`\`)


### Number
In contrast to many other languages, JavaScript only has one type for numbers: Number. This type contains all 64bit values as specified in the IEEE 754 standard, which covers the same precision as "Double" values in other languages. One special value, defined by the IEEE specification is `NaN` which stands for "Not a Number" and is meant to be placed everywhere, where a sane computation would not have any result, like when the conversion of a value to a number fails, or where the result is not a real number, like when calculating the sqare root of -1. The result of a computation involving `NaN` is always `NaN`. Two additional special values for the Number type in JavaScript are `Infinity` and `-Infinity`, representing an over- or underflow of the set of numbers that is covered by 64bit values.

NOTICE: When dividing a number by zero, the result will be `Infinity` or `-Inifinity` based on the number's sign. `NaN` is the result of dividing zero by zero.

NOTICE: `undefined` behaves as `NaN` when used in computation (numeric context), `null` behaves as `0`.

NOTICE: The implementation of the IEEE standard has difficulties with operations on non-integer numbers. For example in JavaScript `0.1 + 0.2` is not `0.3` but `0.30000000000000004` (just as `0.9 - 0.6` is `0.30000000000000004` or `0.9 - 0.8` is equal to `0.09999999999999998`). When doing arithmetic operations in JavaScript you should always be aware of this problem!

### Object
All the types above are called primitive types. Every value in JavaScript, that is not of a primitive type, is an object. JavaScript objects are quite different from objects in other languages and because of their fundamental value for JavaScript there is a whole chapter on objects.

Objects are basically just key-value pairs. That's it. Keys have to be strings but the values of object properties can be any value like strings, objects or functions. The flexibility of objects makes them extremely powerful and allows you to use them for a variety of tasks.

For the code examples in this chapter, all you need to know is that you can access an object's properties by using qualified identifiers in dot-notation like so:
```javascript
myObject.myProperty;
```
Just like the primitive types, objects have a literal. You can define a single object using a pair of curly braces `{ }`, that can contain zero or more comma-seperated key-value pairs.
```javascript
var jedi = {
    'name' : 'Luke Skywalker',
    'yob' : -19,
    'homeplanet' : {
        'name' : 'Tatooine',
        'rotPeriod' : 23
    }
};
```
Above you can see an object that contains three properties of different types.

### Wrappers
There are so called wrapper objects for some of the primitive types. They provide methods for booleans, strings and numbers. Their primitive value can be requested by the `valueOf` method. The most useful set of methods is provided by the `String` wrapper.
```javascript
var b = new Boolean(true);
b.valueOf(); // true

var n = new Number(42);
n.toExponential(); // "4.2e+1"
```
You do not really need to create wrapper objects in order to access their methods. Wrapper methods can be used on any variable, containing a primitive value, or any expression, that evaluates to a primitive value. JavaScript will automatically create a wrapper object, invoke the method on it, return the method's return value and discard the object.
```javascript
"hello world".toUpperCase(); // "HELLO WORLD"
(1337).toExponential(); // 1.337e+3
```
The builtin methods will be discussed in [chapter 6](#06.00.00).

Generally, there is no need to use the wrapper functions. `Number` and `Boolean` do not provide useful methods and the methods of `String` can directly be used on string values, which will be temporarily converted to an object by the interpreter. There are also constructor functions for objects and arrays, but instead of writing `new Object()` or `new Array()` you should be using the literals `{}` and `[]` respectively. If you use a wrapper constructor without the `new` keyword, you will get a primitive value.

### Arrays
There is no array type in JavaScript. Arrays are special objects that have numeric indices, a magic `length` property and their own literal. You can create an array using a pair of square brackets `[ ]`, containing zero or more comma-seperated values.
```javascript
var planets = [ 'Dantooine', 'Alderaan', 'Coruscant' ];
```
Arrays will be discussed in more detail in [chapter 6](#06.01.00).

### RegExp
In JavaScript there are builtin regular expressions and they also have their own literal. You can create a regular expression object by simply enclosing a regex inside slashes `/`.
```javascript
var email = /[A-Za-z.-_]+@[A-Za-z0-9]{2,}\.[A-Za-z]{2,3}/
```
Regular Expressions will be discussed in more detail in [chapter 6](#06.00.00)