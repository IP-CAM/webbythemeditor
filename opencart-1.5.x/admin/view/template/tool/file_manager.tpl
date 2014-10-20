<?php echo $header; ?>
<div id="content">
	  <?php if ($error_warning) { ?>
  <div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/backup.png" alt="" /> <?php echo $heading_title; ?></h1>
    </div>
    <div class="content">
		
		<link rel="stylesheet" href="/admin/view/javascript/codemirror/css/bootstrap.css">
		<link rel="stylesheet" href="/admin/view/javascript/codemirror/addon/dialog/dialog.css">

	<link rel="stylesheet" href="/admin/view/javascript/codemirror/lib/codemirror.css">
	<script src="/admin/view/javascript/codemirror/lib/codemirror.js"></script>
	<script src="/admin/view/javascript/codemirror/addon/edit/matchbrackets.js"></script>

	<script src="/admin/view/javascript/codemirror/mode/htmlmixed/htmlmixed.js"></script>
	<script src="/admin/view/javascript/codemirror/mode/xml/xml.js"></script>
	<script src="/admin/view/javascript/codemirror/mode/javascript/javascript.js"></script>
	<script src="/admin/view/javascript/codemirror/mode/css/css.js"></script>
	<script src="/admin/view/javascript/codemirror/mode/clike/clike.js"></script>
	<script src="/admin/view/javascript/codemirror/mode/php/php.js"></script>
	
	<script src="/admin/view/javascript/codemirror/addon/search/search.js"></script>
	<script src="/admin/view/javascript/codemirror/addon/search/searchcursor.js"></script>
	<script src="/admin/view/javascript/codemirror/addon/dialog/dialog.js"></script>
	
	
	<script src="/admin/view/javascript/codemirror/codemirror-ui/js/codemirror-ui.js" type="text/javascript"></script>
	<link rel="stylesheet" href="/admin/view/javascript/codemirror/codemirror-ui/css/codemirror-ui.css" type="text/css" media="screen" />

	<script type="text/javascript">
	<?php
	$get_file_content_url = '/admin/index.php?route=tool/file_manager/getfile&token='.$token;
	$update_file_content_url = '/admin/index.php?route=tool/file_manager/updatefile&token='.$token;
	$delete_file_content_url = '/admin/index.php?route=tool/file_manager/deletefile&token='.$token;
	?>
	function loadFileContent(ele, filename, relative_path, extension){
		
		var splitted_path = relative_path.split('/');
				
		var search_key = new Array();
		for(var i=0;i<splitted_path.length-1;i++){
			search_key[i] = splitted_path[i];
		}
		/* Search Filter */
		
		$("#coder").html('<?=$text_loading;?>');
		$('#bs-table tr.info').removeClass('info');
		ele.closest('tr').addClass('info');
		var date = new Date();
		var timestamp = date.getTime();
		var url = '<?=$get_file_content_url?>&f='+encodeURI(filename)+'&t='+timestamp;
		$.get(url, null, function (data) {
			$("#code").remove();
            $("#coder").html('<h4 class="label label-info">'+relative_path+'</h4><textarea id="code"></textarea><br /><p><button id="save-button" class="btn btn-sm btn-primary" onclick="updateFile(\''+filename+'\'); return false"><?=$btn_save_changes;?></button><button id="del-button" class="btn btn-sm btn-danger pull-right" onclick="deleteFile(\''+filename+'\'); return false"><?=$btn_delete;?></button></p><p><br /><br /></p>');
			$("#code").val(data);
            activateEditor(extension);
        }, "text");
		
		
		/* Search Filter
		$('#search-file').val($.trim(search_key.join(' ')));
		search_val = $('#search-file').val();
		
		$('#bs-table a.fn').each(function(){
			if($(this).text().indexOf(search_val) > -1){
				$(this).closest('tr').show();
			} else {
				$(this).closest('tr').hide();
			}
			}); */
	}

	function updateFile(filename){
		$('#save-button').text('Saving...., Please wait!');
		var date = new Date();
		var timestamp = date.getTime();
		$.post("<?=$update_file_content_url?>&f="+encodeURI(filename)+'&t='+timestamp,
  			{
    			contents: editor.mirror.getValue()
  			},
  			function(data,status){

  				$('#save-button').text('<?=$btn_save_changes;?>');
  				if(data == '1'){
  					$("#coder").prepend( '<div id="alert-msg" class="alert alert-success"><?=$text_saved_successfully;?></div>' );
  				} else {
  					$("#coder").prepend( '<div id="alert-msg" class="alert alert-danger"><?=$text_failed_to_save;?></div>' );
  				}

  				setTimeout(function(){
  					if($('#alert-msg').length > 0){
  						$('#alert-msg').fadeOut('slow');
  					}

  				}, 3000);
  			}
  		);
	}
	
	function deleteFile(filename){
		delete_file = filename;
		if(confirm('<?=$text_delete_warning?>')){
			var date = new Date();
			var timestamp = date.getTime();
			$.get("<?=$delete_file_content_url?>&f="+encodeURI(filename)+'&t='+timestamp,
				null,
	  			function(data){
					if(data == '1'){
	  					$("#coder").html( '<div id="alert-msg" class="alert alert-success"><?=$text_deleted_successfully;?></div>' );
						
						$('.fn').each(function(){
							if($(this).attr('onclick').indexOf(delete_file) > -1){
								$(this).closest('tr').remove();
								delete_file = '';
								return false;
							}

						});
						
	  				} else {
	  					$("#coder").prepend( '<div id="alert-msg" class="alert alert-danger"><?=$text_failed_to_delete;?></div>' );
	  				}
					
	  				setTimeout(function(){
	  					if($('#alert-msg').length > 0){
	  						$('#alert-msg').fadeOut('slow');
	  					}
	
	  				}, 3000);
	  			}
	  		);
		}
	}
	
	function activateEditor(mode){
		/*
		editor = CodeMirror.fromTextArea(document.getElementById("code"), {
			lineNumbers: true,
	        matchBrackets: true,
	        mode: "application/x-httpd-php",
	        indentUnit: 4,
	        indentWithTabs: true
		});
		*/
		
		switch (mode) {
			case 'css':
			mode = 'text/css'; break;
			case 'tpl':
			case 'html':
			case 'php':
			mode = 'application/x-httpd-php'; break;
			default:
			mode = 'application/x-httpd-php'; break;
		}
		
		editor = new CodeMirrorUI(document.getElementById("code"),
		   {
			    imagePath: '/admin/view/javascript/codemirror/images/silk',
		  	path : 'js/',
			  searchMode : 'inline',
			  buttons : ['undo','redo','jump','reindent'],
		    saveCallback : function(){ alert("Some saving goes here.  Probably AJAX or something fancy."); }
		   },
		   {
			   lineNumbers: true,
	        matchBrackets: true,
	        mode: mode,
	        indentUnit: 4,
	        indentWithTabs: true
		});
	}
	

	$(function(){

		$('#search-file').bind('keydown', function(e){
			var code = e.keyCode || e.which;
			if(code == 46 || code == 13 || code == 8 || code == 37 || code == 38 || code == 39 || code == 40) { 
				$('#search-file').val($.trim($('#search-file').val()));

				$('#bs-table a.fn').each(function(){
					if($(this).text().indexOf($('#search-file').val()) > -1){
						$(this).closest('tr').show();
					} else {
						$(this).closest('tr').hide();
					}
				});
				
			} else {

				search_val = $('#search-file').val()+ e.key;

				$('#bs-table a.fn').each(function(){
					if($(this).text().indexOf(search_val) > -1){
						$(this).closest('tr').show();
					} else {
						$(this).closest('tr').hide();
					}
				});
			}
		});

	});

	function clearSeach(){
		$('#bs-table a.fn').each(function(){
			$(this).closest('tr').show();
		});

		$('#search-file').val('').focus();
	}

	</script>
	<div class="row">
		<div class="col-xs-12 col-md-12">
			<h2 class="page-heading"><?=$text_template_files;?></h2>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-4">
			<div class="table-responsive">
				<table id="bs-table" class="table table-hover table-condensed" style="margin-bottom:0px;">
		        	<thead>
		        		<tr>
			            	<th class="col-lg-12 text-left" colspan="2">
								<div class="input-group">
						            <input type="text" class="form-control input-sm" id="search-file" placeholder="Search..." />
						            <span id="clear_search_btn" class="input-group-btn">
						                <a onclick="clearSeach(); return false;" href="#" class="btn btn-sm btn-danger"><span class="glyphicon glyphicon-remove"></span></a>
						 			</span>
						        </div>
			            	</th>
			          	</tr>
			          	<tr>
			            	<th class="col-lg-8 text-left"><?=$text_name;?></th>            
			            	<th class="col-lg-3 text-right"><?=$text_modified?></th>
			          	</tr>
			        </thead>
				</table>
			</div>
	    	<div class="table-responsive" style="height: 300px;overflow-y: scroll; border-bottom:1px solid #c3c3c3;">
	      		<table id="bs-table" class="table table-hover table-condensed">
			        <tbody>
					<?php
					
					$files = array();
					$directory_path = rtrim($_SERVER['DOCUMENT_ROOT'],'/').'/catalog/view/theme/'.$current_template;
					foreach (new RecursiveIteratorIterator(new RecursiveDirectoryIterator($directory_path)) as $filename){

						$filename = str_replace('//', '/', $filename);
						$relative_path = str_replace($directory_path, '', $filename);
						
						$ext = pathinfo($relative_path, PATHINFO_EXTENSION);

						if(!is_file($filename) || 
							in_array($ext, array(
								'DS_Store','jpg', 'png', 'jpeg', 'gif', 'eot', 'svg', 'woff', 'ttf'
							))
						){
							continue;
						}
						
					?>
					<tr>
            			<td class="col-lg-8 text-left"><span class="glyphicon glyphicon-file"></span><a class="btn btn-xs btn-link fn" href="#" onclick="loadFileContent($(this), '<?=$filename;?>','<?=$relative_path;?>', '<?=$ext?>'); return false;">
							<label class="qsearch btn btn-primary btn-xs"><?=str_replace('/','</label> <label class="qsearch btn btn-primary btn-xs">', ltrim($relative_path,'/'));?></label></a>
						</td>
            			<td class="col-lg-3 text-right"><span class="label label-info"><?=time_ago(date("F d Y H:i:s.", filemtime($filename)))?></span>&nbsp;&nbsp;</td>
          			</tr>
					<?php
					}
					?>
					</tbody>
				</table>
			</div>
		</div>
		<div class="col-sm-8" id="coder"></div>
	</div>
	</div>
</div>
<style type="text/css">
.fn:hover, .fn:focus{
	text-decoration: none;
}
.fn label{
	background: none repeat scroll 0 0 #ccc67f;
	border: 0 none;
	color: black;
	font-size: 12px;
}
.fn label:last-child{
	background: none repeat scroll 0 0 #000000;
	border: 0 none;
	font-size: 12px;
	padding: 2px 5px;	
	color: #FFFFFF;
}
.btn-sm, .btn-group-sm > .btn {
  border-radius: 3px;
  color: #fff !important;
  font-size: 12px;
  line-height: 1.5;
  padding: 5px 10px;
}
.codemirror-ui-find-bar{
	
}
.codemirror-ui-find-bar input[type=text]{
font-size: 12px;
width: 125px;	
}
.codemirror-ui-find-bar input[type=button]{
font-size: 12px;
line-height: 18px;	
}
.codemirror-ui-find-bar input[type=checkbox]{
float: left;
font-size: 12px;
line-height: 18px;
margin: 2px;
}
.codemirror-ui-find-bar label{
    font-size: 12px;
    line-height: 18px;
}
</style>
<?php echo $footer; ?>
<?php
function time_ago($date){
	if(empty($date)) {
		return "No date provided";
	}

	$periods = array("sec", "min", "hr", "day", "week", "month", "year", "decade");
	$lengths = array("60","60","24","7","4.35","12","10");
	$now = time();
	$unix_date = strtotime($date);

	// check validity of date
	if(empty($unix_date)) {
		return "Bad date";
	}

	// is it future date or past date
	if($now > $unix_date) {
		$difference = $now - $unix_date;
		$tense = "ago";
	} else {
		$difference = $unix_date - $now;
		$tense = "from now";
	}

	for($j = 0; $difference >= $lengths[$j] && $j < count($lengths)-1; $j++) {
		$difference /= $lengths[$j];
	}
	
	$difference = round($difference);

	if($difference != 1) {
		$periods[$j].= "s";
	}
	
	return "$difference $periods[$j] {$tense}";
}
?>