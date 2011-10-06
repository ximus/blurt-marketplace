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
    $(window).bind 'resize', =>
      @el.layout(columns:3, type: 'grid')