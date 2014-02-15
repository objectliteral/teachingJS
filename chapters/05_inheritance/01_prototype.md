## Prototype

In JavaScript, every object has a hidden link that points to an object from which the first one inherits its properties. The object, that is pointed to by such a hidden property is called a prototype. The linkage of objects, each having a prototype, is called the prototype chain. This chain is not endless, because there is one object, that has no prototype and that inherits nothing. This object is `Object.prototype`.

In most implementations, you can access an object's prototype as the `__proto__` property. Since this is nonstandard behavior, you should never use this property.

To confuse you even more, in JavaScript, every function has a `prototype` property, whereas other objects don't; (remember that functions are objects and can have properties). This might sound weird, but it will hopefully make sense to you, after we learnt more about constructors in [05.03](#05.03.00).

When you try to access a property of an object, that does not have that property, the JavaScript interpreter will go through the prototype chain and search for the specified property. It will stop when it finds it, in which case the access was successful, or when Object.prototype is reached and that does not have the property either, in which case the `undefined` value is produced. That means, that you can access any property on any object without ever getting an error. Another consequence of the prototype chain lookup is that, when you access a property on an object, you can not be sure, whether the object itself contained the property as a member or if it was retrieved through the prototype. In most of the cases, that is not a problem, but if you want to check, you can use the `hasOwnProperty` method, that every object inherits.
```javascript
var person = { name : 'Bob' };

person.name; // 'Bob'
person.toString; // [object Function]

person.hasOwnProperty('name'); // true
person.hasOwnProperty('toString'); // false
```