#= require 'libs/zepto/zepto'
#= require 'libs/zepto/event'
#= require 'libs/zepto/detect' 
#= require 'libs/zepto/fx' 
#= require 'libs/touch.zepto' 
#= require 'libs/spine/spine'
#= require 'libs/jlayout.grid' 
#= require 'libs/jlayout.adapter' 
#= require 'sample_items'

#= require 'views/item_view'
#= require 'views/items_view'
#= require 'views/item_info_view'
#= require 'views/favorites_bin_view'
#= require 'app'

$ = Zepto

$ ->    
  window.app = new App
  app.loadItems(SAMPLES)
  # Prevent default popover on a long touch
  document.body.style.webkitTouchCallout = 'none'  # iOS
  # $(document).bind 'touchstart', (e) -> e.preventDefault() # Android
  # Avoid some css transforms only supported by iOS
  $('html').addClass('ios') if $.os.ios