#= require 'libs/zepto/zepto'
#= require 'libs/zepto/event'
#= require 'libs/zepto/detect' 
#= require 'libs/zepto/fx' 
#= require 'libs/zepto/touch' 
#= require 'libs/spine/spine'
#= require 'libs/jlayout.grid' 
#= require 'libs/jlayout.adapter' 
#= require 'sample_items'

#= require 'views/item_view'
#= require 'views/items_view'
#= require 'views/item_info_view'

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

$ ->    
  window.app = new App
  app.loadItems(SAMPLES)
  document.body.style.webkitTouchCallout = 'none'
  # Avoid some css transforms only supported by iOS
  $('html').addClass('ios') if $.os.ios