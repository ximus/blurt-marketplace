# An Items tile view
# This view is not hardcoded into index.html, it gets appended
class window.ItemsController extends Spine.Controller
  
  tag: 'ul'
  
  constructor: ->
    super
  
  addItem: (item) =>
    item_view = new ItemController(item: item)
    # Append first because of a bug with Zepto replaceWith
    @el.append item_view.el
    item_view.render()
    item_view.bind 'dragStart', @itemDragStart
    item_view.bind 'dragEnd',   @itemDragEnd
    
  addItems: (items) =>
    @addItem(item) for item in items
    @layoutItems()
    $(window).bind 'resize', @layoutItems
      
  layoutItems: =>
    # Item width is all based on the
    # item height defined in the CSS...
    new_width = @el.parent().width()
    item_height = @el.children().first().height()
    
    item_height = if new_width < 320
      107
    else if new_width < 768
      160
    else
      192     
    
    # max_item_height = 192
    #     window_height = $(window).height()
    #     
    #     if Math.floor( window_height / max_item_height ) <= 2
    #       item_height = window_height / 2
    #     else
    #       item_height = max_item_height

    if new_width < 256
      columns = 1
    else if new_width < 480
      columns = 2
    else if new_width < 600
      columns = 3     
    else
      columns = Math.floor new_width / item_height
      
    @el.width(new_width) 
    
    @el.children().width(new_width/columns)
    @el.children().height(new_width/columns)
    
    # console.log item_height
    #    
    # console.log new_width + " columns: " + columns
    @el.layout
      columns: columns, 
      type: 'grid',
      hgap: 1,
      vgap: 1
      
  itemDragStart: =>
    @trigger('itemDragStart')
    # @el.css 'border', '2px solid red'
    
  itemDragEnd: =>
    @trigger('itemDragEnd')
    # @el.css 'border', 'none'