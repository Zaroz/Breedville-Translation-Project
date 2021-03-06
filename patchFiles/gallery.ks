;ギャラリー

;メッセージ履歴無効
@history enabled=false output=false
;メッセージ履歴の削除
@eval exp="kag.historyLayer.clear()"
;現在のページを初期化
@eval exp="sf.gallery_page = 0" cond="sf.gallery_page === void"
;右クリック無効
@rclick call=false jump=false storage=gallery.ks enabled=false

@iscript
{
	tf.extend = [];
	for(var i = #"a"; i <= #"m"; i ++)
		tf.extend.add($i);

	function nextJump(now)
	{
		var evPat = /^(ev)(\d{3})([a-z])?$/;
		var nowPat = evPat.exec(now);
		var ex;
		switch(nowPat[1] + nowPat[2])
		{
			case "ev012": ex = ["a", "b", "d", "c", "e", "f"]; break;
			default: ex = tf.extend; break;
			case "ev013": ex = ["a", "b", "c", "e", "g", "d", "f", "h", "i"]; break;
			default: ex = tf.extend; break;
		}
		var i = nowPat[3] != void ? ex.find(nowPat[3]) + 1 : 0;
		for(; i < ex.length; i++)
		{
			var next = nowPat[1] + nowPat[2] + ex[i];
			if(sf[next]) {
				return next;
			}
		}
		return void;
	}
}
@endscript

*gallery
@lsg storage=gallery

@current layer=message0 page="&sf.effection_page"
@position visible=true

@iscript
{
	// 座標
	var x = 120, xAdd = 140;
	var y = 140, yAdd = 105;
	// 表示数
	var line = 4, row = 4, num = 20;
	var maxPage = (num + (line * row - 1)) \ (line * row);
	var offset = line * row * sf.gallery_page;
	var limit = line * row + offset;
	// 描画処理
	with(kag.tagHandlers)
	{
		// 戻るボタン
		.button(%[x:602, y:51, graphic:"button_return_e", target:"*rc", invalidDown:true]);
		// 各サムネイルボタン
		var links = kag.current.links.length;
		for(var i = offset; i < num && i < limit; i++)
		{
			var evNum = i + 1;
/*
			if(evNum == 1)
			{
				evNum = 13;
			}
*/
			var storage = "ev" + "%03d".sprintf(evNum);
			.button(%[
				x:x + (i - offset) % row * xAdd, y:y + (i - offset) \ row * yAdd,
				graphic:"gallery_thumb", target:"*load", exp:"tf.now = '" + storage + "'",
				invalidDown:true, invalidOn:true
			]);
			var btn = kag.current.links[links + i - offset].object;
			if(sf[storage])
			{
				// サムネイル
				var tmp = kag.tempLayer;
				tmp.loadImages("s_" + storage + "a");
				tmp.setSizeToImageSize();
				btn.copyRect(1, 1, tmp, 0, 0, tmp.width, tmp.height);
			} else
			{
				btn.enable = false;
			}
		}
		// 前のページへボタン
		if(sf.gallery_page > 0)
		{
			.button(%[x:35,  y:329, graphic:"button_pager_prev", target:"*gallery", exp:"sf.gallery_page--", invalidDown:true]);
		}
		// 次のページへボタン
		if(sf.gallery_page < maxPage - 1)
		{
			.button(%[x:745, y:329, graphic:"button_pager_next", target:"*gallery", exp:"sf.gallery_page++", invalidDown:true]);
		}
		// 現在のページ数の表示
		if(maxPage > 1)
		{
			kag.current.drawText(380, 110, 'PAGE' + (sf.gallery_page + 1), 0xffffff, 255, true, 2000, 0xa22954 , 2, 0, 0);
		}
	}
}
@endscript

@if exp="sf.effection"
@trans method=crossfade time="& sf.effection_time \ 2"
@wt
@endif

;右クリック
@rclick call=false jump=true target="*rc" enabled=true

@s

;表示
*load
@rclick call=false jump=false enabled=false
@uall time="& sf.effection_time \ 2"
@lbg storage="&tf.now = nextJump(tf.now)"
@rclick call=false jump=true target="*exit" enabled=true
;オートモードキャンセル
@cancelautomode
;@eval exp="kag.notifyStable()"
@eval exp="kag.inStable=true"
@waitclick
@rclick call=false jump=false enabled=false
@jump target=*load cond="nextJump(tf.now) !== void"
*exit
@rclick call=false jump=false enabled=false
@uall time="& sf.effection_time \ 2"
@jump target=*gallery

*rc
@rclick call=false jump=false enabled=false
@uall
@jump storage="extra.ks"
