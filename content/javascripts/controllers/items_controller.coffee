# An Items tile view
# This view is not hardcoded into index.html, it gets appended
class window.ItemsController extends Spine.Controller
  
  @include ItemsLayoutAdapter
  
  tag: 'ul'
  items: []
  children: []
  
  constructor: ->
    super
  
  addItem: (item) =>
    item_view = new ItemController(item: item)
    # Append first because of a bug with Zepto replaceWith
    @el.append item_view.el
    @children.push item_view
    item_view.render()
    item_view.bind 'dragStart', @itemDragStart
    item_view.bind 'dragEnd',   @itemDragEnd
    
  addItems: (items) =>
    @items = items
    @addItem(item) for item in @items
    @doLayout()
    $(window).bind 'resize', @layoutItems
      
  itemDragStart: =>
    @trigger('itemDragStart')
    
  itemDragEnd: =>
    @trigger('itemDragEnd')