## Operators

Operators are special keywords or symbols that execute operations on one or more operands. Because some of the operators in JavaScript show weird behavior in some cases, we will cover some of those here although you may not encounter all of the edge cases when writing your first programs. You should be aware of the caveats with some of the following operators!

### Arithmetic operators

#### `+`
The Plus operator behaves differently based on what types its operands are.

If both operands are of type `Number`, `+` will create a new number value, which will be equal to the sum of the operands. If one or both of the operands are boolean values, `true` gets converted to `1`, `false` gets converted to `0` and a new number value is created, equaling the sum of the operands.

NOTICE: Unfortunately the IEEE Standard, used for JavaScript's Number type, has difficulties with some operations on decimal digits. That leads to unreliable behavior like `0.1 + 0.2` being equal to `0.30000000000000004`. You should take special care, when doing sensitive calculations with non-integer numbers.

If one or both of the operands are of type String or Object, `+` will treat both as strings and concatenate them to a new one. If both operands are strings, a new string is created, that is the concatenation of the operands.
```
'4' + '2' + 2 // '422'
4 + 2 + '2' // '62'
```

`null` and `undefined` each are converted to a string, when the other operand is a string or an object, and are converted to a number, in every other case.

The `+` operator can also be used as a unary operator with one string operand, which it will convert to a number.
```
+'42' // 42
```

#### `-`
The Minus operator always treats its operands as numbers and produces a new value that is the difference of the operands.

The minus symbol `-` can also be used as a unary negation operator with numbers. It creates a new value that has the same absolute value as the operand but the opposite sign.
```javascript
var a = 4;
-a; // -4
```

#### `*`
The Multiplication operator takes two arguments and, if both of them are numbers, creates a value that is the product of the operand numbers.

#### `/`
The Division operator takes two arguments and, if both of them are numbers, creates a value that is the result of dividing the left hand operand by the right hand operand.

#### `%`
The Remainder operator takes two arguments and, if both of them are numbers, creates a value that is the integer remainder of dividing the left hand operand by the right hand operand, where the result's sign is the one of the left hand operand.

#### `++` / `--`
The increment and decrement operators each take one argument. They can be written before or after a qualified or unqualified variable name and have the effect of incrementing or decrementing the variable's value respectively. If the operator precedes the operand, the new value is also returned by the expression, otherwise, the old value is returned.
```javascript
var a = 0;
a++; // 0
a; // 1
++a; // 2
--a; // 1
```

### Assignment operators

#### `=`
The Assignment operator is a very basic and very important one. It is used with two operands like so `op0 = op1` and what it does is, it assigns a variable, specified by the left hand operand, a value, specified by the right hand operator.

There are special assignment operators for all arithmetic and bitwise operations. These assignment operators use the value of the left hand operand for the left hand operand of their arithmetic/bitwise operation and then assign their left hand operator the result of the calculation the have performed.

That means that the following two assignments are completely identical:
```javascript
a += b;
a = a + b;
```

The combined assignment operators are:

- `+=`
- `-=`
- `*=`
- `/=`
- `%=`
- `&=`
- `|=`
- `<<=`
- `>>=`
- `>>>=`

The operations performed, are explained in the following paragraphs.

### Bitwise Operators

#### `&`
The bitwise AND operator treats his operands as 32bit values and performs a bitwise and-operatoration.
```javascript
7 & 5 // 5
6 & 1 // 0
3 & 6 // 2
```

#### `|`
The bitwise OR operator treats his operands as 32bit values and performs a bitwise or-operation.
```javascript
7 | 5 // 7
4 | 1 // 5
1 | 2 // 3
```

#### `^`
The bitwise XOR operator treats his operands as 32bit values and performs a bitwise xor-operation.
```javascript
7 ^ 5 // 2
6 ^ 1 // 7
4 ^ 1 // 5
```

#### `~`
The bitwise NOT operator treats his operand as a 32bit value and inverts every of the operands bits. Since the values are encoded as One's Complement, `~a` will result in `-(a+1)`.
```javascript
~5 // -6
~234324 // -234324
~(-1001) // 1000
```

#### `<<` / `>>` / `>>>`
The shift operators in JavaScript are the left shift `<<`, the sign-propagating right shift `>>` and the zero-fill right shift `>>>`. They convert their first operand to a 32bit value, shift it the amount specified by the second operand and convert it back. Because of the conversion (values in JavaScript are internally not represented as 32bit values), shifting in JavaScript has none of the performance benefits it has in other languages, which is why you won't be needing these a lot.
```javascript
7 << 5 // 224
-6 >> 1 // -3
-6 >>> 1 // 2147483645
```

### Comparison operators

#### `===` / `!==`
These equality and inequality operators compare the operands with which they are used. If the right hand side and left hand side operands are of the same type and have the same value, the equality operator produces the value `true` and the inequality operator produces the value `false`. If the compared operands have either different types or contain different values, the equality operator produces `false` and the inequality operator produces `true`.
```
'a' === 'a' // true
2 !== 2 // false
'e' !== 'a' // true
{ } === { } // false
```
When used with two objects that are not references to the same object, the equality operator always produces false.

NOTICE: It appears, that the `NaN` value is not equal to itself:
```
NaN === NaN // false
NaN == NaN // false
```
That is not only unintuitive, it is simply wrong. And it can easily lead to bugs. If you want to check, whether a value is NaN try this:
```javascript
Number.isNaN = function (n) {
    return (''+n) === 'NaN';
};
// or
Number.isNaN = function (n) {
    return n !== n;
};
```
There will be a `Number.isNaN` function available by default in ECMAScript 6 and is already widely supported.

#### `==` / `!=`
These are also equality and inequality operators, but behave a bit differently. If the types of the compared operands do not match, these abstract comparison operators `==` and `!=` try to convert them into values of the same type and then compare their values. This process of type coercion has a lot of implementation faults (which are both sad and funny):
```javascript
'' == 0 // true
0 == '0' // true
'' == '0' // false

false == '' // true
false == '0' // true
false == 'false' // false

undefined == null // true
false == [] // true
false == {} // false

' \t \n  '  == 0 // true
```
Because of these, you should never use this kind of equality operator and always use the working one `===`/`!==`. Not only do `==`/`!=` not work reliably, but when reading someone's code, it is not clear, whether the programmer was aware of their hazards or unintentionally used the fuzzy version of equality checks. When code hides the programmer's real intention, it is bad code. You should write good code, so avoid `==` and `!=`.

#### `<`, `<=`, `>`, `>=`
The less than, less than or equal, greater than and greater than or equal operators behave similarly in that they compare the value of two operands.

Less than `<` returns true, if the left operand's value is less than the second operand's value.

Less than or equal `<=` returns true, if the left operand's value is less than or equal to the second operand's value.

Greater than `>` returns true, if the left operand's value is greater than the second operand's value.

Greater than or equal `>=` returns true, if the left operand's value is greater than or equal to the second operand's value.

Both operands are converted to number by the above operators. The usual rules apply like `null`, `[]` and `false` act as `0`, `true` acts as `1` and objects and `undefined` act as `NaN` rendering every comparison `false`.

### Logical Operators

#### `&&`
The logical AND operator returns the value of the first operand, if its value is falsy (meaning that it evaluates to `false`, when being converted to a boolean), and the value of its second operand otherwise.
```javascript
true && '34' // '34'
0 && true // 0
```
Because the AND operator returns the second operand, you can use it to safely call functions on object of which you are not sure, they exist.
```javascript
myObj && myObj.callMethod();
```
Because of the lazy validation, the function invocation expression is not evaluated if the first operand of the AND operator already evaluated to `false`.

#### `||`
The logical OR operator returns the value of the first operand, if its value is truthy (meaning that it evaluates to `true`, when being converted to a boolean), and the value of its second operand otherwise.
```javascript
undefined || { } // { }
false || true // true
3 || 4 // 3
```
Because the OR operator returns the first operand, you can use it as a short notation for default parameters (which will be natively available in ES6).
```javascript
var f = function (obj0) {
    var o = obj0 || {};
};
```

#### `!`
The logical NOT operator takes one operand and if its value is truthy, `false` is returned, and `true` otherwise.
```javascript
!0 // true
!{} // false
```

### Object-related operators

#### `delete`
The `delete` operator takes one argument that is expected to be a qualified variable name. The specified variable is removed from the object whose property it is.
```javascript
var obj = { foo : 'bar' };
console.log(obj.foo); // 'bar'
delete obj.foo; // true
console.lo(obj.foo); // undefined
```
Using `delete` is preferred to setting an object's value to `undefined`.

#### `in`
The `in` operator returns a boolean value stating whether an object has a property with a given name (specified by a string).
```javascript
var obj = { foo : 'bar' };
console.log('foo' in obj); // true
console.log('key' in obj); // false
```
The `in` operator will return `true`, if a value has been set to `undefined`, but `false`, if it has been deleted with the `delete` operator.

#### `instanceof`
The `instanceof` operator returns a boolean value stating whether an object was created by a given constructor or a constructor inheriting from it. (This will make more sense, when we talk about inheritance in [XX.XX](#XX.XX));
```javascript
var Constr0 = function () { };
var Constr1 = function () { };

var insta0 = new Constr0();
insta0 instanceof Constr0; // true
insta0 instanceof Constr1; // false

Constr1.prototype = new Constr0();
var insta1 = new Constr1();
insta1 instanceof Constr1; // true
insta1 instanceof Constr0; // true
```

#### `new`
The `new` operator takes one operand that is a function value. It creates a new object, that inherits from the function's prototype, invokes that function (optionally specifying parameter values) with `this` bound to the new object and returns the new object (if the function does not specify any other return value) as the value of the whole `new` expression.

If that sounds a bit cryptic, read [XX.XX](#XX.XX) and [XX.XX](#XX.XX) where objects and functions are covered respectively. Especially, `new` is discussed again in [XX.XX](#XX.XX).

### Other operators

#### Conditional
The conditional operator is the only operator in JavaScript taking three operands. It evaluates the first operand, if the result of that evaluation is true, the second one will be evaluated, if not, the third one will be. You can think of the conditional operator as a short way of writing an if-else statement (but with mandatory else).
```javascript
var status = isReady() ? 'I am ready!' : 'Wait a sec!';
```

#### `typeof`
JavaScript has a `typeof` operator that takes one operand and creates a new value that is a string describing the operand's type.
```javascript
typeof 'foo' // 'string'
typeof 42 // 'number'
typeof { } // 'object'
typeof false // 'boolean'
typeof undefined // 'undefined'
```

Although there is no `function` type in JavaScript, functions are recognized as such by `typeof`.
```javascript
typeof function () { }; // 'function'
```

While that is all very well, consider the following:
```javascript
typeof [ ] // 'object'
```

Sadly, the `typeof` operator recognizes arrays as being objects, which is not totally wrong but at least not useful. Since ECMAScript 5.1 there is an `Array.isArray` method to reliably check for an array. For legacy environments, you could write your own polyfill:
```javascript
if (!Array.isArray) {
    Array.isArray = function (a) {
        return Object.prototype.toString.call(a) === '[object Array]';
    };
}
```

But there is more:
```javascript
typeof null // 'object'
```
This is a mistake that might get fixed in some future version of JavaScript, but until then, you have to keep this flaw in mind.

What is maybe even more troublesome, is that:
```javascript
typeof NaN // 'number'
```
While you would expect "Not a Number" not to be a number, technically it is. There is a global `isNaN` function, but you should not be using it, since it is broken. (It tries to convert non-numeric arguments to the Number type and then tries to determine, whether that number is`NaN`, which gives false negatives in those cases.) In ECMAScript 6 there will be a `Number.isNaN` function and it is already supported in Firefox 15+ and Chrome 25+ (thus V8 thus nodeJS)

For a more robust check for a value being a number or not, you should use something like this:
```javascript
Number.isNumber = function (n) {
    return typeof n === 'number' && ('' + n) !== 'NaN' && n !== Infinity && n !== -Infinity;
};
```
Implmentations differ in the way, their `typeof` operator labels regular expressions. They are most of the time recognized as `object` and sometimes as `function`, but never `regex` or something like that.

#### `void`
The void operator evaluates the expression which is its only operand and ignoring the expressions value, creates a new value of `undefined`.

This may sound a bit silly and is indeed of limited use. But the `void` operator allows to insert expressions, that have side effects, into places, where a value of `undefined` is required for correct behavior - which may be an indicator that you have to rethink you code, instead of using void.

The most frequent use of `void` is in an HTML anchor tag:
```html
<a href="javascript:void(document.body.backgroundColor = 'red')">Click here</a>
```
The expression has the side effect of manipulating the attribute of a DOM element and would return `'red'` which is not desired to be inserted inside the anchor tag's `href` attribute.

#### `yield` (ES6)
[...]

### Operator Precedence
Operator precedence determines the order in which operations are evaluated. 
```javascript
5 * 3 + 4 = 19
5 + 3 * 4 = 17
```
In maths, multiplication has a higher precedence than addition. Similarly, in JavaScript the multiplication operator `*` has a higher precedence than the plus operator `+`; i.e. the multiplication operator binds values stronger.

You can force an evaluation order on a chained operation by using parentheses.
```javascript
5 * (3 + 4) = 17
```
If every operation would be enclosed in parentheses, operator precedence would be irrelevant and expressions would be evaluated from the inner most to the outer most pair of parentheses.

Along with the precedence hierarchy for different operators, associativity determines the precedence among equal operators. 

The following table shows operator's precedences and their associativity in JavaScript:

Precedence  | Operator                  | Operation                     | Associativity
------------|---------------------------|-------------------------------|------------
0           | `new`                     | constructor invocation        | right
1           | `()`                      | function invocation           | left
2           | `[]`/`.`                  | property access               | left
3           | `++`/`--`                 | increment/decrement           | none
4           | `!`                       | logical NOT                   | right
5           | `~`                       | bitwise NOT                   | right
6           | `+`                       | unary plus (type-conversion)  | right
7           | `-`                       | unary minus (negation)        | right
8           | `typeof`                  | typeof                        | right
9           | `void`                    | void                          | right
10          | `delete`                  | property removal              | right
11          | `*`                       | multiplication                | left
12          | `/`                       | division                      | left
13          | `%`                       | remainder                     | left
14          | `+`                       | addition                      | left
15          | `-`                       | subtraction                   | left
16          | `<<`/`>>`/`>>>`           | bitwise shift                 | left
17          | `<`/`<=`/`>`/`>=`         | comparison                    | left
18          | `in`                      | property membership check     | left
19          | `instanceof`              | instanceof                    | left
20          | `==`/`!=`/`===`/`!==`     | equality / inequality         | left
21          | `&`                       | bitwise AND                   | left
22          | `|`                       | bitwise OR                    | left
23          | `^`                       | bitwise XOR                   | left
24          | `&&`                      | logical AND                   | left
25          | `||`                      | logical OR                    | left
26          | `? :`                     | conditional                   | right
27          | `yield`                   | yield                         | right
28          | `=`/`+=`/`-=`/`*=`/`/=`...| assignment                    | right
29          | `,`                       | comma                         | left