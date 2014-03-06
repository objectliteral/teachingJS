## Modification

### Property Access

There are two ways to access an object property: The dot notation and the subscript notation. The dot notation uses the the object value and the property's name, separated by a dot `.`. The subscript notation consists of an object value, followed by a pair of square brackets enclosing a string that has the value of the property's name.
```javascript
obj.prop;
obj['prop'];
```
The dot notation is easier to write, but since the subscript notation uses a string, you can place a variable, containing a string, inside the square brackets (which is a common pattern in loops for instance). Additionally, the subscript notation allows you to use property names that are not valid identifiers, which is not possible, using the dot notation. (More on identifiers in [XX.XX](#XX.XX)). Since the subscript notation involves runtime evaluation of the property name, some optimizations in JavaScript engines may not apply, which is why you should dot notation when you don't need to have a variable property name.

### Updating properties
You can set any object property to any value. You access it like described above and simply assign it a value. There are no restrictions on type.
```javascript
luke.yob = -19;
luke['trainers'] = [ 'Obi-Wan', 'Yoda' ];
```

### Deleting properties
JavaScript has a `delete` operator that deletes a given property from an object. This is the prefered way of deleting object properties as opposed to simply setting their value to `undefined`. If you do the latter, the object will still contain the property, just with the value of `undefined`, and it will show up in `for in` loops and in `Object.keys`

### Inheritance

There is a separate chapter on inheritance, but a certain effect of inheritance should be mentioned at this point. 

Objects in JavaScript can inherit properties from other objects. An object, that is inherited from, is called the prototype of the object, that inherits from it. If a property is accessed on an object does not have a property with the given key, the JavaScript interpreter will check the object's prototype, to see, if that has the requested property. If not, it will check its prototype and so on, until a special root object is reached. This root object is `Object.prototype` and inherits from nothing. You can read more on this prototype chain and how it is manipulated in chapter 5.

The prototype chain is not consulted when using the `delete` keyword or when the object has its own property with the given key.

A consequence of this prototype chain property lookup is, that you can append properties to Object.prototype that are then available on every object. This practice is called altering JavaScript's prototyps and is usually to be done with caution since it can result in problems with code that does not expect altered prototypes. That is mainly because of the `for ... in` loop iterating over all of an object's properties, including inherited once. You can circumvent this behavior in your own code using `hasOwnProperty` (as mentioned in [02.01.09](#02.01.09)), which is strongly advised. In situations where your code runs alongside code from other sources on which you have limited or even no influence, you have to take special care. Read [XX.XX](#XX.XX) for another technique to deal with this kind of problem.