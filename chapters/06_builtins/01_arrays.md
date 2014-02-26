## Arrays
Arrays in JavaScript are different to arrays in other languages. The very first edition of the language didn't have arrays at all and when they were added in later, they were implemented as some kind of special objects. Its really best to think of them as objects with numeric property names, called "indices", and a magic `length` property.

Arrays also have their own literal notation in JavaScript and you can create a new array like this:
```javascript
var a = [ 'first', 'second', 'third' ];
```
The `a` variable now contains an array with three elements: the strings `'first'`, `'second'` and `'third'`. You can access the array elements using the bracket notation:
```javascript
console.log(a[0]); // 'first'
```
The dot notation will not work for array elements as numbers are not valid identifiers in JavaScript and the dot notation only works with identifiers.

### Lineage
All arrays inherit from `Object.prototype`, but their constructor is `Array` so they also inherit from `Array.prototype`. The `typeof` operator reports arrays as objects.
```javascript
console.log(typeof []); // 'object'
console.log([] instanceof Array); // true
console.log([] instanceof Object); // true
```
Since ES5, there is a check method `Array.isArray` to test for an array, but you can easily write a polyfill yourself:
```javascript
Array.isArray = function (a {
    return Object.prototype.toString.call(a) === '[object Array]';
};
```
Notice, that we use `Object.prototype`'s `toString` method, because `Array.prototype` overrides that with its own one that works something like this:
```javascript
Array.prototype.toString = function () {
    return this.join(',');
};
```

### indices
An array index has to be an integer between 0 an 2^32-1. When you add an index to an array that is greater than its length, the `length` property will be set to that index plus one.
```javascript
var a = [];
a[5] = 'fifth';
console.log(a.length); // 6
```

### `length`
Arrays have a `length` property which is an integer value that is always one greater than the greatest element index.
```javascript
var a = [ 'Thorin', 'Bombur', 'Balin', 'Bifur', 'Bombur' ];
console.log(a.length); // 5
```
By setting the `length` property to a value, less than the number of elements in the array, all elements with an index greater than or equal to the new length are being deleted.
```javascript
var dwarves = [ 'Bofur', 'Dori', 'Dwalin', 'Nori', 'Oin', 'Gloin' ];
dwarves.length = 3;
console.log(dwarves); // [ 'Bofur', 'Dori', 'Dwalin' ];
```

### Methods
There are a lot of useful methods on `Array.prototype` which all arrays inherit.

#### `concat`
This method takes an arbritrary number of arguments and joins them together in one array. When an array is passed as a parameter it will not be contained in the result array as a single value but rather all of its values are included in the result array.
```javascript
var hobbits = [ 'Frodo', 'Sam', 'Merry', 'Pippin' ];
var men = [ 'Aragorn', 'Boromir' ];
console.log(hobbits.concat(men)); // [ 'Frodo', 'Sam', 'Merry', 'Pippin', 'Aragorn', 'Boromir' ]

console.log([ 'str', [ 1, 2 ]].concat(34, [ 1 ])); // [ 'str', [ 1, 2 ], 34, 1];
```
Array arguments are copied into the new array as a shallow copy, while other kinds of objects are copied by reference.

#### `every`
This method invokes a callback function with every element of an array and returns `true` if the function returned a truthy value for every element of the array. As soon as the function returns a falsy value, `every` returns `false` and does not call the function with the remaining array elements.
```javascript
var numbers = [ 1, 67, 2.3, -856 ];
var moreNumbers = [ 47, 11 ];
var isInteger = function (el) {
    return el === (el|0);
};
console.log(numbers.every(isInteger)); // false
console.log(moreNumbers.every(isInteger)); // true
```
The callback receives three actual parameters: The current array element, its index and a reference to the array. The invocation of `every` can supply a second parameter, that is bound to the `this` of the callback function.

`every` is new as of ES5, but a polyfill could look like this:
```javascript
Array.prototype.every = function (fn, thisArg) {

    var i = 0,
        l = this.length,
        res;

    if (!Array.isArray(this)) {
        throw new TypeError();
    }

    thisArg = thisArg || null;

    for (i; i < l; i += 1) {
        res = fn.call(thisArg, this[i], i, this);
        if (!res) {
            return false;
        }
    }

    return true;

};
```

#### `filter`
This method invokes a callback function for each of an array's elements and returns a new array with all the elements of the original one for which the callback returned a truthy value.
```javascript
var numbers = [ 1, 67, 2.3, -856 ];
var isInteger = function (el) {
    return el === (el|0);
};
console.log(numbers.filter(isInteger)); // [ 1, 67, -856]
```
The callback receives three actual parameters: The current array element, its index and a reference to the array. The invocation of `filter` can supply a second parameter, that is bound to the `this` of the callback function.

`filter` is new as of ES5, but a polyfill could look like this:
```javascript
Array.prototype.filter = function (fn, thisArg) {
    var a = [],
        i = 0,
        l = this.length,
        res;

    if (!Array.isArray(this)) {
        throw new TypeError();
    }

    for (i; i < l; i += 1) {
        res = fn.call(thisArg, this[i], i, this);
        if (res) {
            a.push(false);
        }
    }

    return a;

};
```

#### `find` (ES6)
This method invokes a callback function for each of an array's elements and returns the first value for which the callback returns a truthy value or `undefined` if none of the array's elements passed the test.
```javascript
var numbers = [ 1, 67, 2.3, -856 ];
var isFractional = function (el) {
    return el !== (el|0);
};
console.log(numbers.find(isFractional)); // 2.3
```
The callback receives three actual parameters: The current array element, its index and a reference to the array. The invocation of `find` can supply a second parameter, that is bound to the `this` of the callback function.

`find` is not part of the ES5 standard, but is in the draft for ES6. Currently, only Firefox supports this function, but you can write a polyfill like this:
```javascript
Array.prototype.find = function (fn, thisArg) {
    var i = 0,
        l = this.length,
        res;

    if (!Array.isArray(this)) {
        throw new TypeError();
    }

    for (i; i < l; i += 1) {
        res = fn.call(thisArg, this[i], i, this);
        if (res) {
            return this[i];
        }
    }

    return;

};
```

#### `findIndex`
`findIndex` works analogously to `find` but returns the index of the element found rather than the element itself.

#### `forEach`
The `forEach` methods iterates over the elements of an array and executes a callback function on each iteration.
```javascript
var numbers = [ 1, 6.7, 2.3, -85.6 ];
var toInteger = function (el, i, a) {
    return a[i] = (el|0);
};
numbers.forEach(toInteger);
console.log(numbers); // [ 1, 6, 2, -85 ]
```
`forEach` is new as of ES5, but a polyfill could look like this:
```javascript
Array.prototype.forEach = function (fn, thisArg) {
    var a = [],
        i = 0,
        l = this.length,
        res;

    if (!Array.isArray(this)) {
        throw new TypeError();
    }

    for (i; i < l; i += 1) {
        fn.call(thisArg, this[i], i, this);
    }

    return;
};
```

#### `indexOf`
This method searches for an element in an array and returns the index of its first occurance or `-1` if it is not found. The array elements are compared to a search element via the strict comparison operator `===`.
```javascript
var dwarves = [ 'Oin', 'Gloin', 'Fili', 'Kili' ];
console.log(dwarves.indexOf('Fili')); // 2
console.log(dwarves.indexOf('Gimli')); // -1
```
You can also specify a second parameter that contains the index from which the search shall start.
```javascript
var dwarves = [ 'Oin', 'Gloin', 'Fili', 'Kili' ];
console.log(dwarves.indexOf('Fili', 3)); // -1
```
`indexOf` is new as of ES5, but a polyfill could look like this:
```javascript
Array.prototype.indexOf = function (el, from) {
    var i = +from || 0,
        l = this.length;

    if (!Array.isArray(this)) {
        throw new TypeError();
    }

    for (i; i < l; i += 1) {
        if (el === this[i]) {
            return i;
        }
    }

    return -1;
};
```

#### `join`
This method converts all of an array's elements to strings and concates them without altering the original array.
```javascript
var numbers = [ 1, 6.7, 2.3, -85.6 ];
console.log(numbers.join(' + ')); // '1 + 6.7 + 2.3 + -85.6'

var r = [ 'to rule them all,', 'to find them', 'to bring them all' ];
verse = 'One Ring ' + r.join(' One Ring ') + ' and in the darkness bind them';
console.log(verse); // 'One Ring to rule them all, One Ring to find them One Ring to bring them all and in the darkness bind them'
```

#### `lastIndexOf`
This method works analogously to `indexOf`, but returns the last index of the element if it is found in the array.

#### `map`
This method creates a new array based on another one by passing the elements of the orignal array into a callback function and putting the callback's return values in the new array.
```javascript
var numbers = [ 0, 5, 11 ];
var squares = numbers.map(function (val) { return val*val; });
console.log(squares); // [ 0, 25, 121 ]
```
The callback receives three actual parameters: The current array element, its index and a reference to the array. The invocation of `map` can supply a second parameter, that is bound to the `this` of the callback function.

`map` is new as of ES5, but a polyfill could look like this:
```javascript
Array.prototype.map = function (fn, thisArg) {
    var a = [],
        i = 0,
        l = this.length,
        res;

    if (!Array.isArray(this)) {
        throw new TypeError();
    }

    for (i; i < l; i += 1) {
        res = fn.call(thisArg, this[i], i, this);
        a.push(res);
    }

    return a;
};
```

#### `pop`
This method returns the last element of an array and removes it from the array.
```javascript
var planets = [ 'Tatooine' 'Taris', 'Manaan', 'Coruscant' ];
var popped = planets.pop();
console.log(popped); // 'Coruscant'
cnosole.log(planets); // [ 'Tatooine', 'Taris', 'Manaan' ]
```
Notice that this method alters the array on which it is called on.

#### `push`
This method add a new element to the end of an array.
```javascript
var planets = [ 'Kashyyk', 'Korriban', 'Yavin' ]
planets.push('Hoth');
console.log(planets); // [ 'Kashyyk', 'Korriban', 'Yavin', 'Hoth' ]
```
Notice that this method alters the array on which it is called on.

#### `reduce`
This method iterates over all of an array's elements, executes a callback for each of them and returns the returns value of the last callback.
```javascript
var numbers = [ 1, 67, 2.3, -856 ];
var sum = numbers.reduce(function (prevSum, curr) { return prevSum + curr; });
console.log(sum); // -785.7
```
The callback receives four actual parameters: The return value of the previous callback execution, the current array element, its index and a reference to the array. The invocation of `find` can supply a second parameter, that is bound to the `this` of the callback function.

#### `reduceRight`
This method works analogously to `reduce`, but traverses the array from the end to the beginning. Apart from the order in which the array elements are visited there is no difference to `recude`

#### `reverse`
This method alters an array by reversing the order of the elements inside the array.
```javascript
var a = [ 'third', 'second', 'first' ];
a.reverse();
console.log(a); // [ 'first', 'second', 'third' ]
```
Notice that this method alters the array on which it is called on.

#### `shift`
This method returns the first element of an array and removes it. `shift` works like `pop` but on the first rather than the last array element.
```javascript
var planets = [ 'Dantooine', 'Alderaan', 'Dagobah', 'Bespin' ];
var shifted = planets.shift();
console.log(shifted); // 'Dantooine'
console.log(planets); // [ 'Alderaan', 'Dagobah', 'Bespin' ]
```
Notice that this method alters the array on which it is called on.

#### `slice`
This method returns a portion of an array. It returns a new array which is a shallow copy of a part of the original array, where the part to be sliced is determined by `slice`'s parameter. The first parameter specifies the index of the first element to be sliced and the second parameter specifies the index of the first element that is not sliced.
```javascript
var fellowship = [ 'Legolas', 'Frodo', 'Sam', 'Merry', 'Pippi', 'Gimli'];
var hobbits = fellowship.slice(1, 5);
```
When the first argument is a negative number, the slicing offset will be calculated from the end of the array. The same goes for the second argument of slice and when both arguments are omitted, the whole array is returned.
```javascript
var fellowship = [ 'Legolas', 'Frodo', 'Sam', 'Merry', 'Pippi', 'Gimli' ];
var dwarves = fellowship.slice(-1);
```

#### `some`
This method invokes a callback function with every element of an array and returns `true` if the function returned a truthy value for an element of the array. As soon as the function returns a truthy value, `some` returns `true` and does not call the function with the remaining array elements.
```javascript
var numbers = [ 1, 67, 2.3, -856 ];
var moreNumbers = [ 4.7, 1.1 ];
var isInteger = function (el) {
    return el === (el|0);
};
console.log(numbers.some(isInteger)); // true
console.log(moreNumbers.some(isInteger)); // false
```
The callback receives three actual parameters: The current array element, its index and a reference to the array. The invocation of `some` can supply a second parameter, that is bound to the `this` of the callback function.

`some` is new as of ES5, but a polyfill could look like this:
```javascript
Array.prototype.every = function (fn, thisArg) {

    var i = 0,
        l = this.length,
        res;

    if (!Array.isArray(this)) {
        throw new TypeError();
    }

    thisArg = thisArg || null;

    for (i; i < l; i += 1) {
        res = fn.call(thisArg, this[i], i, this);
        if (res) {
            return true;
        }
    }

    return false;

};
```

#### `sort`
This method sorts the elements of an array in place.
```javascript
var letters = [ 'r', 'p', 'a', 'e' ];
console.log(letters.sort()); // [ 'a', 'e', 'p', 'r' ];
```
The default sorting order is lexicographic, but you can change it by supplying the `sort` method with a comparison function. This function takes two arguments `a` and `b` and returns a numbers less than 0, when `a` comes before `b`, `0` when both values are considered of equal rank and a number greater than `0` when `b` comes before `a`.
```javascript
var compareByLength = function (a, b) {
    if (a.length < b.length) {
        return -1;
    } else if (a.length > b.length) {
        return +1;
    } else {
        return 0;
    }
};
var fellowship = [ 'Aragorn', 'Legolas', 'Sam', 'Gimli', 'Pippin' ];
console.log(fellowship.sort()); // [ 'Aragorn', 'Gimli', 'Legolas', 'Pippin', 'Sam' ]
console.log(fellowship.sort(compareByLength)); // [ 'Sam', 'Gimli', 'Pippin', 'Aragorn', 'Legolas' ]
```
Notice that the `sort` method does not guarantee a stable sort.

#### `splice`
This method both removes elements from an array and adds new ones. `splice` takes an arbritrary number of arguments; the first argument is the index of the first array element that is ought to be removed, the second argument specifies how many array elements are removed and all the remaining arguments are inserted as elements in the new gap. You can insert more new elements than are removed with the effect of moving all of the elements on the right of the gap further. `splice` returns an array of removed elements or a single element if only one element was removed.
```javascript
var planets = [ 'Dagobah', 'Yavin', 'Cathar', 'Coruscant' ]
var removed = planets.splice(1, 2, 'Onderon', 'Telos', 'Kashyyk');
console.log(removed); // [ 'Yavin', 'Cathar' ]
console.log(planets); // [ 'Dagobah', 'Onderon', 'Telos', 'Kashyyk', 'Coruscant' ];
```
Notice that this method alters the array on which it is called on.

#### `unshift`
This method adds a new element to the beginning of an array. `unshift` is to `shift` what `push` is to `pop`.
```javascript
var planets = [ 'Kashyyk', 'Korriban', 'Yavin' ]
planets.unshift('Hoth');
console.log(planets); // [ 'Hoth', 'Kashyyk', 'Korriban', 'Yavin' ]
```
Notice that this method alters the array on which it is called on.