## Object literals

The first object creation pattern, that we are going to look at, is very simple but has a lot of practical use.

We can simply define a useful object with the object literal notation:
```javascript
var movie = {
    title : 'Pulp Fiction',
    director : 'Quentin Tarantino'
};
```
There is a function that lets us do a very direct form of inheritance, where a new object is created, directly inheriting from another object. This function is `Object.create` and it takes an object to inherit from as a first argument and an object specifying new properties as a second parameter. This function is new as of ECMAScript 5.1, but we can use a small polyfill that discards the second argument but provides us with a way of having a new object inherit from another one.

```javascript
if (typeof Object.create !== 'function') {
    Object.create = function (o) {
        var F = function () { };
        F.prototype = o;
        return new F();
    };
}
```
Before we try to understand, what this function does, let us first create a new movie object, that inherits from the one above:
```javascript
var anotherMovie = Object.create(movie);
anotherMovie.title = 'Reservoir Dogs';

anotherMovie.title; // 'Reservoir Dogs'
anotherMovie.director; // 'Quentin Tarantino'
```

The good thing about this pattern is, that it syntactically mimics the way, inheritance works internally. We now have the `anotherMovie` object, with a hidden prototype pointer, reference `movie`. When the `director` property is accessed, the interpreter tries to find it on `anotherMovie`, but without success, since we have not assigned `anotherMovie` a `director` property. The interpreter then goes up the prototype chain, looking for `director` on the `movie` object, where it finds the property.

Of course the same principle applies to methods as they are just function values assigned as members to an object. But the important thing is, what happens to `this`, when a method is executed. To investigate, we will extend on our example from above:
```javascript
movie.runtime = 154;
anotherMovie.runtime = 99;
movie.isLong = function () { return this.runtime > 120; };
```
Not only can we dynamically add properties to our objects, but changes to an object's prototype are also immediately visible, since an object has a reference (not a copy) to its prototype. That is the reason, we can now call the `isLong` function on the `anotherMovie` object. But more important is, what it does: The `this` variable is bound when the function is executed. And as we learnt in [04.02.01](#04.02.01), `this` is bound to the object on that the function is called. That makes it possible for all objects, inheriting from `movie` to share the `isLong` function, while it still works perfectly.
```javascript
anotherMovie.isLong(); // false
```
As before, the JavaScript interpreter can't find an `isLong` property on `anotherMovie` and starts to go through the prototype chain in order to find it. When it is called, the specifier `anotherMovie.` makes the function's `this` variable be bound to `anotherMovie` so that `this.runtime` points to the `runtime` property of `anotherMovie`.