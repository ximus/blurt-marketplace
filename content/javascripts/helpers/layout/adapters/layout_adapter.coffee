window.LayoutAdapter = # I am an interface
  
  isLayable: true
  
  doLayout: -> null
  isVisible: -> throw "Implement me"
  bounds: (value) -> 
    if value
      # A bug in webkit scews up my positioning
      # tmp = {}
      # tmp.top    = value.y      if value.y
      # tmp.height = value.height if value.height
      # tmp.left   = value.x      if value.x
      # tmp.width  = value.width  if value.width
      # @el.css tmp  
      @el[0].style.cssText = "left:#{value.x}px;top:#{value.y}px;width:#{value.width}px;height:#{value.height}px;"
    else
      tmp = @el.offset()
      return x: tmp.left, y: tmp.top, width: tmp.width, height: tmp.height
  insets: -> throw "Implement me"
  maximumSize: -> throw "Implement me"
  minimumSize: -> throw "Implement me"
  preferredSize: -> 
    return width: 'auto', height: 'auto'