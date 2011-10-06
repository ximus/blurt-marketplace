if (jLayout) {
	(function ($) {
		/**
		 * This wraps Zepto objects in another object that supplies
		 * the methods required for the layout algorithms.
		 */
		function wrap(item, resize) {
			var that = {};

			$.extend(that, {
				doLayout: function () {
          return null;
				},
				isVisible: function () {
					return item.css('visibility') === 'visible' &&
					       item.css('display')    !== 'none';
				},
				insets: function () {
					return { 'top': 0, 'left': 0, 'right': 0, 'bottom': 0 };
				},
				bounds: function (value) {
					var tmp = {};

					if (value) {
						if (typeof value.x === 'number') {
							tmp.left = value.x;
						}
						if (typeof value.y === 'number') {
							tmp.top = value.y;
						}
						if (typeof value.width === 'number') {
							tmp.width = value.width;
						}
						if (typeof value.height === 'number') {
							tmp.height = value.height;
						}
						item.css(tmp);
						return item;
					} else {  

						tmp = item.offset();
						return {
              'x': tmp.left,
              'y': tmp.top,
							'width': tmp.width,
							'height': tmp.height
            };
					}
				},
				
				minimumSize: function () {
				  var tmp = { 
				    'width':  item.css('min-width'),
				    'height': item.css('min-height') 
				  };
				  if (tmp.width  === 'none') tmp.width  = 0; 
			    if (tmp.height === 'none') tmp.height = 0;
				  return tmp; 
				},
				
				maximumSize: function () {
  			  var tmp = { 
				    'width':  item.css('max-width'),
				    'height': item.css('max-height') 
				  };
				  if (tmp.width  === 'none') tmp.width  = 1000; 
			    if (tmp.height === 'none') tmp.height = 1000;
				  return tmp; 
				}, 
				
				preferredSize: function () {
			    return { 'width': item.width(), 'height': item.height() };
			  }
			});
			return that;
		}

		$.fn.layout = function (options) {
			var opts = $.extend({}, $.fn.layout.defaults, options);
			return this.each(function () { 
				var element = $(this),
					o = opts,
					elementWrapper = wrap(element, o.resize);
				o.items = [];
				o.columns = 3;
				element.children().each(function (i) { 
					o.items[i] = wrap($(this));
				});
				
				elementWrapper.preferredSize = function () {
				  return { width: $(window).width(), height: $(window).height() }; 
				} 
        console.log({ width: $(window).width(), height: $(window).height() }); 

         elementWrapper.bounds(elementWrapper.preferredSize());

                
				jLayout.grid(o).layout(elementWrapper);
				element.css({position: 'relative'});
			});
		};

		$.fn.layout.defaults = {
			resize: true,
			type: 'grid'
		};
	})(Zepto);
}