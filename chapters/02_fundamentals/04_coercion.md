## Coercion
In some situations the JavaScript interpreter will expect values of specific types e.g. operators tend to work only on certain types or `if` statements expect their condition to be a boolean value. When a value of the wrong type is given to an operator or a statement, the interpreter tries to convert the value to the expected type. Because of the brutality with which the conversion is enforced in order to avoid throwing, this process is called "coercion". Especially for the `+` and `==` operator there is some tricky behavior in how that conversion is done. 

### Truthiness and Falsiness
Here I want to talk about the conversion to boolean values as present in `if`, `while` and `for` statements, the ternary operator and logical operators.

Some values are automatically converted to `false`. We call those "falsy values". Falsy values are the following:
```javascript
false
0
NaN
''
undefined
null
```
All other values are considered "truthy" meaning they evaluate to `true` when converted to a boolean. It is actually easy to understand, why the above values become `false` when converted to a boolean value. The concept of truthiness/falsiness is not too complex as long as you remember that it is about coercing a value to the boolean type.

You can btw. easily write a function to test for truthiness.
```javascript
var isTruthy = function (val) {
    if (val) {
        return true;
    } else {
        return false;
    }
};
var isFalsy = function (val) { return !isTruthy(val); };
```
There is another (shorter) way to convert a value to the boolean type: By prefixing it with two negation `!` operators.
```javascript
!!0 // false
!!1 // true
!!NaN // false
!!'' // false
!!'0' // true
!!'undefined' // false
!!'null' // false
```
The negation operator converts its operand to a boolean value and then negates it; by doing that twice we get the correct result which complies with the language's understanding of falsiness.

### Abstract comparison operator
Sadly, the comparison operator in JavaScript is not compatible with the falsiness and truthiness of values.
```javascript
isTruthy('0') // true
true == '0' // false

isFalsy(undefined) // true
false == undefined // false

isTruthy([]) // true
false == [] // true
```
Consider this operator trying to do a conversion to the number type. Let us examine the examples closer. `'0'` is a string that is not empty and is thus considered truthy (the empty string is the only string considered falsy). When using the abstract comparison operator true is converted to a number, resulting in the number `1`. Then `'0'` is converted to a number, which rationally makes the number `0`. 

`undefined` is one of the falsy values, but while `false` is coerced to the number `0`, `undefined` is always `NaN` in a numeric context and so it does make sense that `false == undefined` is `false`. To be honest with you: The internal logic works slightly differently, but it's best if you think of it this way. Otherwise, feel free to consult the Abstract Equality Comparison Algorithm in ECMA262-5.1 11.9.3.

An empty array is an object (just as any other array) and objects are always truthy. But when coerced to a number, an empty array becomes `0` just like `false` becomes `0`, which is why both are considered equal by the abstract comparison operator.

Sadly, the specification does not enforce the to-number coercion for every combination of operands. The only example I could come up with, that contradicts the simplified understanding of the abstract equality comparison is the value `null`:
```javascript
false == null // false
+false == +null // true

undefined == null // true
+undefined == +null // false

0 == null // false
+0 == +null // true

'0' == null // false
+'0' == +null // true

'' == null // false
+'' == +null // true

[] == null // false
+[] == +null // true

// but

null == {} // false
+null == +{} // false
```
Summing up: The abstract equality operator behaves just like the strict one when both operands are of the same type. Otherwise he coerces them to numbers and performs a strict comparison. Strict comparisons are intuitive. Actually you should never use the abstract equality operator. (The same goes for the abstract inequality operator of course.)

### Number coercion
Now we already had values implicitly coerced to the number type, but what is the best way to do it explicitly? There are several options that shall not be discussed to detailed.
```
new Number('42').valueOf() // 42
'42' / 1 // 42
'42' - 0 // 42
'42' * 1 // 42
+'42' // 42
parseFloat('42') // 42
parseInt('42') // 42
'42'|0 // 42
'42'^0 // 42
~~'42' // 42
```
These are all the techniques to convert a string value to a number roughly sorted by performance from slow (top) to fast (bottom) (based on these [these](http://jsperf.com/string-to-number-conversion-perf) [three](http://jsperf.com/best-of-string-to-number-conversion/4) [jsperf](http://jsperf.com/string-to-number-conversion-test) benchmarks and some more). The above methods are interchangeable for strings containing integers. If the string contains decimal numbers, `parseInt` and the bitwise operators will cut of the fractional part and return just the integer part of the number while the arithmetic operators and `parseFloat` return the correct decimal number. `null` is converted to `0` by all of the above except for `parseFloat` and `parseInt` which produce `NaN`. `undefined` is converted to `NaN` by all of them except for the bitwise operators which produce `0`. The same goes for the empty array. An array with one numeric value is converted to that numeric value by all of the above. Arrays with multiple numeric values are converted to `0` by the bitwise operators, to the first number in the array by `parseInt` and `parseFloat` and to `NaN` by the arithmethic operators. I will not talk about objects or arrays with non-numeric values or whatsoever but probably you got the point, being that you should be careful with numeric conversions. They never throw an error. Avoid converting anything else but strings that contain numbers. If the string contains only non-numeric characters, it gets converted to `NaN` except for the bitwise operators that will create `0`. If the string contains digits and other characters, the arithmetic operators return `NaN`, the bitwise operators return `0` and `parseFloat` and `parseInt` try to parse everything before the first non-numeric character and ignore the rest (again: without an error or anything).