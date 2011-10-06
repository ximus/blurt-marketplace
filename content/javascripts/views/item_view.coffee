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