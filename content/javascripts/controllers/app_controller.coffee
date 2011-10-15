class window.AppController extends Spine.Controller
  
  # This element will fade the background of the item_info_view
  curtain: $('#curtain')
  data_source: new Groupon
    
  constructor: ->
    @el = $('#marketplace')
    super
    
    @itemInfo = new ItemInfoController
    @itemInfo.bind 'nextItem', @nextItemRequested
    @itemInfo.bind 'closing',  @openCurtain
    
    @favoritesBin = new FavoritesBinController
    @itemsView = new ItemsController
    @itemsView.bind 'itemDragStart', @showFavoritesBin
    @itemsView.bind 'itemDragEnd',   @hideFavoritesBin
    @el.append @itemsView.el
    
  loadSampleItems: =>
    @data_source.fetch (items) => 
       @itemsView.addItems items
    
  itemSelected: (item) ->
    if @itemInfo.active
      @itemInfo.renderNext = item
      @itemInfo.deactivate()
    else
      @itemInfo.render item
      @itemInfo.activate()
      @drawCurtain()
      
  
  enableScrolling: -> document.ontouchmove = null
    
  disableScrolling: ->
    document.ontouchmove = (e) -> e.preventDefault()
    
  nextItemRequested: =>
    items = @itemsView.items
    index = items.indexOf(@itemInfo.item) + 1
    index = -1 if index == items.length - 1
    @itemSelected items[index]
    
  showFavoritesBin: =>
    @favoritesBin.activate()
    
  hideFavoritesBin: =>
    @favoritesBin.deactivate()
    
  drawCurtain: () ->
    @curtain.addClass 'active'
    # @curtain.anim opacity: .6, .2, 'ease', callback
  
  openCurtain: =>
    @curtain.removeClass 'active'
    # @curtain.anim opacity: 0, .2, 'ease', =>
    #   @curtain.removeClass 'active'  
