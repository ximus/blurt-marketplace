# An Items tile view
# This view is not hardcoded into index.html, it gets appended
class window.ItemsView extends Spine.Controller
  
  tag: 'ul'
  
  constructor: ->
    super
  
  addItem: (item) =>
    item_view = new ItemView(item: item)
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
    item_height = @el.children().first().height()
    new_width = @el.parent().width()

    if new_width < 320
      columns = 1
    else if new_width < 480
      columns = 2
    else if new_width < 600
      columns = 3     
    else
      columns = Math.floor new_width / item_height
      
    @el.width(new_width) 
    
    console.log item_height
       
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