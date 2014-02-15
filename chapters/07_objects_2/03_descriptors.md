## Property Descriptors

Before we look at all of the methods that are available for manipulating objects we have to introduce the concept of property descriptors, accessor properties and flags.

These features are all new to the language as of ECMAScript Edition 5. They provide a way to control the access to an object's properties.

The first idea is, that properties are now being distinguished into "data properties" and "accessor properties". Data properties are just regular values attached to an object, but accessor properties have getter and setter functions in order to control the access to that property.

### Accessor properties
In a lot of cases you would want to have a property that is not to manipulated or retrieved directly but by getter and setter methods that perform things like input or type validation or access privilege checks. To define a accessor property you just need to define `get` and `set` methods for a property.
```javascript
var msg = 'Hello my friend'
var shouter = {
    get greeting () { return msg.toUpperCase(); },
    set greeting (v) { msg = v; }
};
```
Using an external variable to store the actual data is weird because it is not part of the object. But you can also use accessors with object properties.
```javascript
var person = {
    name : 'bob',
    get bigname () {
        return this.name.toUpperCase();
    },
    set bigname (v) { 
        return this.name = v.toLowerCase();
    }
};
```
Above is an object with a `name` property that has accessors called `bigname`. These retrieve the name in all caps and set it in all lower case. But using accessors like this does not provide for privacy and the original value can be tampered with by other code. A better solution would be to enclose the whole object in a function (why that is beneficial, you will find out in [chapter 04.05](#04.05.00))
```javascript
var gizmo = (function () {
    var foo;
    return {
        get foo () { return foo; },
        set foo (v) { foo = v; }
    };
}());
gizmo.foo; // undefined
gizmo.foo = 'bar';
gizmo.foo; // 'bar'
```
If you do not do anything inside these functions other than returning and setting the value, you should not use accessors, since they are a [lot slower](http://jsperf.com/data-vs-accessor-properties) than direct data property access.

### Property descriptors
In order to explain what object descriptors are, we will look at the function `Object.defineProperty`. It takes three parameters: An object to manipulate, a property name and an property descriptor. A property descriptor, well, describes a property. To be more specific, it contains flags and optionally accessor methods. The two flags, applying to both data and accessor properties are `enumerable` and `configurable`. The first one determines, whether the property will show up in `for ... in` loops and in the result of calling `Object.keys`. The `configurable` flag determines, whether the property descriptor can be changed after the fact. The other parts of the property descriptor are depending on whether you want to define a data or accessor property and are mutually exclusive. Accessor properties can be defined with the keys `get` and `set` as shown above. Data properties can be configured with a `value` key setting the value for that data property and a `writeable` flag stating whether the value can be changed or is readonly. Unfortunately property descriptors are syntactically identical to objects.
```javascript
var gizmo = {};
Object.defineProperty(gizmo, 'id', {
    value : 1337,
    writeable: false,
    enumerable : false,
    configurable : false
});
Object.defineProperty(gizmo, 'data', {
    value : 'Lorem ipsum',
    enumerable : true
});
Object.defineProperty(gizmo, 'access', {
    get : function () { return}
})

gizmo.id; // 1337
gizmo.id = 42; // 42 (No error whatsoever)
gizmo.id; // 1337

Object.defineProperty(gizmo, 'id', { configurable : true }); // TypeError: can't redefine non-configurable property 'id'

gizmo.propertyIsEnumerable('id'); // false
gizmo.propertyIsEnumerable('data'); // true

Object.keys(gizmo); // ['data']
```
You probably won't be needing property descriptors a lot, but from time to time it may be useful to exclude properties from enumeration or to employ things like validation.