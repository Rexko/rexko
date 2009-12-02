// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
replace_ids = function(template){  
	var new_id = new Date().getTime();  
	return template.replace(/NEW_RECORD/g, new_id);  
}

var NestedAttributesJs = {  
	remove : function(e) {
		el = Event.findElement(e);
		target = el.href.replace(/.*#/, '.');
		el.up(target).hide();
		if(hidden_input = el.previous("input[type=hidden]")) hidden_input.value = '1';
	},
	add : function(e) {  
		element = Event.findElement(e);
		template = replace_ids(eval(element.href.replace(/.*#/, '') + '_template'));  
		element.up('.par').insert({before: template});
		element.up('.par').previous().getElementsBySelector('.remove').each(function(link){  
			link.observe('click', NestedAttributesJs.remove);  
		});
		element.up('.par').previous().getElementsBySelector('.add').each(function(link){  
				link.observe('click', NestedAttributesJs.add);  
		});
	}
}; 
  
Event.observe(window, 'load', function(){  
	$$('.add').each(function(link){  
		link.observe('click', NestedAttributesJs.add);  
	});  
	$$('.remove').each(function(link){
		link.observe('click', NestedAttributesJs.remove);
	}); 
});