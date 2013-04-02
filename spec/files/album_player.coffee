class PreviewRadio::AlbumPlayer
  constructor: (album) ->
    @songs      = []
    @player     = $.find("audio")[0]
    @control    = $.find("#menu #control")
    @album_view = new PreviewRadio::AlbumView()

    this.start(album)
    this.bind()
    this.update()

    @player.load()
    @player.play()

  start: (album) =>
    songs = this.order_by_track_number(album.songs)

    this.fetch_next(album)
    @album_view.set_album(album)
    @album_view.render()

    @player.volume = 0

  order_by_track_number: (album) =>
    @songs.sort((a, b) => a.track_number > b.track_number)

  bind: =>
    @player.on("ended", this.ended)
    @player.on("timeupdate", this.timeupdate)
    @control.on("click", this.toggle)

  ended: =>
    @player.volume = 0
    this.update()
    @player.pause()
    @player.load()
    @player.play()

  timeupdate: =>
    if @player.currentTime < 2.0
      this.fadein()
    else if @player.duration - @player.currentTime < 2.0
      this.fadeout()
    else
      @player.volume = 1.0

    @album_view.set_progress((this.currentTime / this.duration) * 100)

  fadein: =>
    @player.volume = @player.currentTime / 2.0

  fadeout: =>
    @player.volume = (@player.duration - @player.currentTime) / 2.0

  toggle: =>
    if @control.hasClass("stop")
      @player.pause()
      @control.removeClass("stop")
    else
      @player.play()
      @control.addClass("stop")

  update: =>
    if @songs.length == 0
      this.start(@next_album)
    this.set_active_song(@songs.shift())

  fetch_next: (_album) =>
    $.getJSON("/previews/#{_album.id}/next", (album) => this.set_next_album(album))

  set_next_album: (album) =>
    @next_album = album

  set_active_song: (song) =>
    @player.find("source").attr("src", song.preview_url)
    @album_view.set_active_song(song)

