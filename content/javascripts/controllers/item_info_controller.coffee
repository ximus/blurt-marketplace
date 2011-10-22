# Popover item info
class window.ItemInfoController extends Spine.Controller

  item: null
  active: false
  
  constructor: ->
    @el = $('#item-info')
    super
    
  elements:
    'img'          : 'image'
    '.description' : 'description'
    '.short-desc'  : 'short_desc'
    '.time-left'   : 'time_left'
    '.title'       : 'title'
  
  events:
    'tap .buy.button'  : 'buyNow'
    'tap .info.button' : 'showMoreInfo'
    'tap img'   : 'deactivate'
    'swipeDown' : 'swipeDown'
    'tap .back.button'   : 'showLessInfo'
    'tap .share.button'  : 'share'
    'tap .add-favorite.button' : 'addAsFavorite'  
    
  render: (item) ->
    @deactivate() if @active
    @item = item
    @update()
    
  update: ->
    # console.log '[InfoView] update'
    @image.attr 'src', @item.image_url
    @title.html @item.title
    @description.html @item.description
    @short_desc.html @item.short_desc
    if @item.end_date
      @time_left.html "Ends in <em>#{@item.getTimeLeft().days}</em> days, <em>#{@item.getTimeLeft().hours}</em> hours"
    else 
      @time_left.html "No time limit!" 
      
  activate: ->
    # console.log '[InfoView] activate'
    app.disableScrolling()
    @el.addClass 'active'
    @centerOnScreen()
    $('body').bind 'orientationchange', @centerOnScreen
    @active = true
    
  deactivate: ->
    # console.log '[InfoView] deactivate'
    to = $(window).height() + window.scrollY + 20
    $('body').unbind 'orientationchange', @centerOnScreen
    @el.anim top: to, .35, 'ease', => 
      @el.removeClass 'active'
      app.enableScrolling()
      @showLessInfo()
      @item = null
      @active = false
      if @renderNext
        # console.log 'Rendering Next Item'
        @render @renderNext
        @activate()
        @renderNext = null
    @trigger 'closing' unless @renderNext
  
  # This helps out the CSS positioning
  # Looks up max height and width of item info view
  # then displays the card fullscreen (fits window bounds)
  # or centers the card on the page
  centerOnScreen: =>
    window_h = $(window).height()
    window_w = $(window).width()
    window_o = window.scrollY # window scroll offset
    el_max_h = parseFloat @el.css('max-height')
    el_max_w = parseFloat @el.css('max-width')
    el_h = if window_h > el_max_h then el_max_h else window_h
    el_w = if window_w > el_max_w then el_max_w else window_w
    top  = if (el_h < window_h) then ((window_h - el_h) / 2) else 0
    left = if (el_w < window_w) then ((window_w - el_w) / 2) else 0
    @el.height(el_h)
    @el.width(el_w)
    top += window_o
    # alert "Window height: #{window_h}, width: #{window_w}, offset: #{window_o} \nEl height: #{el_h}, width: #{el_w}, top: #{top}, left: #{left}"
    @el.css 'left', left
    if @active # if already displayed just fix the positioning (ex. device was rotated)
      @el.css 'top', top
    else # else animate it onto the screen
      @el.css 'top', (window_o - el_h - 20) # position the view just above the viewport 
      setTimeout (=> @el.anim top: top, .4, 'ease'), 5 # and slide it in                 
    
  buyNow: -> alert 'Purchase!'
  addAsFavorite: -> alert 'You like this!'
  share: -> alert 'You want others to like this!'

  showMoreInfo: (e) ->
    # e.stopPropagation()
    @el.addClass 'more-info'
  
  showLessInfo: ->
    @el.removeClass 'more-info'
    
  swipeDown: ->
    @trigger 'nextItem'