## Creation

### Object literals

To create an object, the most convenient way is the object literal `{ }`. Curly braces not only describe blocks ([XX.XX](#XX.XX)) but also objects. Inside the curly braces, you can specify zero or more comma-seperated key-value-pairs. The key can be a string and if it is also a valid identifier, it can also be written without quotation marks while still being treated as a string. The value can be any expression, like a number or string literal, a function expression, a conditional expression or another object.
```javascript
var jedi = {
    name : 'Luke Skywalker',
    yearOfBirth : -19,
    'homeplanet' : {
        'name' : 'Tatooine',
        'rotPeriod' : 23
    },
    friends : [ 'Leia Organa', 'Han Solo', 'Chewbacca']
};
```
When the key is written as a string literal, it is allowed to be an arbitrary string, while it otherwise has to be a valid identifier.

### Constructor
You can also create a new object by using a constructor function. Constructor functions or constructors are functions that create and return a new object. We will deal a lot with constructors in chapter 5. There are builtin constructors in JavaScript to create new empty objects or any of the primitive values.
```javascript
var o0 = new Object();
var b0 = new Boolean("true");
```
Note that a constructor, just like any other function, can accept parameters.

An object, created by `new Object()` or an empty object literal `{}`, which are equivalent expressions, does not have any properties. Such an object is not very useful, but you can add properties to it.