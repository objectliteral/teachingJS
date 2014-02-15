## Properties and Methods
There are some properties that all objects inherit from the root object, `Object.prototype`, as well as some special functions, that are accessible on the `Object` constructor.

### Methods and properties on `Object`
Most of the methods, available on `Object` are new to the language specification as of ES5.1. They are generally supported in Chrome 5+, Firefox 4+ and IE 9+. TC39 adds those helper methods to `Object` rather than `Object.prototype` to prevent compatibility issues with code that does not anticipate altered prototypes.

#### `Object.create()`
This function creates an object with the prototype of that new object being the first function parameter and properties, specified by the second parameter. The latter one is not an object of itself but and object with property descriptors. More on descriptors in [03.04](#03.04.00).

For the inheritance aspect of `Object.create`, you can use the following polyfill:
```javascript
if (typeof Object.create !== 'function') {
    Object.create = function (o) {
        var F = function () { };
        F.prototype = o;
        return new F();
    };
}
```

#### `Object.defineProperty()`
This function allows you to add a property to an object or modify an existing one, with the possibility to set flags like `enumerable` and `writeable` (you learnt about these [above](#03.03)). The function takes three arguments: The object to be worked on, the property name and a property descriptor.

#### `Object.defineProperties()`
This is the same as `Object.defineProperties`, but it only takes two arguments: The object to manipulate and an object with property names and descriptors.

#### `Object.freeze()`
This function makes the object that is given to it as a parameter immutable meaning that none of its properties can be remove or changed and no properties can be added to it. `Object.freeze` is shallow, so objects that are properties a frozen object can still be mutated.

#### `Object.getOwnPropertyDescriptor()`
When given an object and a property name, this function returns a property descriptor object, if the given object has an own property with the given name.

#### `Object.getOwnPropertyNames()`
Given an object, this function returns an array with all properties, directly attached to that object. Here it does not matter, if a property's `enumerable` flag is set to true or false.

#### `Object.getPrototypeOf()`
This function returns an object's internal prototype.

#### `Object.is()` (Experimental)
This function checks to values for equality. It works similar to the strict equality operator `===` with the following exceptions:
```
+0 === -0 // true
NaN === NaN // false
Object.is(+0, -0) // false
Object.is(NaN, NaN) // true
```
This function is experimental and while is part of the proposal for ES6, it is only available in Firefox 22+ and Chrome 30+. A polyfill can be written like this:
```javascript
if (typeof Object.is !== 'function') {
    Object.is = function is (arg0, arg1) {
        if (arg0 !== arg0) {
            return arg1 !== arg1;
        } else if (arg0 === 0 && arg1 === 0) {
            return 1 / arg0 === 1 / arg1;
        } else {
            return arg0 === arg1;
        }
    };
}
```

#### `Object.isExtensible()`
This function returns a boolean value stating whether it is possible to add new properties to the given object or not. Object extension can be prohibited by using `Object.preventExtensions`, `Object.seal` and `Object.freeze`.

#### `Object.isFrozen()`
This function returns a boolean value stating whether it is possible to add properties to the given object and mutate its existing properties or not. Objects can be frozen with `Object.freeze`.

#### `Object.isSealed()`
This function returns a boolean value stating whether it is possible to add new properties to the given object and change the configuration of its existing properties or not. Objects can be sealed with `Object.seal`.

#### `Object.keys()`
Given an object, this function returns an array with all enumerable properties, directly attached to that object. The function differs from `Object.getOwnPropertyNames` in that it respects the `enumerable` flag and it differs from a `for ... in` loop in that it only returns an object's own properties and does not use the prototype chain. This feature can be emulated by a polyfill like this:
```javascript
if (typeof Object.keys !== 'function') {
    Object.keys = function (obj) {
        var i, r = [];
        if (typeof )
        for (i in obj) {
            if (Object.prototype.hasOwnProperty.call(o, i)) {
                r.push(i);
            }
        }
        return r;
    };
}
```

#### `Object.preventExtentions()`
This function prevents any properties being added to the given object. Properties can still be deleted and changed and additions to the object's prototype are still visible to the object.

#### `Object.prototype`

#### `Object.seal()`
This function prevents any properties being added to the given object and makes any existing properties non-configurable. Property values can still be changed.

#### `Object.setPrototypeOf()` (Broken)
Theoretically this function sets an object's internal prototype property. It is in the editing draft of ES6 but there is no implementation due to performance issues in all modern JavaScript engines.

### Methods and properties on `Object.prototype`
The following methods are properties of `Object.prototype` and thus accessible on any builtin or custom object.

#### `Object.prototype.constructor`
Every object has a pointer to the function that created the object. You can learn more about constructors in [04.07](#04.07.00) and [05.03](#05.03.00).

#### `Object.prototype.hasOwnProperty()`
This function returns a boolean value stating whether the object that it is called on has an own property with the given name. The difference between `hasOwnProperty` and the `in` operator is that the latter will consult the prototype chain and the first will not.

#### `Object.prototype.isPrototypeOf()`
This function returns a boolean value stating whether the object that the function is called on can be found in the prototype chain of the parameter object.

#### `Object.prototype.propertyIsEnumerable()`
This function returns a property's `enumerable` flag.

#### `Object.prototype.toLocaleString()`
This function is meant to be overridden to provide locale specific text representations of objects.

#### `Object.prototype.toString()`
This function returns a textual representation of the object on that it is called on and is implicitly executed when a type coercion is done, e.g. when using an object and another value with the `+` operator.

In most implementations the default return value of `toString` for any object is `[object Object]` which is not very helpful. We can override that function to return a string, containing all of the object's (own) properties. Because such a textual representation that directly mirrors an objects notation in JavaScript is called JSON, our function will be called `toJSON`.
```javascript
Object.prototype.toJSON = function () {
    var that = this;
    if (Array.isArray(this)) {
        var str = '[ ';
        this.forEach(function (val, index) {
            
            if (typeof val === 'object') {
                str = str + val.toJSON();
            } else if (typeof val === 'string') {
                str = str + '\"' + val + '\"';
            } else {
                str = str + val;
            }
            
            if (index !== that.length - 1) {
                str = str + ', ';
            }
            
        });
        str = str + ' ]';
    } else {
        var keys = Object.keys(this), str = '{ ';
        keys.forEach(function (key, index) {
            
            str = str + '\"' + key + '\"' + ': ';
            
            if (typeof that[key] === 'object') {
                str = str + that[key].toJSON();
            } else if (typeof that[key] === 'string') {
                str = str + '\"' + that[key] + '\"';
            } else {
                str = str + that[key];
            }
            
            if (index !== keys.length - 1) {
                str = str + ', ';
            }
            
        });
        str = str + ' }';
    }
    return str;
};
```

#### `Object.prototype.valueOf()`
This function tries to return a primitive value representing the object that the function is called on.