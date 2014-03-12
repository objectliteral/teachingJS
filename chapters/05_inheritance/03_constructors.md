## Constructors

In JavaScript, objects inherit directly from other objects. We talked about the hidden reference that every object has to its prototype and we have manipulated it: By using `Object.create`. But we have not explained, how that function does its magic, because that involves constructors. Despite JavaScript's strongly object oriented understanding of inheritance, there is no way of manipulating the prototype chain, without using constructor functions.

Apart from the hidden link to its prototype, every object in JavaScript has another special property: `constructor`. Actually it is not that special, in that it is not hidden, it is writeable and we will have to set it manually sometimes. An object's `constructor` property is meant to hold a reference to the function that created the object. If we use the `new` operator on a function, it sets the `constructor` property of the new object automatically to the function that was invoked. 

```javascript
var o = new Object();
o.constructor === Object; // true
"".constructor === String; // true
```

The object, an object inherits from, is its construtor's prototype. Quite literally, because every function in JavaScript has a `prototype` property. It points to an object from which all objects, the function creates, should inherit. 

```javascript
var o = { };
o.__proto__ === Object.prototype; // true
```

Sadly, JavaScript is so unconfident about its nature, that it mostly relies on the `new` operator to handle inheritance. There are three ways, of manipulating the hidden link to an object's prototype: The `new` operator, the nonstandard `__proto__` property or `Object.create`. The latter one is not supported in older browsers and if we use our polyfill from [05.02](#05.02) we fall back on using the `new` operator once. `__proto__` is evil.

In the following subchapters we will deal a lot with constructors and use them to implement different object creation patterns.

### The hidden links

Let's look again at a simple constructor function:
```javascript
var Movie = function (title, director) {
    this.title = title;
    this.director = director;
};
var pulpFiction = Movie.create('Pulp Fiction', 'Quentin Tarantino');
```
Now we can examine the objects in memory and their relationship to each other. There is the `pulpFiction` object, with the properties `director`, `title`, an inherited `constructor` property and a hidden prototype reference. The first ones are our data properties, but the other two are more interesting. `constructor` points to the `Movie` function that created the `pulpFiction` object. The hidden prototype property points to an object, that was automagically created by `new`. The prototype inherits from `Object.prototype`, has a `constructor` property, also pointing to `Movie`, and is pointed to by `Movie.prototype`.
```javascript
pulpFiction.title; // 'Pulp Fiction'
pulpFiction.director; // 'Quentin Tarantino'
pulpFiction.constructor === Movie; // true
pulpFiction.__proto__ === Movie.prototype; // true
Movie.prototype.constructor === Movie; // true
```

---

Now that we understand the internals of object creation, we can look at inheritance patterns.