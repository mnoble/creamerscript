# CreamerScript

CreamerScript is a little language that adds some sugar to CoffeeScript.

It's currently just a playground for language parsing and design; not
meant to be used for anything real.

## Overview

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
|  # Method Definition                            |                                                   |
|  def connect:url with_options:options           |  connect_with_options: (url, options) =>          |
|                                                 |                                                   |
+-------------------------------------------------+---------------------------------------------------+
```

## Method Definitions

Method definitions use the `def` keyword like Python and Ruby. In
addition it uses the signature syntax of languages like Smalltalk 
and Obj-C.

The values on the left-hand side of each colon (:) are the Signature
Keys. These are descriptions of what that parameter is/does. The values
on the right-hand side are the variables you'll use in your method
(Parameter Names).

```coffeescript
def async_request:url queue:queue on_complete:handler
  ($ ajax: url, {success: handler})
```

## Calling Methods

Methods defined in CreamerScript are calling with a similar syntax to
their definitions. If we use the `async_request:queue:on_complete`
example from above, you'd call it like so:

```coffeescript
(this async_request:"example.com" queue:"main_queue" on_complete:null)
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

