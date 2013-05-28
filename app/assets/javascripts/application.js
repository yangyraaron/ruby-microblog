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

function lazyLoadImg(img, defaultUrl) {
	var url = img.getAttribute('url');

	defaultUrl = defaultUrl || img.getAttribute('src');

	// function onload(){
	// 	img.src=url;

	// 	// listen to the load event only once 
	// 	img.removeEventListener('load',onload);
	// }

	function onerror(e) {
		console.log('loading img error : ' + e);
		//listen to toggle()he error event only once
		img.removeEventListener('error', onerror);

		img.src = defaultUrl;
	}

	//img.addEventListener('load',onload,false);
	img.addEventListener('error', onerror, false);

	img.src = url;
}

function appendParamsToUrl(url, params) {
	var re = /[\?]{1}[^\?]+/;
	if (re.test(url)) {
		url = url + "&"
	} else {
		url = url + "?"
	}

	var i = 0;
	for (var key in params) {
		if (i == 0) {
			url = url + key + "=" + params[key]
		} else {
			url = url + "&" + key + "=" + params[Key]
		}

		i++;
	}

	return url;
}

function feedsList(listId, pageId) {
	this.container = $('#' + listId);
	this.pageContainer = $('#' + pageId);
}

feedsList.prototype = {
	generateItem: function(item) {
		var itemContainer = $("<li></li>");

		//create the body content
		var bodyContainer = $('<ul class="unstyled"></ul>');
		if(item.creator_account){
			bodyContainer.append('<li class="feed-title"><h4>'+item.creator_account+'</h4></li>')
		}

		var content = $("<li><p>" + item.content + "</p></li>");
		var bar = $('<li class="text-info">' + item.created_at + '<div class="pull-right">Reforward() | Comment()</div></li>');

		bodyContainer.append(content);
		bodyContainer.append(bar);

		if (item.creator_account) {
			var layout = $('<div class="container-fluid feed-item"><div class="row-fluid"></div></div>');
			var leftBar = $('<div class="span2"></div>');
			var body = $('<div class="span10"></div>');
			var row = layout.find(".row-fluid");

			row.append(leftBar);
			row.append(body);

			var portrait = $('<img src="attachments/'+ item.creator_image_id +'" />');
			var portraitLayout = $('<a href="#" class="thumbnail"></a>')
			portraitLayout.append(portrait);
			leftBar.append(portraitLayout);

			body.append(bodyContainer);
			itemContainer.append(layout);

		}else{
			itemContainer.append(bodyContainer);
		}

		return itemContainer;
	},
	refresh: function(url, data) {
		if (url) {
			this.url = url;
		}

		this._loadData(data);
	},
	_loadData: function(data) {
		var that = this;
		$('#loading_bar').css('visibility', 'visible');
		$.ajax({
			dataType: 'json',
			url: this.url,
			data: data,
			success: function(data) {
				that._success(that, data);
			}
		});
	},
	_success: function(that, data) {
		$('#loading_bar').css('visibility', 'hidden');
		that._clear();

		for (var i = 0; i < data.feeds.length; i++) {
			var item = that.generateItem(data.feeds[i]);

			this.container.append(item);
			this.container.append("<hr>");
		}

		this.page.index = data.current_index;
		this.page.total = data.total_page;

		this._generatePage();

	},
	_generatePage: function() {
		if (this.page.total > 1) {
			var that = this;
			var paging = function(pageItem, index) {
				return function() {
					pageItem.click(function() {
						var data = {
							page_index: index
						};

						that.refresh(null, data);
					});
				};
			};

			for (var i = 1; i <= this.page.total; i++) {
				var pageItem = $('<li><a href="#">' + i + '</a></li>');
				if (that.page.index == i) {
					pageItem.addClass('active');
				}
				paging(pageItem, i)();

				this.pageContainer.append(pageItem);
			}
		}
	},
	page: {
		index: 0,
		total: 0
	},
	_clear: function() {
		this.container.empty();
		this.pageContainer.empty();
	}
};