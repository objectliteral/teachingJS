## Strings

### `String` constructor
There is a constructor function that creates string objects: `String`.
```javascript
console.log(typeof String); // 'function'
var s = String.create('I find your lack of faith disturbing.');
console.log(s); // [object String]
console.log('' + s); // 'I find your lack of faith disturbing.'
```
There is probably no reason to use the `String` constructor to create a so-called wrapper object for a string value. The wrapper does provide useful methods for you to work with strings, but you can access them directly on primitive string values. The JavaScript interpreter will silently create a string object, invoke the method on it, return the result and discard the object immediately.

The `String` has a `prototype` property which points to a string object from which all string objects inherit: `String.prototype`.

### Methods
The methods, available on `String.prototype` and thus also on every string object are the following:

#### `charAt`
This method returns the character at a specified index inside a string. Characters inside a string are index from `0` to `length - 1`.
```javascript
var s = 'Hello World!';
console.log(s.charAt(2)); // 'l'
console.log(s.charAt(8)); // 'r'
```

#### `charCodeAt`
This method returns the Unicode representation of the character at a specified index inside a string.
```javascript
var s = 'Hello World!';
console.log(s.charCodeAt(2)); // 108
console.log(s.charAt(8)); // 114
```

#### `codePointAt` (ES6)

#### `concat`
This method combines an arbritrary number of strings into a new one. If arguments of other types are passed to `concat` they will be coerced to string.
```javascript
var greet = 'Hello ';
var whom = 'World';
console.log(greet.concat(whom)); // 'Hello World'
```

#### `contains` (ES6)

#### `endsWith` (ES6)

#### `indexOf`
This method returns the index of the first occurrence of a string inside another string or `-1` if the search string is not contained inside the other string.
```javascript
var s = 'Hello World';
console.log(s.indexOf('o W')); // 4
console.log(s.indexOf('y')); // -1
```
`indexOf` takes an optional second parameter that specifies the location inside the string from which on the search shall start.
```javascript
console.log(s.indexOf('o')); // 4
console.log(s.indexOf('o', 5)); // 7

#### `lastIndexOf`
This method works just like `indexOf` but searches from the end of a string instead of from the beginning.
```javascript
var s = 'Hello World';
console.log(s.lastIndexOf('o')); // 7
console.log(s.lastIndexOf('l')); // 9
```
The second parameter specifies the index at which the search shall start, but counted from the end.
```javascript
console.log(s.lastIndexOf('o', 0)); // -1
console.log(s.lastIndexOf('o', 5)); // 4
```

#### `localeCompare`

#### `match`
The method runs the string against a regular expression and returns an array with all matches.
```javascript
var s = 'May the force be with you!';
console.log(s.match(/force/)); // [ 'force' ]
```
Regular expression will be covered [in the next suchapter](#06.03.00).

#### `repeat` (ES6)
This method creates a new string by repeating the on that it is called on several times.
```javascript
var a = 'Aaaa';
console.log(a.repeat(5)); // 'AaaaAaaaAaaaAaaaAaaa'
```

#### `replace`
This method does string replacement by searching for a regex or substring and replacing all or the first match. The first parameter of `replace` can be a regex or a substring to search for, the second parameter is either a replacement string or a relpacement function.
```javascript
var s = 'May the force be with you!';
console.log(s.replace('force', 'sauce')); // 'May the sauce be with you!'
console.log(s.replace(/\s/g, '-')); // 'May-the-force-be-with-you!'
console.log(s.replace(/[A-Za-z]/g, function (s) { return s.toUpperCase(); }));
```

#### `search`
This method runs a string against a regular expression and returns the index of the first match or `-1` if there are no matches.
```javascript
var s = 'May the force be with you!';
console.log(s.search(/force/)); // 8
console.log(s.search(/skywalker/)); // -1
```

#### `slice`
This method returns a portion of a string. The first parameter specifies the index of the first character to be sliced and the second parameter specifies the index of the first character that is not sliced.
```javascript
var s = 'It\'s a trap!';
console.log(s.slice(7, 11));
```
When the first argument is a negative number, the slicing offset will be calculated from the end of the string. The same goes for the second argument of slice and when both arguments are omitted, the whole string is returned.
```javascript
var s = 'It\'s a trap!';
console.log(s.slice(-5, -1));
```

#### `split`
This method seperates a string into pieces by a seperator. The seperator can be specified as a string or a regular expression.
```javascript
var sentence = 'These are not the droids you are looking for.';
var words = sentence.split(' ');
console.log(words); // [ 'These', 'are', 'not', 'the', 'droids', 'you', 'are', 'looking', 'for.' ]
```
When the string is empty, `split` returns not an empty array but an array with one element, which is the empty string.

#### `startsWith`

#### `substr`
This method returns a substring from the original string. The first parameter specifies the index of the first character to be included in the substring and the second parameter specifies the length of the substring.
```javascript
var s = 'One ring to rule them all';
console.log(s.substr(4, 4)); // 'ring'
console.log(s.substr(-3)); // 'all'
```
As you can see above, if the first parameter is negative, the offset is calculated from the end of the string. And if the second parameter is omitted, the substring will continue to the end of the original string.

#### `substring`
This method returns a substring from the original string. The first parameter specifies the index of the first character to be included in the substring and the second parameter specifies the index of the first character that is not longer part of the substring.
```javascript
var s = 'One ring to rule them all';
console.log(s.substring(4, 8)); // 'ring'
console.log(s.substring(-3)); // 'One ring to rule them all'
```
When an argument is negative, it is treated as if it were `0`, if the second argument is omitted, the substring will continue to the end of the original string.

#### `toLowerCase`
This method returns a string where all characters are converted to their lower-case version.
```javascript
var s = 'HELLO WORLD!';
console.log(s.toLowerCase()); // 'hello world!'
```
There is also a locale sensitive version `toLocaleLowerCase` that may, in some character sets, return different results.

#### `toString`
This method returns a primitive string value from a string object. You should not use string objects explicitly, but this method may be useful when you want to create a string from any object without knowing whether it is a string object or not.
```javascript
var s = 'X-Wing';
var o = new String('S-Wing');
console.log(s.toString()); // 'X-Wing'
console.log(o.toString()); // 'S-Wing'
```

#### `toUpperCase`
This method returns a string where all characters are converted to their upper-case version.
```javascript
var s = 'It\'s a trap!';
console.log(s.toUpperCase()); // 'IT\'S A TRAP'
```
There is also a locale sensitive version `toLocaleUpperCase` that may, in some character sets, return different results.

#### `trim`
This methods strips whitespace from the beginning and the end of a string and returns the result as a new string value. The original string is not altered.
```javascript
var s = '  Hello World      \t \n  ';
console.log(s.trim()); // 'Hello World'
```

#### `valueOf`
This method does the same thing as `toString`.

### Surrogate Pairs
Be careful when dealing with Unicode characters that are outside of the so-called "Basic Multilingual Plane" (BMP) which consists of 65536 symbols (16bit) and covers most of the characters you need to write in a western language. There are sixteen more namespaces in Unicode (each containing 65536 characters) and JavaScript implementations internally represent characters from these namespaces as a combination of two 16bit values. These are called "surrogate pairs" and have an unfortunate side-effect: JavaScript's string-related functions as well as the magic `length` property consider a single symbol that is composed of a surrogate pair, to be two characters.