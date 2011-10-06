#= require 'libs/zepto/zepto'
#= require 'libs/zepto/event'
#= require 'libs/zepto/detect' 
#= require 'libs/zepto/fx' 
#= require 'libs/zepto/touch' 
#= require 'libs/spine/spine'
#= require 'libs/jlayout.grid' 
#= require 'libs/jlayout.adapter' 
#= require 'sample_items'

$ = Zepto

class App extends Spine.Controller
    
  constructor: ->
    @el = $('#marketplace')
    super
    @itemInfo = new ItemInfoView
    @itemInfo.bind 'nextItem', =>
      index = @items.indexOf(@itemInfo.item) + 1
      index = -1 if index == @items.length-1
      @itemSelected(@items[index])

  loadItems: (items) ->
    @items = items
    items_view = new ItemsView
    @el.append items_view.el 
    items_view.addItems @items
    
  itemSelected: (item) ->
    if @itemInfo.active
      @itemInfo.renderNext = item
      @itemInfo.deactivate()
    else
      @itemInfo.render item
      @itemInfo.activate()
  
  enableScrolling: -> 
    # For the browser
    # $('body, html').css 'overflow', 'scroll'
    # and for the smartphone
    document.ontouchmove = null
    
  disableScrolling: -> 
    # $('body, html').css 'overflow', 'hidden'
    document.ontouchmove = (e) -> e.preventDefault()
    
# A tile list item
class ItemView extends Spine.Controller
  
  item: null
  tag: 'li'
  
  events:
    'tap'     : 'itemSelected'
    'longTap' : 'enableDrag' 
  
  # events:
  #   'click'   : 'itemSelected'
  #   'longtap' : 'enableDrag'  
    
  constructor: ->
    super
                                       
  render: =>
    @replace $('<li><img src="'+@item.image_url+'"></li>') 
    @
    
  itemSelected: ->
    # console.log "[ItemView] itemSelected"
    app.itemSelected(@item)
    
  enableDrag: ->
    @el.addClass 'dragging'
    @el.bind 'touchend', =>
      @el.removeClass 'dragging'
              
    
#   An Items tile view
class ItemsView extends Spine.Controller
  
  tag: 'ul'
  
  constructor: ->
    super
  
  addItem: (item) =>
    view = new ItemView(item: item)
    # Append first because of a bug with Zepto replaceWith
    @el.append view.el
    view.render()
    
  addItems: (items) =>
    @addItem(item) for item in items
    @el.layout(columns:3, type: 'grid')
                                     

# Popover item info
class ItemInfoView extends Spine.Controller

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
    'tap .buy-button'  : 'buyNow'
    'tap .info-button' : 'showMoreInfo'
    'tap img'   : 'deactivate'
    'swipeDown' : 'swipeDown'
    'tap .backbutton' : 'showLessInfo'
    
  # events:
  #   'click .buy-button'  : 'buyNow'
  #   'click .info-button' : 'showMoreInfo'
  #   'click img'   : 'deactivate'
  #   'swipeDown' : 'deactivate'
  #   'click backbutton' : 'showLessInfo'   
    
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
    @time_left.html "Ends in <em>#{@item.time_left.days}</em> days, <em>#{@item.time_left.hours}</em> hours" 
    
  activate: ->
    # console.log '[InfoView] activate'
    app.disableScrolling()
    @el.addClass 'active'
    @centerOnScreen()
    $(window).bind 'orientationchange', @centerOnScreen
    @active = true
    
  deactivate: ->
    # console.log '[InfoView] deactivate'
    to = @el.offset().top + @el.height() + 400
    $(window).unbind 'orientationchange', @centerOnScreen
    @animating = true
    @el.anim top: to, .45, 'ease-out', => 
      @el.removeClass 'active'
      app.enableScrolling()
      @showLessInfo()
      @item = null
      @animating = @active = false
      if @renderNext
        # console.log 'Rendering Next Item'
        @render @renderNext
        @activate()
        @renderNext = null
  
  # This helps out the CSS positioning  
  centerOnScreen: =>
    window_h = $(window).height()
    window_w = $(window).width()
    window_o = window.scrollY # window scroll offset
    el_h = @el.height()
    el_w = @el.width()
    if !(el_w < window_w)
      @el.css 'height', window_h # Annoying hack to get full window height in mobile safari 
    top  = if (el_h < window_h) then ((window_h - el_h) / 2) else 0
    left = if (el_w < window_w) then ((window_w - el_w) / 2) else 0
    top += window_o
    # alert "Window height: #{window_h}, width: #{window_w}, offset: #{window_o} \nEl height: #{el_h}, width: #{el_w}, top: #{top}, left: #{left}"
    @el.css 'left', left
    if @active # if already displayed just fix the positioning
      @el.css 'top', top
    else # else animate it onto the screen
      @el.css 'top', (window_o - el_h - 20) # Position the view just above the viewport 
      setTimeout (=> @el.anim top: top, .4, 'ease'), 5 # and slide it in                 
    
  buyNow: ->
    alert 'Purchase!'
    
  showMoreInfo: (e) ->
    # e.stopPropagation()
    @el.addClass 'more-info'
  
  showLessInfo: ->
    @el.removeClass 'more-info'
    
  swipeDown: ->
    @trigger 'nextItem'   

$ ->    
  window.app = new App
  app.loadItems(SAMPLES)
  document.body.style.webkitTouchCallout = 'none'
  # Avoid some css transforms only supported by iOS
  $('html').addClass('ios') if $.os.ios