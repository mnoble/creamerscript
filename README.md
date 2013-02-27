# CreamerScript

CreamerScript is a little language that adds some sugar to CoffeeScript.

It's currently just a playground for language parsing and design; not
meant to be used for anything real.

## Overview

In its current state, the only real feature CreamerScript has is 100%
key-based methods, similar to Objective-C. This means the name of
methods are actually a combination of all the parameter keys.

This means every parameter in a function definition has a description
(Signature Key) and a name (Parameter Name). Things get verbose, but I
think giving descriptions for the intent of each parameter helps when
reading though method invocations.

Imagine you come across a method call like this in JavaScript:

```javascript
person.say("Hello", false, "10:00:00")
```

What does the `false` value represent? Why are we passing a time string? 
Many people replace these types of random parameter lists and accept a
Hash of options. This is definitely better, but can still lack the
natural language aspect of using fixed position, keyed parameters.

Using CreamerScript to define and subsequently call this method would
end up looking like this:

```
(person say:"Hello" loudly:false at_time:"10:00:00")
```

So with that you don't need to go hunting down where `say` is defined
and figure out what all the parameters mean. It reads well and conveys
the intent of each parameter. I think it's an improvement.

## Syntax Overview

CreamerScript on the left, compiled CoffeeScript (and sometimes
JavaScript) on the right.

```coffeescript
+-------------------------------------------------+---------------------------------------------------+
|                                                 |                                                   |
|  # Calling a function with arguments            |                                                   |
|  (dog bark:"Hello" loudly:true)                 |  dog.bark_loudly("Hello", true)                   |
|                                                 |                                                   |
|  # Calling a function with no arguments         |                                                   |
|  (dog bark:)                                    |  dog.bark()                                       |
|                                                 |                                                   |
|  # Calling a non-Creamer defined function       |                                                   |
|  (fn apply:null, arg1, arg2, arg3)              |  fn.apply(null, arg1, arg2, arg3)                 |
|                                                 |                                                   |
|  # Getting a property of an object              |                                                   |
|  (person name)                                  |  person.name                                      |
|                                                 |                                                   |
|  # Nested invocations                           |                                                   |
|  (person set_name:(other_guy name))             |  person.set_name(other_guy.name)                  |
|                                                 |                                                   |
+-------------------------------------------------+---------------------------------------------------+
```

## Usage

No binscripts yet, sorry. You can fire up irb and compile CreamerScript
by doing:

```irb
irb(main)001:0> compiler = Creamerscript::Compiler.new
irb(main)002:0> compiler.compile "(@gear gear_inches:diameter)"
=> "@gear.gear_inches(diameter)"
```



## TODO

- Support global function calling: `($: "#wrap") # => $("#wrap")`

