window.LayoutAdapter = # I am an interface
  
  isLayable: true
  
  doLayout: -> null
  isVisible: -> throw "Implement me"
  bounds: (value) -> 
    if value
      @el.css 'top',    value.y      if value.y
      @el.css 'height', value.height if value.height
      @el.css 'left',   value.x      if value.x
      @el.css 'width',  value.width  if value.width
    else
      tmp = @el.offset()
      return x: tmp.left, y: tmp.top, width: tmp.width, height: tmp.height
  insets: -> throw "Implement me"
  maximumSize: -> throw "Implement me"
  minimumSize: -> throw "Implement me"
  preferredSize: -> 
    return width: 'auto', height: 'auto'