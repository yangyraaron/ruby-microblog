// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require bootmetro-charms.js
//= require bootmetro.js
//= require bootstrap.js

function lazyLoadImg (img,defaultUrl) {
	var url = img.getAttribute('url');

	defaultUrl = defaultUrl || img.getAttribute('src');

	function onload(){
		img.src=url;

		// listen to the load event only once 
		img.removeEventListener('load',onload);
	}

	function onerror () {
		img.src=defaultUrl;

		//listen to the error event only once
		img.removeEventListener('error',onerror);
	}

	img.addEventListener('load',onload,false);
	img.addEventListener('error',onerror,false);

	img.src=defaultUrl;
}
