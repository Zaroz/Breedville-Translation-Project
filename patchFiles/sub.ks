;--------------------------------------------------
; ◆ セーブモード
;--------------------------------------------------
*save
@locklink
@locksnapshot
;メッセージ履歴無効。出力も無効
@history enabled=false output=false
;右クリック無効
@rclick call=false jump=false enabled=false
;このルーチンに入ったときにだけトランジションを行う
@eval exp="tf.trans_first=true"
;現在のレイヤー数を保存してレイヤーを追加
@eval exp="tf.layer_count=kag.fore.layers.count"
@eval exp="tf.message_count=kag.fore.messages.count"
@laycount layers=&tf.layer_count+2 messages=&tf.message_count+1
;裏画面にコピー
@backlay
;メッセージレイヤー非表示化
@eval exp="hideMessages(sf.effection_page)"
;背景画像の読み込み
@lsg storage=save
;サムネイルページ設定
@eval exp="tf.effection_page_this = sf.effection_page"

*savemenu
@eval exp="tf.effection_page_this = 'back'" cond="tf.trans_pager !== void && sf.effection"
@current layer="&'message' + tf.message_count" page=&tf.effection_page_this
@position visible=true
@eval exp="drawSaveLoad('save')"

;画面移行時のトランジション
@if exp="tf.trans_first && sf.effection"
@trans method=crossfade time=500
@wt
@endif
;ページャーのトランジション
@if exp="tf.trans_pager !== void && sf.effection"
@trans method="scroll" stay="stayfore" time=500 cond="tf.trans_pager=='prev'"
@trans method="scroll" stay="stayback" time=500 cond="tf.trans_pager=='next'"
@wt
@endif
;サブルーチン内右クリック
@rclick call=false jump=true storage="sub.ks" target="*ret" enabled=true
;フラグ設定
@eval exp="tf.trans_pager = void"
@eval exp="tf.trans_first = false"
@eval exp="tf.effection_page_this = 'fore'"

@s

*saveaction
@eval exp="tf.result = kag.saveBookMarkWithAsk(tf.save_num)"
;最後に保存したセーブNoを保存
@eval exp="sf.save_last_data = tf.save_num" cond="tf.result"
@jump target=*savemenu

;--------------------------------------------------
; ◆ ロードモード
;--------------------------------------------------
*load
@locklink
@locksnapshot cond="!f.ftitle"
;メッセージ履歴無効。出力も無効
@history enabled=false output=false
;右クリック無効
@rclick call=false jump=false enabled=false
;このルーチンに入ったときにだけトランジションを行う
@eval exp="tf.trans_first=true"
;現在のレイヤー数を保存してレイヤーを追加
@eval exp="tf.layer_count=kag.fore.layers.count"
@eval exp="tf.message_count=kag.fore.messages.count"
@laycount layers=&tf.layer_count+2 messages=&tf.message_count+1
;裏画面にコピー
@backlay
;メッセージレイヤー非表示化
@eval exp="hideMessages(sf.effection_page)"
;背景画像の読み込み
@lsg storage=load
;サムネイルページ設定
@eval exp="tf.effection_page_this = sf.effection_page"


*loadmenu
@eval exp="tf.effection_page_this = 'back'" cond="tf.trans_pager !== void && sf.effection"
@current layer="&'message' + tf.message_count" page=&tf.effection_page_this
@position visible=true
@eval exp="drawSaveLoad('load')"

;画面移行時のトランジション
@if exp="tf.trans_first && sf.effection"
@trans method="crossfade" time="500"
@wt
@endif
;ページャーのトランジション
@if exp="tf.trans_pager != void && sf.effection"
@trans method="scroll" stay="stayfore" time="500" cond="tf.trans_pager=='prev'"
@trans method="scroll" stay="stayback" time="500" cond="tf.trans_pager=='next'"
@wt
@endif
;サブルーチン内右クリック
@rclick call=false jump=true storage="sub.ks" target="*ret" enabled=true
@rclick call=false jump=true storage="sub.ks" target="*ret_title" enabled=true cond="f.ftitle"
;フラグ設定
@eval exp="tf.trans_pager = void"
@eval exp="tf.trans_first = false"
@eval exp="tf.effection_page_this = 'fore'"

@s

*loadaction
@load place="&tf.save_num" ask="true"
@jump target="*loadmenu"

;--------------------------------------------------
; ◆ 環境設定モード
;--------------------------------------------------
*option
@locklink
@locksnapshot cond="!f.ftitle"
;メッセージ履歴無効。出力も無効
@history enabled=false output=false
;右クリック無効
@rclick call=false jump=false enabled=false
;このルーチンに入ったときにだけトランジションを行う
@eval exp="tf.trans_first=true"
;現在のレイヤー数を保存してレイヤーを追加
@eval exp="tf.layer_count=kag.fore.layers.count"
@eval exp="tf.message_count=kag.fore.messages.count"
@laycount layers=&tf.layer_count+2 messages=&tf.message_count+1
;裏画面にコピー
@backlay
;メッセージレイヤー非表示化
@eval exp="hideMessages(sf.effection_page)"
;背景画像の読み込み
@lsg storage=option
;サムネイルページ設定
@eval exp="tf.effection_page_this = sf.effection_page"

*optionmenu
@current layer="&'message' + tf.message_count" page=&tf.effection_page_this
@position visible=true
@btn x=602 y=9 graphic="button_return_t" target="*ret_title" cond="!tf.scene_mode"
@btn x=602 y=9 graphic="button_return_s" target="*ret_title" cond="tf.scene_mode"
@btn x=602 y=51 graphic="button_return_g" target="*ret" cond="!f.ftitle"

@iscript
{
	sf.tempVolumes = [] if sf.tempVolumes === void;
	with(kag.tagHandlers) {
		var width=44;
		var x = 469, y = 115, addY = 100;
		var n = 100000 \ 5;
		var vols = [kag.scflags.se[0], kag.scflags.se[1], kag.scflags.bgm];
		var imgOn = "button_on", imgOff = "button_off", imgVol = "button_vol";
		var target = "*optionmenu";
		for(var i = 0; i < vols.count; i++) {
			var opt = i == 2 ? "bgmopt(%[" : "seopt(%[buf:" + i + ", ";
			for(var j = 0; j < 5 ; j++){
				// volumeボタン
				.button(%[
					x:j * width + x, y:i * addY + y, graphic:imgVol + (j + 1), target:target,
					invalidDown:true, invalidOn:true, flag:vols[i].globalVolume >= (j + 1) * n,
					exp:"kag.tagHandlers." + opt + "gvolume:" + (j + 1) * (n \ 1000) + "]);"
				]);
			}
			// onボタン
			.button(%[
				x:207, y:i * addY + y + 35, graphic:imgOn, target:target,
				invalidDown:true, invalidOn:true, flag:vols[i].globalVolume > 0,
				exp:"if (" + (vols[i].globalVolume == 0) + ") {"
					+ "kag.tagHandlers." + opt + "gvolume:sf.tempVolumes[" + i + "]]); "
					+ "}"
			]);
			// offボタン
			.button(%[
				x:283, y:i * addY + y + 35, graphic:imgOff, target:target,
				invalidDown:true, invalidOn:true, flag:vols[i].globalVolume == 0,
				exp:"if (" + (vols[i].globalVolume > 0) + ") { "
					+ "sf.tempVolumes[" + i + "] = " + vols[i].globalVolume \ 1000 + "; "
					+ "kag.tagHandlers." + opt + "gvolume:0]); "
					+ (i == 0 ? "sf.voiceMessageVisible = false;" : "")
					+ "}"
			]);
		}
		// 画面効果
		.button(%[
			x:207, y:452, graphic:imgOn, target:target,
			invalidDown:true, invalidOn:true, flag:sf.effection,
			exp:"sf.effection = true; sf.effection_page = 'back'"
		]);
		.button(%[
			x:283, y:452, graphic:imgOff, target:target,
			invalidDown:true, invalidOn:true, flag:!sf.effection,
			exp:"sf.effection = false; sf.effection_page = 'fore'"
		]);
		// ボイス再生中ウィンドウ
		.image(%[
			left:377, top:410, layer:(string)(tf.layer_count + 1), page:tf.effection_page_this, visible:true,
			storage:"option_visible", opacity:kag.scflags.se[0].globalVolume == 0 ? 125 : 255
		]);
		if(sf.voiceMessageVisible === void)
			sf.voiceMessageVisible = false;
		if(kag.scflags.se[0].globalVolume > 0) {
			.button(%[
				x:468, y:450, graphic:imgOn, target:target,
				invalidDown:true, invalidOn:true, flag:sf.voiceMessageVisible,
				exp:"sf.voiceMessageVisible = true"
			]);
			.button(%[
				x:544, y:450, graphic:imgOff, target:target,
				invalidDown:true, invalidOn:true, flag:!sf.voiceMessageVisible,
				exp:"sf.voiceMessageVisible = false"
			]);
		}
		.slider(%[
			x:232, y:536, width:234, height:27,
			min:51, max:255, graphic:"toumeido_Dial",
			position:+sf.msg_opacity, target:"sf.msg_opacity"
		]);
		// カットイン
		.button(%[
			x:420, y:70, graphic:imgOn, target:target,
			invalidDown:true, invalidOn:true, flag:sf.cutin,
			exp:"sf.cutin = true; if(f.viewcutin) { kag.tagHandlers.image(%[layer:'0', storage:f.viewcutin.storage, left:f.viewcutin.left, top:f.viewcutin.top, visible:true]); kag.tagHandlers.backlay(%[layer:'0']); }"
		]);
		.button(%[
			x:496, y:70, graphic:imgOff, target:target,
			invalidDown:true, invalidOn:true, flag:!sf.cutin,
			exp:"sf.cutin = false; if(f.viewcutin) { kag.fore.layers[0].visible = false; kag.tagHandlers.backlay(%[layer:'0']); }"
		]);
	}
}
@endscript

;画面移行時のトランジション
@if exp="tf.trans_first && sf.effection"
@trans method=crossfade time=500
@wt
@endif
;サブルーチン内右クリック
@rclick call=false jump=true storage="sub.ks" target="*ret" enabled=true
@rclick call=false jump=true storage="sub.ks" target="*ret_title" enabled=true cond="f.ftitle"
;フラグ設定
@eval exp="tf.trans_first=false"
@eval exp="tf.effection_page_this='fore'"

@s

*history
; ◆ メッセージ履歴
@showhistory
@return

*hide
; ◆ 文字消去
@hidemessage
@wait time=200
@return

*ret
; サブルーチンから戻る

;右クリック無効化
@rclick call=false jump=false enabled=false

@if exp="sf.effection"
@freeimage layer=&tf.layer_count page=back
@freeimage layer=&tf.layer_count+1 page=back
@eval exp="showMessages(sf.effection_page)"
@layopt layer="&'message' + tf.message_count" visible=false page=back
@trans method=crossfade time=500
@wt
@endif

@if exp="!sf.effection"
@eval exp="showMessages(sf.effection_page)"
@layopt layer="&'message' + tf.message_count" visible=false
@endif

;右クリック有効(メッセージ消去)
@rclick call=false jump=false enabled=true
;レイヤー数を元にもどす
@laycount layers=&tf.layer_count messages=&tf.message_count
;メッセージレイヤーを表示
;メッセージ履歴有効
@history enabled=true output=true
;スナップショット有効
@unlocksnapshot cond="!f.ftitle"
;マウスカーソルステータスを初期化
@eval exp="kag.mouseCursorState=0"
@return

*ret_title
;タイトルから来ている場合
@if exp="f.ftitle"
@eval exp="f.ftitle=false"

@uall

@laycount layers=&tf.layer_count messages=&tf.message_count
@jump storage="title.ks" target="*title_menu"

@endif


;ゲーム中の場合
;シーンモードでない場合
@gotostart ask=true cond="!tf.scene_mode"
;シーンモードの場合
@if exp="tf.scene_mode"
@eval exp="tf.result = askYesNo('Are you sure you want to return to the scene recollection selection screen?')"
@return storage="scenemode.ks" target="*return" cond="tf.result"
@endif

@unlocklink

@s

*title_sub
;シーンモードでない場合
@gotostart ask=true cond="!tf.scene_mode"
;シーンモードの場合
@if exp="tf.scene_mode"
@eval exp="tf.result = askYesNo('Are you sure you want to return to the scene recollection selection screen?')"
@return storage="scenemode.ks" target="*return" cond="tf.result"
@endif

@return