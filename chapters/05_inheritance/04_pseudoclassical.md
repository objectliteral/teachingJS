## Pseudoclassical Inheritance

In [05.02](#05.02.00) we had objects, directly inheriting from other objects. But if we want to use constructors to build objects, we need a way of having a constructor's objects inherit from another constructor's objects, which resembles the way, in which classes extend other classes in languages like Java. But that means, that we are adding a layer of abstraction upon object creation, which results in patterns that do not fully comply with the concept of classes (extending classes). That is why this approach is called "Pseudoclassical".

This first pattern is found in almost every introduction to object oriented JavaScript programming and shall serve us as a basis for iterating over different ideas and assembling structures that differ in their implementation of inheritance and scope logic as well as in syntactic elegance.
```javascript
var Person = function (age) {
    this.age = age;
};
Person.prototype.greet = function () {
    return 'Hello!';
};

var Child = function (age) {
    this.age = age;
};
Child.prototype = Person.create();
Child.prototype.isChild = function () {
    return this.age < 10;
};
```
This is the way, that inheritance was meant to be done in JavaScript. You create a constructor, whose prototype property gets assigned an object that was created by another constructor. Now all objects, created by the `Child` constructor, inherit from `Child.prototype` which is an object, created by `Person`. You see how constructors are built around the fact that objects inherit from other objects.

Let's take a look at what happens when we created a `Child` object:
```javascript
var timmy = Child.create(5);
```
The `timmy` object has a hidden prototype property pointing to `Child.prototype`, that itself inherits from `Person.prototype`. The two objects `Child` and `Person` are not directly connected, but have `prototype` properties of the same lineage. Important to note is, that when using the `new` operator, `timmy.constructor` points to `Person`, which is wrong. The `create` method sets the `constructor` property correctly (in this case to `Child`).


### Sugar
We can make the pseudoclassical approach look a bit nicer, by defining some additional methods:
```javascript
Function.prototype.method = function method (name, fn) {
    this.prototype[name] = fn;
    return this;
};
Function.method('inherit', function inherit (Parent) {
    this.prototype = Parent.create();
    return this;
});
```
The `method` function adds a function with a specified name to the prototype of the object on that it is called on. `inherit` creates a new object from the parent constructor and sets it as a function's prototype. Both methods return the function that they were called on, so we can chain them together and rewrite the `Child` constructor like this:
```javascript
var Child = function Child (age) {
    this.age = age;
}
.inherit(Person)
.method('isChild', function () {
    return this.age < 10;
});
```
That does exactly the same, as the definition of `Child` above, but looks a bit more pleasant. Still, this is not a style of code that you want to be writing a lot and we have no possibility of letting our methods work with private instance variables.