function initForm(){
	if($('.alert').length > 0){
		setTimeout(function(){
			$('.alert').fadeOut('slow');
		},3000);
	}
}
function initIndex(){
	$('#selectall').bind('change', function(){
		if($(this).is(':checked')){
			$('#selectall').closest('table').find('tbody input[type=checkbox]').prop('checked', true);
		} else {
			$('#selectall').closest('table').find('tbody input[type=checkbox]').prop('checked', false);
		}
	});
	
	$('#delete_all_link').bind('click', function(){
		if($('#deleteallfrm tbody input:checked').length > 0){
			var recs = '';
			var recs_count = 1;
			$('#deleteallfrm tbody input:checked').each(function(){
				recs += recs_count + ': '+ $(this).closest('tr').find('a:first').text()+"\n";
				recs_count++;
			});
			
			if(confirm("Are you sure you want to delete all selected records?\n\n"+recs)){
				$('#deleteallfrm').submit();
			}
		} else {
			alert('Please select a record to delete');
		}
	});
	
	$("#form_search").submit(function(e){
		var postData = $(this).serializeArray();
		var formURL = $(this).attr("action");
		$.ajax({
			url : formURL,
			type: "POST",
			data : postData,
			success:function(data, textStatus, jqXHR){
				$('#content').html(data);
			},
			error: function(jqXHR, textStatus, errorThrown){
				//if fails     
			}
		});
		e.preventDefault(); //STOP default action
		$(this).unbind(); //unbind. to stop multiple form submit.
	});
	
	if($('.alert').length > 0){
		setTimeout(function(){
			$('.alert').fadeOut('slow');
		},3000);
	}
}
function processOrderBy(ob_url, curr_url){
	$('.ob').each(function(){
		var sortby = $(this).data('sortby');
		var label = $(this).text();
		var direction = 'ASC';
		
		if(curr_url.indexOf('sortby='+sortby) > -1){
			if(curr_url.indexOf('sortdir=ASC') > -1){
				$(this).html('<a data-load-text="'+label+'" onclick="return false;" data-content="content" href="'+ob_url+'&sortby='+sortby+'&sortdir=DESC"><span class="glyphicon glyphicon-sort-by-attributes"></span> '+label+'</a>');
			} else {
				$(this).html('<a data-load-text="'+label+'" onclick="return false;" data-content="content" href="'+ob_url+'&sortby='+sortby+'&sortdir=ASC"><span class="glyphicon glyphicon-sort-by-attributes-alt"></span> '+label+'</a>');
			}
		} else {
			$(this).html('<a data-load-text="'+label+'" onclick="return false;" data-content="content" href="'+ob_url+'&sortby='+sortby+'&sortdir='+direction+'">'+label+'</a>');
		}
	});
	
	$('.ob a').bind('click',function(e){
		var ele = $(this);
		$.ajax({
			type: "POST",
			cache: false,
			async: true,
			url: ele.attr('href')+'&ajax=1',
			beforeSend:function (XMLHttpRequest) {
				ele.spin('start');
			}, 
			complete:function (XMLHttpRequest, textStatus) {
				ele.spin('stop');
			}, 
			success: function(data) {
				$('#'+ele.attr('data-content')).html(data);
				$("body").getNiceScroll().resize();
			}
		});
	});
}

/* Pagniation Script */
function createPagination(url, limit, currpage, total_records,updated_div){
	if(total_records == 0){
		$('#listing-tools').hide();
		return false;
	}

	var no_of_page = (total_records / limit);

	if(no_of_page > parseInt(no_of_page, 10)){
		no_of_page = parseInt(no_of_page, 10) + 1;
	}
	
	/* No of page need to display */
	var display_numbers = 3;
	
	/* Set Numbers To Display */
	var display_pages_start = 1
	var display_pages_end = display_numbers;
	
	if(currpage <= display_numbers){
		if(no_of_page >= display_numbers ){
			display_pages_start = 1
			display_pages_end = display_numbers;
		} else {
			display_pages_start = 1
			display_pages_end = no_of_page;
		}
	} else {
		display_pages_start = currpage - parseInt(display_numbers/2, 10);
		if(display_pages_start < 1){
			display_pages_start = 1;
		}
	
		display_pages_end = currpage + parseInt(display_numbers/2, 10);
		if(display_pages_end > no_of_page){
			display_pages_end = no_of_page;
		}
	}
	
	if(display_pages_end > display_numbers){
		if(display_pages_end-display_pages_start < display_numbers){
			display_pages_start = display_pages_start - (display_numbers - ((display_pages_end+1)-display_pages_start));
		}
	}

	/* Page Info */
	$('#index-pagination').html('<span class="badge cpage">Page: <input data-max="'+no_of_page+'" data-content="'+updated_div+'" data-url="'+url+'" type="text" value="'+currpage+ '" id="pageno" name="pageno" /> / '+no_of_page+'</span>');

	$('#pageno').bind('keypress',function(e){
		var p = e.which;

		if(p==13 && parseInt($('#pageno').val(), 10) > 0){
			if(parseInt($('#pageno').val(), 10) <= parseInt($('#pageno').attr('data-max'), 10)){
				Pace.restart();
				$.ajax({
					type: "POST",
					cache: false,
					async: true,
					url: $('#pageno').attr('data-url')+'&ajax=1&page='+parseInt($('#pageno').val(), 10),
					beforeSend:function (XMLHttpRequest) {
						$('#pageno').spin('start');
					}, 
					complete:function (XMLHttpRequest, textStatus) {
						$('#pageno').spin('stop');
					}, 
					success: function(data) {
						$('#'+$('#pageno').attr('data-content')).html(data);
						$("body").getNiceScroll().resize();
						Pace.stop();
					}
				});
			} else {
				showMessage('error', 'Please enter a page number within the total number of pages.');
			}
		}
	});
	
	/* Previous and First Page */
	if(currpage > 1){
		if((currpage-1) > 1){
			var urlfinal = url+'&page=1';
			$('#index-pagination').append(createBMIUrl(urlfinal, '&laquo;','b',updated_div));
		} else {
			$('#index-pagination').append(createHiddenBMIUrl('&laquo;'));
		}
		var urlfinal = url+'&page='+(currpage-1);
		$('#index-pagination').append(createBMIUrl(urlfinal, '&lsaquo;','b',updated_div));
	} else {
		if((currpage-1) > 1){
			var urlfinal = url+'&page=1';
			$('#index-pagination').append(createBMIUrl(urlfinal, '&laquo;','b',updated_div));
		} else {
			$('#index-pagination').append(createHiddenBMIUrl('&laquo;'));
		}
		$('#index-pagination').append(createHiddenBMIUrl('&lsaquo;'));
	}

	/* Display Numbers */
	if(display_numbers > 0){
		for(var i=display_pages_start; i<=display_pages_end; i++){
			if(currpage == i){
				$('#index-pagination').append(createBMIUrlCurr(i));
			} else {
				var urlfinal = url+'&page='+i;
				$('#index-pagination').append(createBMIUrl(urlfinal, i,'',updated_div));
			}
		}
	}
	
	/* Next and Last Page */
	if(currpage < no_of_page){
		var urlfinal = url+'&page='+(currpage + 1);
		$('#index-pagination').append(createBMIUrl(urlfinal, '&rsaquo;','b',updated_div));
		
		if((currpage + 1) < no_of_page){
			var urlfinal = url+'&page='+ no_of_page;
			$('#index-pagination').append(createBMIUrl(urlfinal, '&raquo;','b',updated_div));
		} else {
			$('#index-pagination').append(createHiddenBMIUrl('&raquo;'));
		}
	} else {
		$('#index-pagination').append(createHiddenBMIUrl('&rsaquo;'));

		if((currpage + 1) < no_of_page){
			var urlfinal = url+'&page='+ no_of_page;
			$('#index-pagination').append(createBMIUrl(urlfinal, '&raquo;','b',updated_div));
		} else {
			$('#index-pagination').append(createHiddenBMIUrl('&raquo;'));
		}		
	}
	
	$('#index-pagination a').bind('click',function(e){
		var ele = $(this);
		$.ajax({
			type: "POST",
			cache: false,
			async: true,
			url: ele.attr('href')+'&ajax=1',
			beforeSend:function (XMLHttpRequest) {
				ele.spin('start');
			}, 
			complete:function (XMLHttpRequest, textStatus) {
				ele.spin('stop');
			}, 
			success: function(data) {
				$('#'+ele.attr('data-content')).html(data);
				$("body").getNiceScroll().resize();
			}
		});
	});
}
function createBMIUrlCurr(txt){
	return '<span class="page-current">'+txt+'</span>';
}
function createHiddenBMIUrl(txt){
	return '<a class="nplf lgtgray" href="#" onclick="return false;">'+txt+'</a>';
}
function createBMIUrl(url, txt, big,updated_div){
	if(big.length > 0){
		return '<a class="btn-xs nplf" data-load-text="" data-content="'+updated_div+'" href="'+url+'" onclick="return false;">'+txt+'</a>';
	} else {
		return '<a class="btn-xs" data-load-text="" data-content="'+updated_div+'" href="'+url+'" onclick="return false;">'+txt+'</a>';
	}
}