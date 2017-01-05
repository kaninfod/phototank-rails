s = undefined
App.PhotoLike = do ->

  init: ->

    s =
      photoGrid: '#photogrid'
      modalElement: $('#photoDetails')
      likeButtonId: '.like'
      numberOfLikes: '.likes_num'
      eventNamespace: 'photo'
    @bindUIActions()


  bindUIActions: ->
    _this = this
    $('body').off 'click.' + s.eventNamespace, s.likeButtonId
    $('body').on 'click.' + s.eventNamespace, s.likeButtonId, -> _this.likePhoto($('#photo_id').data("photo_id"))

  likePhoto: (photoId) ->
    url = '/photos/' + photoId + '/like'
    $.get url, (data) ->
      $(s.numberOfLikes).html data['likes'] + ' likes'
      $(s.likeButtonId).toggleClass 'green'


$(document).on "turbolinks:load", ->
  return unless $(".photos.index, .catalogs.show, .albums.show , .locations.show").length > 0
  App.PhotoLike.init()
