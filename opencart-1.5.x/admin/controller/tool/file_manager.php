<?php 
class ControllerToolFileManager extends Controller { 
	private $error = array();

	public function index() {		
		
		if (!$this->user->hasPermission('modify', 'tool/file_manager')) {
			$this->session->data['error'] = $this->language->get('error_permission');
			
		}
		
		if (isset($this->session->data['error'])) {
			$this->data['error_warning'] = $this->session->data['error'];

			unset($this->session->data['error']);
		} elseif (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}
		
		$this->language->load('tool/file_manager');

		$this->document->setTitle($this->language->get('heading_title'));
		
		$this->data['heading_title'] = $this->language->get('heading_title');

		$this->data['text_files'] = $this->language->get('text_files');
		$this->data['text_template_files'] = $this->language->get('text_template_files');
		$this->data['text_name'] = $this->language->get('text_name');
		$this->data['text_modified'] = $this->language->get('text_modified');
		$this->data['text_loading'] = $this->language->get('text_loading');

		$this->data['text_saved_successfully'] = $this->language->get('text_saved_successfully');
		$this->data['text_failed_to_save'] = $this->language->get('text_failed_to_save');
		
		$this->data['text_deleted_successfully'] = $this->language->get('text_deleted_successfully');
		$this->data['text_failed_to_delete'] = $this->language->get('text_failed_to_delete');
				
		$this->data['text_failed_to_save'] = $this->language->get('text_failed_to_save');
		$this->data['text_delete_warning'] = $this->language->get('text_delete_warning');
		
		$this->data['btn_delete'] = $this->language->get('btn_delete');
		
		$this->data['btn_save_changes'] = $this->language->get('btn_save_changes');
		
		$this->data['current_template'] = $this->config->get('config_template');
		
		$this->data['token'] = $this->session->data['token'];
		
		$this->data['breadcrumbs'] = array();

		$this->data['breadcrumbs'][] = array(
			'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),     		
			'separator' => false
		);

		$this->data['breadcrumbs'][] = array(
			'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('tool/file_manager', 'token=' . $this->session->data['token'], 'SSL'),
			'separator' => ' :: '
		);
		

		$this->template = 'tool/file_manager.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);

		$this->response->setOutput($this->render());
			
	}
	
	public function updatefile(){
		
		if ($this->user->hasPermission('modify', 'tool/file_manager')) {
			$filename = urldecode($_GET['f']);
			if(file_exists($filename)){
				
				$path_parts = pathinfo($filename);

				$fi_directory = $path_parts['dirname'];
				$fi_extension = $path_parts['extension'];
				$fi_filename = $path_parts['filename'];
				
				$bkup_file_path = $fi_directory.'/'.$fi_filename.'_v1.'.$fi_extension;
				$v = 1;
				while(file_exists($bkup_file_path)){
					$v++;
					$bkup_file_path = $fi_directory.'/'.$fi_filename.'_v'.$v.'.'.$fi_extension;
				}
				
				copy($filename, $bkup_file_path);
				
				file_put_contents($filename, html_entity_decode($_POST['contents'], ENT_COMPAT, 'UTF-8'));
				echo '1';
			} else {
				echo '0';
			}
			exit;
		}
		
	}
	
	
	public function getfile(){
		
		if ($this->user->hasPermission('modify', 'tool/file_manager')) {
			$filename = urldecode($_GET['f']);

			if(file_exists($filename)){
				echo file_get_contents(urldecode($_GET['f']));
			}
			
			exit;
		}
		
	}
	
	public function deletefile(){
		
		if ($this->user->hasPermission('modify', 'tool/file_manager')) {
			$filename = urldecode($_GET['f']);

			if(file_exists($filename)){
				echo @unlink(urldecode($_GET['f']));
			}
			
			exit;
		}
		
	}
}
?>