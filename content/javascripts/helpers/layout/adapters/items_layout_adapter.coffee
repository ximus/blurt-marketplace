window.ItemsLayoutAdapter =
  
  bounds: LayoutAdapter.bounds
  
  preferredSize: ->
    width: @el.width(), height: 'auto'
    
  insets: -> left:12, right:12, top:12, bottom:12
  
  doLayout: ->
    
    console.log "Compute intensive layout hapenned!"
    
    # TODO: Rewrite and finalize this temporary code.
    
    # Item width is all based on the
    # item height defined in the CSS...
    new_width = @el.parent().width()
    # item_height = @el.children().first().height()
    
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
    # console.log new_width + " columns: " + columns 
    
    options =
      columns: columns, 
      type: 'grid',
      hgap: 12,
      vgap: 12,
      items: @children
      
    Layout.Grid(options).layout(@)
