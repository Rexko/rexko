// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Functionality to add new items to a page
replace_ids = function(template){  
	var new_id = new Date().getTime();  
	return template.replace(/NEW_RECORD/g, new_id);  
}

activate_links = function(element){
	element.getElementsBySelector('.remove').each(function(link){  
		link.observe('click', NestedAttributesJs.remove);  
	});
	element.getElementsBySelector('.add').each(function(link){  
			link.observe('click', NestedAttributesJs.add);  
	});
	element.getElementsBySelector('.add_nested').each(function(link){  
			link.observe('click', NestedAttributesJs.add_nested);  
	});
	element.getElementsBySelector('.pull_nested').each(function(link){  
		link.observe('click', function(e) {
			this.insert({after: "<img class=\"throb\" src=\"/images/icons/throbber.gif\" style=\"vertical-align:middle\" width=\"16\" height=\"16\">"})
		});
		link.observe('ajax:before', function(e) {
			live_value = this.up('fieldset').down('.type-text').down('input').value; // generalize this
			query = e.target.search.toQueryParams()
			query['live_value'] = live_value
			e.target.search = '?'+Object.toQueryString(query); 
		});
		link.observe('ajax:success', NestedAttributesJs.pull_nested);
	});
}

var NestedAttributesJs = {  
	remove : function(e) {
		el = Event.findElement(e);
		target = el.href.replace(/.*#/, '.');
		var oldStyle = el.up(target).style.border;
		el.up(target).style.border = "3px solid red";
		
		var conf = confirm("Delete this " + el.href.replace(/.*#/, '') + "?");
		if (conf) {
			el.up(target).hide();
			if(hidden_input = el.previous("input[type=hidden]")) hidden_input.value = '1';
		}
		else {
			el.up(target).style.border = oldStyle;
		}
	},
	add : function(e) {  
		element = Event.findElement(e);
		template = replace_ids(eval(element.href.replace(/.*#/, '') + '_template'));  
		element.up('.par').insert({before: template});
		activate_links(element.up('.par').previous());
	},
	add_nested : function(e) {
		el = Event.findElement(e);
		elements = el.rel.match(/(\w+)/g)
		// refactor this later, after it works
		switch (elements.length) {
		case 2:
			par = '.'+elements[0]
			child = '.'+elements[1]
		
			child_container = el.up('.par')
			parent_object_id = el.up(par).down('input').name.match(/.*\[(\d+)\]/)[1]
		
			tempname = el.href.replace(/.*#/, '');
			template = eval('window.' + tempname + '_template') || eval(tempname + '$' + elements[0] + '_template')
		
			template = replace_ids(template).replace(/(attributes[_\]\[]+)\d+/g, "$1"+parent_object_id);
			re = new RegExp("(" + elements[1] + "_attributes[_\\]\\[]+)\\d+", "g");
			template = template.replace(re, "$1NEW_RECORD");
			break;
		case 3:
			par = '.'+elements[0]
			child = '.'+elements[2]
			
			child_container = el.up('.par')
			parent_object_id = el.up(par).down('input').name.match(/.*\[(\d+)\]/)[1]
			middle_object_id = el.up('fieldset').down('input').name.match(/\d+/g)[1]
			
			template = eval(el.href.replace(/.*#/, '') + '$' + elements[1] + '$' + elements[0] + '_template')
			
			template = replace_ids(template).replace(/(attributes[_\]\[]+)\d+/g, "$1"+parent_object_id);
			re = new RegExp("(" + elements[1] + "_attributes[_\\]\\[]+)\\d+", "g");
			template = template.replace(re, "$1"+middle_object_id);
			re = new RegExp("(" + elements[2] + "_attributes[_\\]\\[]+)\\d+", "g");
			template = template.replace(re, "$1NEW_RECORD");
			break;
		}
		child_container.insert({
			before: replace_ids(template)
		})		
		activate_links(child_container.previous());
	},
	pull_nested : function(e) {
		el = Event.findElement(e);
		elements = el.rel.match(/(\w+)/g)
		// refactor this later, after it works
		switch (elements.length) {
		case 2:
			par = '.'+elements[0]
			child = '.'+elements[1]
		
			child_container = el.up('.par')
			parent_object_id = el.up(par).down('input').name.match(/.*\[(\d+)\]/)[1]
		
			template = e.memo.responseText;
			break;
		case 3:
			par = '.'+elements[0]
			child = '.'+elements[2]
			
			child_container = el.up('.par')
			parent_object_id = el.up(par).down('input').name.match(/.*\[(\d+)\]/)[1]
			middle_object_id = el.up('fieldset').down('input').name.match(/\d+/g)[1]
			
			template = e.memo.responseText;
			break;
		}
		child_container.insert({
			before: '<div style="display:none;">'+template+'</div>'
		})
		Effect.BlindDown(child_container.previous().identify(), {duration: 0.25} );
		el.next('.throb').remove();
		activate_links(child_container.previous());
	}
}; 
  
Event.observe(window, 'load', function(){  
	activate_links($$('body')[0]);
});


// For select-all textfields
function select_all(id){
	document.getElementById(id).focus();
	document.getElementById(id).select();
}
