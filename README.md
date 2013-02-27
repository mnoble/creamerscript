# CreamerScript
Experiments in language parsing / design.

## Overview

Creamerscript is meant to be a Coffeescript superset, with syntax
features I think are interesting. It's currently just a playground for
me to mess with language parsing / transformation.

## Method Invocation

                  Signature Keys
           .-------------+-------------.
           |             |             |
    (this uniq:dates is_sorted:true iterator:callback)
       |         |               |               |
    Subject      '---------------+---------------'
                          Parameter Values

### Signature Keys

A description of each parameter.

### Parameter Values

The value corresponding to each Signature Key.

### Subject

The object to call the method on.

### Method Invocation Compilation

Methods are called using a Obj-C (ish) syntax. Parenthesis wrap the
entire invocation statement, instead of just the arguments like in 
most languages. So this:

    (console log:"A normal console log")

would become:

```coffeescript
console.log("A normal console log")
```

### Methods With No Parameters

Methods that take no parameters should include a trailing colon in its
invocation. So this:

    (Date now:)

will become:

```coffeescript
Date.now()
```

## Property Invocations

Properties can be accessed the same way methods are, using the
parenthesis syntax. However, property invocations should never include a
colon. So this:

    (this powers)

will become:

```coffeescript
this.powers
```

## TODO

- Global function support: `($:"#element") #=> $("#element")`

