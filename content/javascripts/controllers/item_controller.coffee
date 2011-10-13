# A tile list item

# Dragging inspired by http://developer.apple.com/library/safari/#documentation/InternetWeb/Conceptual/SafariVisualEffectsProgGuide/InteractiveVisualEffects/InteractiveVisualEffects.html#//apple_ref/doc/uid/TP40008032-CH3-SW3
class window.ItemController extends Spine.Controller
  
  @include LayoutAdapter
  
  item: null
  # Defined in the constructor
  dragTarget: null
  
  events:
    'tap'      : 'itemSelected'
    'longTap'  : 'dragStart'
    
  constructor: ->
    super
    @dragTarget = app.favoritesBin
                                       
  render: =>
    @replace $('<li><p class="title">'+@item.title+'</p><img src="'+@item.image_url+'"></li>') 
    @ 
    
  itemSelected: ->
    # console.log "[ItemView] itemSelected"
    app.itemSelected(@item)
    
  dragStart: (e) ->
    e = e.data
    # Start tracking when the first finger comes down in this element
    return false if e.targetTouches.length != 1
    
    @_drag_startX = e.targetTouches[0].clientX
    @_drag_startY = e.targetTouches[0].clientY  
    
    @el.addClass 'dragging'
    @trigger 'dragStart'
    
    @el.bind 'touchmove', @dragMove
    @el.bind 'touchend touchcancel', @dragEnd
    
    false 
      
  dragMove: (e) =>                            
    # Prevent the browser from doing its default thing (scroll, zoom)
    e.preventDefault()
    # Don't track motion when multiple touches are down in this element (that's a gesture)
    return false if e.targetTouches.length != 1
    
    leftDelta = e.targetTouches[0].clientX - @_drag_startX
    topDelta  = e.targetTouches[0].clientY - @_drag_startY

    @_drag_leftDelta = (@_drag_leftDelta or 0) + leftDelta
    @_drag_topDelta  = (@_drag_topDelta  or 0) + topDelta
    
    isOnTarget = @isOnDragTarget()
     
    # Check to see if item is over drag target
    # alert the target     
    if isOnTarget and not @_drag_seenOnTarget # Just came on target 
      @_drag_seenOnTarget = true
      @el.addClass 'on-target'
      @dragTarget.dragEntered()
    else if @_drag_seenOnTarget and not isOnTarget # Just left target
      @_drag_seenOnTarget = false
      @el.removeClass 'on-target'
      @dragTarget.dragExited()

    # console.log "newLeftDelta: #{leftDelta} newTopDelta: #{topDelta}, \n newLeft: #{@_drag_leftDelta} newTop: #{@_drag_topDelta}"

    @el[0].style.webkitTransform = 'translate(' + @_drag_leftDelta + 'px, ' + @_drag_topDelta + 'px)'

    @_drag_startX = e.targetTouches[0].clientX
    @_drag_startY = e.targetTouches[0].clientY

    false
    
  dragEnd: (e) =>
    # Prevent the browser from doing its default thing (scroll, zoom)
    e.preventDefault()
    # console.log "Touch end Top: "@el.offset().top + " Left:" + @el.offset().left
    # Stop tracking when the last finger is removed from this element
    return false if e.targetTouches.length > 0
    
    # Last move, was I on target? 
    if @_drag_seenOnTarget 
      @_drag_seenOnTarget = false
      @el.removeClass 'on-target'
      @dragTarget.dragExited()
    
    @trigger 'dragEnd'
    
    # @el[0].style.webkitTransform = 'translate(' + 
    #   (@_drag_initX - @_drag_leftDelta) + 'px, ' + 
    #   (@_drag_initY - @_drag_leftDelta) + 'px)'  
    
    console.log "#{@_drag_initX} #{@el.offset().left}"
      
    @el.anim translate: "0,0", .3, 'ease-out', =>
      @el.removeClass 'dragging'
    
    @el.unbind 'touchmove', @dragMove
    @el.unbind 'touchend',  @dragEnd 
    
    false
  
  isOnDragTarget: ->
    return false if @dragTarget is null
    o = @el.offset() # Bounding Rect
    points = [
      [ # Top Left
        o.top, # y 
        o.left # x
      ],
      [ # Top Right
        o.top,
        o.left + o.width
      ],
      [ # Bottom Right
        o.top  + o.height,
        o.left + o.width
      ],
      [
        o.top + o.width,
        o.left
      ]
    ]
    
    for point in points
      match = document.elementFromPoint(point[1], point[0])
      if match and (match is @dragTarget.el.get(0) or match.compareDocumentPosition(@dragTarget.el.get(0)) & document.DOCUMENT_POSITION_CONTAINS)
        return true 
    
    false
    