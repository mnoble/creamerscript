class Gear
  constructor: (chainring, cog) ->
    @chainring = chainring
    @cog       = cog

  gear_inches: (diameter) =>
    this.ratio() / diameter

  ratio: =>
    @chainring / @cog.to_f


class Wheel
  constructor: (rim, tire, chainring, cog) ->
    @rim  = rim
    @tire = tire
    @gear = new Gear(chainring, cog)

  diameter: =>
    @rim + @tire.size

  gear_inches: =>
    diameter = this.diameter()
    @gear.gear_inches(diameter)
