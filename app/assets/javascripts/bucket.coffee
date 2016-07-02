s = undefined

App.Bucket = do ->

  init: (@el) ->
    s =
      overlayClass: 'photo-widget-overlay'
      # bucketClass: 'bucket_overlay'
      eventNamespace: 'photo'
      photoGrid: '#photogrid'
    @update_bucket_count()
    @bindUIActions()


  bindUIActions: ->
    _this = this
    $('.bucket').slimScroll height: $(window).height() - 350
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.photo-widget-overlay', -> _this.toggleBucket(this)
    $('.bucket').on 'bucket:update', -> _this.loadBucket()
    $('body').on 'click.' + s.eventNamespace, '#like-bucket', -> _this.likePhotos()
    $('body').on 'click.' + s.eventNamespace,'#unlike-bucket', -> _this.unlikePhotos()
    $('body').on 'click.' + s.eventNamespace, '#delete-bucket', -> _this.deletePhotos()
    $('body').on 'click.' + s.eventNamespace, '#rotate-bucket',  -> _this.rotatePhotos(this)
    $('body').on 'click.' + s.eventNamespace, '#clear-bucket', -> _this.clearBucket()
    $('body').on 'click.' + s.eventNamespace, '#add-to-album-bucket', -> _this.showAddToAlbum()
    $('#album-list-bucket .btn-primary').on 'click' , (event) -> _this.addToAlbum(event)
    $('#comment-input-bucket').keypress (e) -> _this.addComment(this, e)
    @loadBucket()


  loadBucket: ->
    $.get '/bucket/list', (data) ->
      $('.bucket').html data

  update_bucket_count: ->
    $.get '/bucket/count', (data) ->
      $('#bucket_counter').html data['count']

  likePhotos: ->
    photo_id = $('#photo_id').data("photo_id")#$('.image_info').attr('photo_id')
    url = '/bucket/like'
    $.get url

  unlikePhotos: ->
    photo_id = $('#photo_id').data("photo_id")#$('.image_info').attr('photo_id')
    url = '/bucket/unlike'
    $.get url

  addComment: (commentInput,key) ->
    if key.which == 13
      photo_id = $('#photo_id').data("photo_id")
      url = '/bucket/add_comment'
      $.get url, comment: $(commentInput).val()
      $(commentInput).val ''

  clearBucket: ->
    _this=this
    $.get '/bucket/clear', (data) ->
      _this.loadBucket()
      $('.overlay-button.overlay-select').removeClass('selected zoomOut overlay-show bounceIn')
    false

  deletePhotos: ->
    _this = this
    $.get '/bucket/delete_photos.json', (data) ->
      for photoId in data.bucket
        photoWidget = $('.photo-widget[data-photoid=' + photoId + ']')
        photoWidget.fadeOut(700)
      _this.clearBucket()

  rotatePhotos: (element) ->
    degrees = $(element).data('degrees')
    $.get '/bucket/rotate/' + degrees, (data) ->

  showAddToAlbum: ->
    $('#album-list-bucket').modal()
    $('#album-list-bucket').removeClass 'hidden'

  addToAlbum: ->
    album_id = $('#album-list-bucket * #albums input:radio:checked').val()
    $.get '/bucket/save', {album_id: album_id}


$(document).on "page:change", ->
  App.Bucket.init()
