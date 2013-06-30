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

function feedsList(listId, pageId, options) {
	this._options = options || {};
	this.container = $('#' + listId);
	this.pageContainer = $('#' + pageId);
}

feedsList.prototype = {
	generateItem: function(item) {
		var itemContainer = $("<li></li>");
		var layout = this._generatePrototype(item, true);
		itemContainer.append(layout);

		return itemContainer;
	},
	_generatePrototype: function(item, showPortrait, isOrigin) {
		var layout = $('<div class="container-fluid feed-item"><div class="row-fluid"></div></div>');
		var body = $('<div class="span10"></div>');
		var row = layout.find(".row-fluid");

		if (showPortrait && item.creator_account) {
			var portrait = $('<img src="attachments/' + item.creator_image_id + '" />');
			var portraitLayout = $('<a href="#" class="thumbnail"></a>');
			var leftBar = $('<div class="span2"></div>');

			portraitLayout.append(portrait);
			leftBar.append(portraitLayout);
			row.append(leftBar);
		} else {
			var body = $('<div class="span12"></div>');
		}

		body.append(this._generateBodyContainer(item, showPortrait, isOrigin));
		row.append(body);
		return row;
	},
	_generateBodyContainer: function(item, showPortrait, isOrigin) {
		var bodyContainer = $('<ul class="unstyled"></ul>');
		var prefix = showPortrait ? "" : "@";
		if (item.creator_account) {
			var headerContainer = $('<li class="feed-title"><h4>' + prefix + item.creator_account + '</h4></li>');

			if (isOrigin)
				headerContainer = $('<li class="feed-title"><h5>' + prefix + item.creator_account + '</h5></li>');

			bodyContainer.append(headerContainer);
		}

		var content = $("<li><p>" + item.content + "</p></li>");
		bodyContainer.append(content);

		if (item.origin_feed_json) {
			var origin = $("<li class='inner-feed'></li>");
			var originItem = this._generatePrototype(item.origin_feed_json, false, true);
			origin.append(originItem);

			bodyContainer.append(origin);
		}

		var lkForward = this.generateForward(item);
		var lkComment = this.generateComment(item);

		var bar = $('<li class="text-info">' + item.created_at + '</li>');
		var barContainer = $('<div class="pull-right"></div>');
		barContainer.append(lkForward);
		barContainer.append(' | ');
		barContainer.append(lkComment);
		bar.append(barContainer);

		bodyContainer.append(bar);

		var commentContainer = $('<li id="comment_container_' + item.this_id + '" class="span12" style="margin-left:0;"></li>');

		bodyContainer.append(commentContainer);
		return bodyContainer;
	},
	generateForward: function(item) {
		var count = item.forward_count || 0;
		var lkForward = $('<a href="#">Forward(' + count + ')</a>');
		var forward = this._options.forward;

		if (forward) {
			lkForward.click(function triggerForward(e) {
				forward(e, item);
			});
		}

		return lkForward;
	},
	generateComment: function(item) {
		var count = item.comment_count || 0;
		var lkComment = $('<a href="#">Comment(' + count + ')</a>');

		var comment = this._options.comment;
		if (comment) {
			lkComment.click(function triggerComment(e) {
				comment(e, item);
			});
		}

		return lkComment;
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

function commentView(comment) {
	this.data = comment;
}

commentView.prototype = {
	_generateContainer: function() {
		this.innerContainer = $('<div class="row-fluid">');
		this.Container = $('<div class="container-fluid none-padding"></div>');
		this.Container.append(this.innerContainer);
	},
	_generateLeftBar: function() {
		this.leftBar = $('<div class="span2"></div>');
	},
	_generateBodyContainer: function() {
		this.bodyContainer = $('<div class="span10"></div>');
	},
	_renderLayout: function() {
		this._generateContainer();
		this._generateLeftBar();
		this._generateBodyContainer();

		this.innerContainer.append(this.leftBar);
		this.innerContainer.append(this.bodyContainer);
	},
	_renderPortrait: function() {
		var portrait = $('<img src="attachments/' + this.data.creator_img_id + '" />');
		var portraitLayout = $('<a href="#" class="thumbnail"></a>');

		portraitLayout.append(portrait);
		this.leftBar.append(portraitLayout);
	},
	_renderbody: function() {
		var body = $('<div></div>');
		var head = $('<p class="text-warning pull-left none-margin">' + this.data.creator_account + ' : </p>');
		var content = $('<p>' + this.data.content + '</p>')

		body.append(head);
		body.append(content);

		this.bodyContainer.append(body);
	},
	render: function() {
		this._renderLayout();
		this._renderPortrait();
		this._renderbody();
	},
	html: function() {
		return this.Container;
	}
};

function commentList(feedId,comments,options) {
	this.feedId = feedId;
	this.data = comments;
	this.options = options||{};
}

commentList.prototype = {
	header: {},
	_generateHeader: function() {
		var text = $('<input class="span12" name="comment[content]"/>');
		var submit = $('<input type="button" class="btn btn-warning btn-small pull-right" value="comment" />');
		var container = $('<ul class="center none-margin"></ul>');

		container.append($('<li></li>').append(text));
		container.append($('<li></li>').append(submit));

		this.header.text = text;
		this.header.submit = submit;
		this.header.container = container;

		var that = this;
		if(this.options.publish){
			submit.click(function (e) {
				var comment = {content:that.header.text.val(),feed_id:that.feedId};

				that.options.publish(e,comment);
			});
		}
	},
	_generateContainer: function() {
		this.container = $('<ul class="none-margin"></ul>')
	},
	_generateItems: function() {
		this.itemsContainer = this.itemsContainer ||  $('<ul class="none-margin"></ul>');

		var len = this.data && this.data.length;

		for (var i = 0; i < len; i++) {
			var comment = this.data[i];
			var view = new commentView(comment);

			view.render();
			var itemContainer = $('<li></li>');
			itemContainer.append(view.html());

			this.itemsContainer.append(itemContainer);
		}
	},
	updateItems:function(comments){
		this.data = comments;
		this.itemsContainer.empty();

		this._generateItems();
	},
	render: function() {
		this._generateHeader();
		this._generateContainer();
		this._generateItems();

		var headerItem = $('<li></li>');
		headerItem.append(this.header.container);

		this.container.append(headerItem);
		this.container.append('<hr style="margin-top:35px;">');

		if (this.data) {
			var commentsItem = $('<li></li>');
			commentsItem.append(this.itemsContainer);
		}
		this.container.append(commentsItem);
	},
	clearText:function () {
		this.header.text.val('');	
	},
	html: function() {
		return this.container;
	}
};