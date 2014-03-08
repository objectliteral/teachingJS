# 02 Fundamentals

In order to learn how to write JavaScript programs we will introduce the building blocks of the language one-by-one. We will not write useful code right away but start with covering the fundamental aspects of the language that set the basis for everything you will learn later on and provide you with enough knowledge to feel like you can estimate the extent of the langauge. I chose this approach over a more practical one so that we can cover all the topics in a complete and self-contained fashion. Working a lot with practical examples is great, but it can easily lead to an unstructured text where pieces of information regarding a specific topic are scattered all over the place rather than being fully explained in their own chapter.

As a consequence of this approach, the following chapter might seem daunting at times, but it contains a lot of useful information. It coveres:
- JavaScript's types, 
- the statements you can use to build your program, 
- all the operators that are in the language to compute new values from existing ones, 
- information about how the language converts values of one type into another type and
- it shows you how variables are declared.

Example code in this chapter is rather short and often very generic. Its main purpose here is to illustrate syntax of new language elements.

### Comments
Because you will encouter them in example code, I want to quickly introduce comments. Comments inside JavaScript code are written in C-syntax meaning that block comments start with `/*` and end with `*/` and line comments start with `//` and end with the end of the line. 

In the examples in the following chapters there are a lot of expressions that do not really do anything but that evaluate to a value. If I mean to tell you, what this value is, I include it in a comment after the expression. Example:
```javascript
1 + 5; // 6
```

### A JavaScript program
When you read an introductory book about a programming language it often tells you early on how you can execute a program and what a program in that language consists of. What I don't like about the idea is that it might be difficult for a newcomer to distinguish between a language and the environment that it runs in. But I feel like it is more important to give you the opportunity to try out some code and get your hands dirty, so let's get to it.

JavaScript is an interpreted language. That means that JavaScript source code is not compiled to executable code which can be run directly by the operating system. Nor does JavaScript source code compile to bytecode that runs in a VM or something like that. Well, of course, JavaScript code *is* compiled to executable code, but this is done while the code is being executed. As a consequence, JavaScript needs to have a runtime environment where an interpreter compiles the code (using enormously clever techniques) and runs it right away. The most common runtime environment - the one everybody has installed on their computer - is a web browser. JavaScript was meant to be a programming language for the web and shortly after its release, supporting JavaScript execution became obligatory for browser vendors to implement. Whether you use [Google Chrome](https://www.google.com/intl/en/chrome/browser/), [Mozilla Firefox](https://www.mozilla.org/en-US/firefox/), [Opera](http://www.opera.com/), [Apple Safari](http://www.apple.com/safari/) or even Microsoft Internet Explorer - you are using a JavaScript runtime environment every day. Those browsers differ in their implementation of JavaScript in some features of the language they do or do not support, in the speed at which they compile and run JavaScript code and in weird quirks that sometimes make it really hard to write code that runs in all browsers. But you can also run JavaScript on the console using implementations like [NodeJS](http://nodejs.org/) or [PhantomJS](http://phantomjs.org/). NodeJS is the most important "server-side" JavaScript environment and while also coming with a console REPL, it allows you to run any JavaScript code from a file.

### stdout
One particular function that you should know is the default way in which we output text to the console (independent of whether this console is inside a web browser or not) because the examples make heavy use of that. `console.log` is not part of the JavaScript language but is by convention implemented in nearly all modern JavaScript environments. So for all of our tests and examples we will use `console.log` just like you would use `System.out.println` in Java.

### "Hello World"
JavaScript does not rely on any formal construct that you need to include in your program in order to run it; like there is no `main` function or whatsoever. You simply place your code where an interpreter can find it and you're good to go. In order to write a simple "Hello World"-program we don't need to do anything but to log something to the console like this:
```javascript
console.log('Hello Word!');
```
Now where do you need to enter this code in order to run it? Again, I don't want to go into any details about JavaScript environments right now, but I believe it helps your understanding of the language plus it enables you to test out your own code.

### Browser console
There are basically two ways you can execute JavaScript code in your browser. The first one is by entering it into the browser console. You can open up the developer tools of your browser by pressing `F12` in Chrome and Internet Explorer and by pressing `Ctrl`+`Shift`+`k` in Firefox. In the panel that will show up, there is generally a "Console" tab. This tab includes an input field in which you can enter your JavaScript code and execute it by pressing `Return`. If you have never done this before: Try it! Works? Congratulations to your very first bit of JavaScript code!

### Browser script
Browsers render webpages from HTML-formatted text. An HTML document can contain a `<script>` tag which tells the browser to execute everything inside that tag as JavaScript code. You can write a simple HTML document containing a `script` element and place your JavaScript code in there. You can then open the document with your browser that will execute the code immediately. Make sure to have the console opened up in order to see the output from the `console.log` command.
```HTML
<!doctype html>
<html>
    <body>
        <script>
            console.log('Hello World!');
        </script>
    </body>
</html>
```

### Node
As said before, NodeJS comes with a REPL for your OS console. If you don't like to run examples in your browser, download NodeJS from [their website](http://www.nodejs.org), install it, open up your OS' command prompt and type in `node`. That will enter the node shell where you can enter JavaScript code and execute it with `Return`.

You can also put your code in a file, say `hello.js`, and execute it by entering `node hello.js` in your command prompt.

---

Now you should be able to execute your own JavaScript code or at least copy and paste the examples from this book into your execution environment of choice and confirm that the example code does what I say it does. Without further ado let's start looking at the fundamental concepts and parts of the language.