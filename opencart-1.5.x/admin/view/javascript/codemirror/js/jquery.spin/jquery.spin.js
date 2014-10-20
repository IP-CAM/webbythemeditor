/**
 * Copyright (c) 2011-2013 Felix Gnass
 * Licensed under the MIT license
 */
(function(factory) {
  if (typeof exports == 'object') {factory(require('jquery'), require('spin'))}
  else if (typeof define == 'function' && define.amd) {define(['jquery', 'spin'], factory)}
  else {if (!window.Spinner) throw new Error('Spin.js not present')
  factory(window.jQuery, window.Spinner)}
}(function($, Spinner) {
  $.fn.spin = function( action ) {
    return this.each(function() {
      var $this = $(this),
	  $span_spin = $this.children('.spin'),
	  $btn_icon = $this.children('.glyphicon');
		if( action == 'start' ){
			if( $span_spin.length == 0 ){
				$this.data( 'btn-before' , $this.html() ); 
				var load_text = '&nbsp;Loading...';
				if( typeof $this.data('load-text') !== 'undefined'  ){
					load_text = $this.data('load-text');
				}
				$span_spin = $('<span class="glyphicon spin">&nbsp;</span>');
				$this.html( load_text ).prepend( $span_spin );
				createSpin($span_spin, lookForSize($this) );
			}
		}else{
			if( $span_spin.length != 0 ){
				data = $span_spin.data();
				if (data.spinner) {
					data.spinner.stop();
					delete data.spinner;
				}
				$span_spin.remove();
				$this.html( $this.data('btn-before') );
			}
		}
    })
	function createSpin( $element, size ){
	  data = $element.data();
	  if (data.spinner) {
        data.spinner.stop();
        delete data.spinner;
      }
      opts = $.extend({ color: $element.css('color') }, $.fn.spin.presets[size])
      data.spinner = new Spinner(opts).spin( $element.get(0) )
	}
	function lookForSize( $button ){
		if( $button.hasClass('btn-xs') ) return 'xs';
		if( $button.hasClass('btn-sm') ) return 'sm';
		if( $button.hasClass('btn-lg') ) return 'lg';
		return 'df';
	}
  }
  $.fn.spin.presets = {
	xs: { lines: 7, length: 2, width: 2, radius: 3 },
	sm: { lines: 7, length: 2, width: 3, radius: 4 },
	df: { lines: 8, length: 3, width: 3, radius: 5 },
	lg: { lines: 9, length: 5, width: 4, radius: 6 }
  }
}));