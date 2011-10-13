class window.AppController extends Spine.Controller
  
  # This element will fade the background of the item_info_view
  curtain: $('#curtain')
  data_source: new Yipit
    
  constructor: ->
    @el = $('#marketplace')
    super
    
    @itemInfo = new ItemInfoController
    @itemInfo.bind 'nextItem', @nextItemRequested
    @itemInfo.bind 'closing',  @openCurtain
    
    @favoritesBin = new FavoritesBinController
    
  loadItems: (items) ->
    items_view = new ItemsController
    items_view.bind 'itemDragStart', @showFavoritesBin
    items_view.bind 'itemDragEnd',   @hideFavoritesBin
    @el.append items_view.el 
    items_view.addItems items
    
  loadSampleItems: =>
    @data_source.fetch (items) => 
      @loadItems(items)
    
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
    index = @items.indexOf(@itemInfo.item) + 1
    index = -1 if index == @items.length - 1
    @itemSelected @items[index]
    
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
