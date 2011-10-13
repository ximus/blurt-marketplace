class window.FavoritesBinController extends Spine.Controller
  
  constructor: ->
    @el = $('#favorites-bin')
    super
    
  activate: =>
    @el.css 'display', 'block'
    @el.css 'top', ( $(window).height() - @el.height() ) / 2 + window.scrollY
    @el.addClass 'active'
    # @el.css 'left',  $(window).width()  - @el.width() + 8 
    
  deactivate: =>
    @el.removeClass 'active'
    @el.one 'transitionend', (e) =>
      # return if e.propertyName not '-webkit-tranform'
      @el.css 'display', 'none'
    
  dragEntered: =>
    @el.addClass 'drop'
    
  dragExited: =>
    @el.removeClass 'drop'
      