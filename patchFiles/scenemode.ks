;回想モード
*scenemode
;BGM再生
@BGM_FI storage="bgm001"
;メッセージ履歴無効
@history enabled=false output=false
;メッセージ履歴の削除
@eval exp="kag.historyLayer.clear()"
;現在のページを初期化
@eval exp="tf.scenemode_page_num=0" cond="tf.scenemode_page_num===void"
*loadimage
;背景読込
@lsg storage=scene
;右クリック
@rclick call=false jump=false storage=scenemode.ks enabled=false

@current layer=message0 page="&sf.effection_page"
@cm
@position left=0 top=0 marginl=0 margint=0 marginr=0 width=&kag.innerWidth height=&kag.innerHeight frame="" visible=true
@layopt layer=message0 page="&sf.effection_page" opacity=255
@btn x=602 y=51 graphic="button_return_e" target="*rc"

@nowait
@font size="19"

@iscript
{
	// フォント設定
	with(kag[sf.effection_page].messages[0])
	{
		.edge=true;
		.edgeColor=0xa22954;
		.edgeExtent=2;
		.edgeEmphasis=4096;
	}
	// x初期値と加算数
	var sceneX = 80, sceneXAdd = 340;
	// y初期値と加算数
	var sceneY = 200, sceneYAdd = 75;
	// 各回想タイトル
	var recollects = [
		"癒しの聖女を騙して破瓜堕落レイプ", "魔弾姫を彼氏の前で堕落レイプ", "氷刃を昏睡させて破瓜堕落レイプ", "盾の女神をドロネバ破瓜堕落レイプ", "魔弾姫＆氷刃のＷフェラ奉仕",
		"淫乱聖女のご奉仕肉便器Ｈ", "変態魔弾姫と全裸露出見せつけＨ", "淫蕩盾の女神のパイズリフェラ奉仕", "淫猥氷刃と分身魔法で乱交Ｈ", "魔王をお仕置き破瓜堕落レイプ",
		"魔王のケツ舐め手コキ奉仕", "全員まとめて危険日孕ませ乱交Ｈ", "勇者の前で寝取りＷパイズリ奉仕", "腹ボテ盾の女神と精液風呂Ｈ", "ボテ腹魔弾姫の応援ダンスＨ",
		"妊婦な氷刃と街中で甘イチャ露出Ｈ", "孕み性女の淫乱告白インタビューＨ", "妊娠魔王を配下の前で調教お披露目Ｈ", "臨月肉便器妻５人とハーレム乱交"
	];
	// 表示数
	var line = 2, row = 5;
	var pageNum = line * row;
	tf.scenemode_page_num_max = recollects.count \ (pageNum) + (recollects.count % (pageNum) != 0);
	var offset = pageNum * tf.scenemode_page_num;
	var limit = pageNum + offset;
	// 描画処理
	with(kag.tagHandlers)
	{
		for(var i = offset; i < recollects.count && i < limit; i++)
		{
			.locate(%[
				x:sceneX + (i - offset) \ row * sceneXAdd,
				y:sceneY + (i - offset) % row * sceneYAdd
			]);
			if(sf['recollection' + (i + 1)])
			{
				.link(%[target:"*jump", exp:"tf.storage='scenario.ks', tf.target='*recollection" + (i + 1) + "'"]);
				.ch(%[text:recollects[i]]);
				.endlink();
			}
		}
		// 前のページへボタン
		if(tf.scenemode_page_num > 0)
		{
			.button(%[x:35,  y:329, graphic:"button_pager_prev", target:"*loadimage", exp:"tf.scenemode_page_num--", invalidDown:true]);
		}
		// 次のページへボタン
		if(tf.scenemode_page_num < tf.scenemode_page_num_max - 1)
		{
			.button(%[x:745, y:329, graphic:"button_pager_next", target:"*loadimage", exp:"tf.scenemode_page_num++", invalidDown:true]);
		}
	}
	// 現在のページ数の表示
	if(tf.scenemode_page_num_max > 1)
	{
		with(kag[sf.effection_page].base) {
			.fontSize = 15;
			.drawText(380, 140, "PAGE" + (tf.scenemode_page_num + 1), 0xffffff);
		}
	}
}
@endscript

@font size=default

@if exp="sf.effection"
@trans method=crossfade time=500
@wt
@endif

;右クリック
@rclick call=false jump=true target="*rc" enabled=true

@s

;回想へジャンプ
*jump
;栞を無効
@store enabled=false

@uall
@BGM_FO

;タイトルフラグをオフに
@eval exp="f.ftitle = false"
;右クリック設定サブルーチン呼び出し
@rclick call=false jump=false enabled=true
;メッセージ履歴有効
@history enabled=true output=true
;メッセージレイヤー設定
@current layer=message0
@M_SET
@backlay

;@layopt layer=message0 page=back visible=true
;@layopt layer=message1 page=back visible=true
@M_FI
@eval exp="tf.scene_mode=true"
@jump storage=&tf.storage target=&tf.target

;回想から戻る
*return
@MPGSTOP cond="kag.movies[0].lastStatus!='unload'"
@videolayer channel=1 page=fore layer=base
@videolayer channel=2 page=back layer=base
@video loop=true visible=true mode="layer" width=800 height=600
;右クリック無効
@rclick call=false jump=false enabled=false
@uall
@BGM_FO
@eval exp="tf.scene_mode=false"
;タイトルフラグをオンに
@eval exp="f.ftitle = true"
;オートモードキャンセル
@cancelautomode
;カットインフラグを下ろす
@eval exp="f.viewcutin=void"
@jump target="*scenemode"

;おまけ選択画面に戻る
*rc
;リンクをロック
@locklink
;右クリック無効
@rclick call=false jump=false enabled=false
@uall
@jump storage="extra.ks"
