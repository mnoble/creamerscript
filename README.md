# CreamerScript
Experiments in language parsing / design.

## Wat?
CreamerScript is a combination of language syntaxes I enjoy, that
compiles to Coffeescript. Yes, that's right, a language that 
compiles to a language that compiles to a language.

Currently the only features pulled from other languages is method syntax
from Objective-C.

This is just a playground; not meant to be used for anything.


## Method Definitions

                       Parameter Names
               .---------------+----------------.
               |               |                |
    def uniq:array is_sorted:sorted iterator:iterator
          |            |                |
          '------------+----------------'
               Signature Keywords


CreamerScript method definitions are made up of Signature Keywords and
Parameter Names.

### Signature Keywords

These are the things on the left-hand side of each colon (:). These are
used to describe what the parameter is. CreamerScript compiles these 
down into the resulting method name. The example above would become 
`uniq_is_sorted_iterator`.

### Parameter Names

These are actual variable names you will use to reference inside your
method body. You can think of these like traditional JavaScript
function arguments.


### Method Definition Compilation

Like it says above, CreamerScript method definitions are compiled into a
Coffeescript method using the Signature Keys. The fully compiled
definition from the example above would be:

```coffeescript
uniq_is_sorted_iterator: (array, sorted, iterator) =>
```

This looks pretty weird, but it won't matter much once you're used to
the Method Invocation syntax.


## Method Invocation

                  Signature Keys
           .-------------+-------------.
           |             |             |
    (this uniq:dates is_sorted:true iterator:callback)
       |         |               |               |
    Subject      '---------------+---------------'
                          Parameter Values


The meat of a Method Invocation is almost the same as its definition.
You have Signature Keys, Parameter Values and a Subject.

### Signature Keys

Same as the definition; descriptions of each parameter.

### Parameter Values

The values to pass in, which will be references using the Definition's
Parameter Names.

### Subject

The object to call the method on.

### Method Invocation Compilation

Does the same sort of thing as Definitions do. Constructs a function
name using the Signature Keys, calls it on Subject and passes Parameter
Values to that resulting function. The above Invocation would become:

```javascript
this.uniq_is_sorted_iterator(dates, true, callback)
```

## TODO

- Nested expressions: `(this foo:(bar baz))`
- Array/Object literals as Parameter Values: `(this foo:[1,2,3] bar:{a: 1, b: 2})`
- Global function support: `($:"#element") #=> $("#element")`

