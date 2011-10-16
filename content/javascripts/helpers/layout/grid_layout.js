/*!
 * Heavily inspired from : jLayout Grid Layout - v0.41. 
 * Javascript for better performance tuning, rather than coffee
 */

(function () {
	Layout = typeof Layout === 'undefined' ? {} : Layout;

	Layout.Grid = function (spec, shared) {
		var my = shared || {},
			that = {};

		my.hgap = spec.hgap || 0;
		my.vgap = spec.vgap || 0;

		// initialize the number of columns to the number of items
		// we're laying out.
		my.items = spec.items || [];
		my.columns = spec.columns || my.items.length;
		my.rows = spec.rows || 0;
		my.fillVertical = spec.fill && spec.fill === 'vertical';

		if (my.rows > 0) {
			my.columns = Math.floor((my.items.length + my.rows - 1) / my.rows); 
		} else {
			my.rows = Math.floor((my.items.length + my.columns - 1) / my.columns);
		}
	
		that.items = function () {
			var r = [];
			Array.prototype.push.apply(r, my.items);
			return r;
		};

		that.layout = function (container) {
			var i, j,
				insets = container.insets(),
				x = insets.left,
				y = insets.top, 
				height, width;
      
      width = (container.bounds().width - (insets.left + insets.right) - (my.columns - 1) * my.hgap) / my.columns;
      
      // Square tiles
      if (height === 'auto') height = width;
      // height = (container.bounds().height - (insets.top + insets.bottom) - (my.rows - 1) * my.vgap) / my.rows;

      // Math with integers should be faster
      width  = Math.floor(width);
      height = Math.floor(height); 

			for (i = 0, j = 1; i < my.items.length; i += 1, j += 1) { 
				my.items[i].bounds({'x': x, 'y': y, 'width': width, 'height': height});

				if (!my.fillVertical) {
					if (j >= my.columns) {
						y += height + my.vgap;
						x = insets.left;
						j = 0;
					}
					else {
						x += width + my.hgap;
					}
				} else {
					if (j >= my.rows) {
						x += width + my.hgap;
						y = insets.top;
						j = 0;
					} else {
						y += height + my.vgap;
					}
				}
				my.items[i].doLayout();
			}
			

		  container.bounds({
			  width:  (width  + my.hgap) * my.columns + insets.right  + insets.left,
			  height: (height + my.vgap) * my.rows    + insets.bottom + insets.top
			})
			return container; 
  	  
		};                                           

		function typeLayout(type) {
			return function (container) {
				var i = 0, 
					width = 0, 
					height = 0, 
					type_size,
					insets = container.insets();

				for (; i < my.items.length; i += 1) {
					type_size = my.items[i][type + 'Size']();
					width = Math.max(width, type_size.width);
					height = Math.max(height, type_size.height);
				}
				return {
					'width': insets.left + insets.right + my.columns * width + (my.columns - 1) * my.hgap, 
					'height': insets.top + insets.bottom + my.rows * height + (my.rows - 1) * my.vgap
				};
			};
		}
		
		function roundNumber(number, digits) {
        var multiple = Math.pow(10, digits);
        var rndedNum = Math.round(number * multiple) / multiple;
        return rndedNum;
    }

		// this creates the min and preferred size methods, as they
		// only differ in the function they call.
		that.preferred = typeLayout('preferred');
		that.minimum = typeLayout('minimum');
		that.maximum = typeLayout('maximum');
		return that;
	};
})();