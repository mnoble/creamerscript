# CreamerScript

CreamerScript is a language framework on top of Coffeescript.

## Overview

CreamerScript itself is really only a Compiler. That Compiler is really
just a standard way of transforming code.
[Sweeteners](https://github.com/mnoble/creamerscript-sweeteners) are what actually
do the heavy lifting.

## Process

The compilation process is done in two stages. In the first stage, it
runs through all registered Sweeteners and tells them to substitute any 
code they will later want to transform with special tokens.

Once all chunks of code are replaced with tokens, the Compiler will
iterate through those tokens, find the Sweetener responsible for it and
ask it to transform it to Coffeescript. It does this recursively until
all tokens are replaced with the transformed code.

## Rationale

This is very much a poor man's parser approach. There is no AST and
is therefor not a super robust system. You need to be able to match a
chunk of code with a regexp in order to use it with CreamerScript.

The substitution phase is done depth first, meaning the inner-most
entities (of nested entities) are substituted first. Strings, Arrays and
Objects are all substituted first. This gets rid of a lot of the
headache of dealing with nested entities.

## Example

```coffeescript
class Gear
  def constructor:chainring cog:cog
    @chainring = chainring
    @cog       = cog

  def gear_inches:diameter
    (this ratio:) / diameter

  def ratio
    @chainring / (@cog to_f)


class Wheel
  def constructor:rim tire:tire chainring:chainring cog:cog
    @rim  = rim
    @tire = tire
    @gear = (Gear new:chainring cog:cog)

  def diameter
    @rim + (@tire size)

  def gear_inches
    diameter = (this diameter:)
    (@gear gear_inches:diameter)
```

## Usage

From the command line:

```
$ creamer path/to/file.creamer
```

From Ruby:

```ruby
require "creamerscript"
compiler = Creamerscript::Compiler.new("(person say:word)")
compiler.compile
# => "person.say(word)"
```
