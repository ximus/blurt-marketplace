#= require 'libs/zepto/zepto'
#= require 'libs/zepto/event'
#= require 'libs/zepto/detect' 
#= require 'libs/zepto/fx' 
#= require 'libs/touch.zepto' 
#= require 'libs/spine/spine'

#= require 'helpers/layout/grid_layout' 
#= require 'helpers/layout/adapters/layout_adapter'
#= require 'helpers/layout/adapters/items_layout_adapter' 
#= require 'sample_items'

#= require 'controllers/item_controller'
#= require 'controllers/items_controller'
#= require 'controllers/item_info_controller'
#= require 'controllers/favorites_bin_controller'
#= require 'controllers/app_controller'

$ = Zepto

$ ->    
  window.app = new AppController
  app.loadItems(SAMPLES)
  # Prevent default popover on a long touch
  document.body.style.webkitTouchCallout = 'none'  # iOS
  # $(document).bind 'touchstart', (e) -> e.preventDefault() # Android
  # Avoid some css transforms only supported by iOS
  $('html').addClass('ios') if $.os.ios