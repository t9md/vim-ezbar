# What's this？
先進的な、カスタマイズが容易な、ミニマリスト向けの statuline プラグイン

# 特徴
* シンプルなデザイン。Vim scripter にとって設定しやすい。
* 条件によって動的に色を変えたり、ステータスラインのレイアウト自体を変えられる。
* 全てのステータスラインの部品(part)は、辞書関数として実装される。
* ユーザー関数よりも優先される定義済みの関数はほぼ無く、全てはユーザーの設定次第。

# 画像
* モードによって色が変わる
![Mode](https://raw.github.com/t9md/t9md/master/img/ezbar/mode_insert.png)

* ファイル名が XXX の時に色を変える( この例では `tryit` から始まるファイル )
![Filename](https://raw.github.com/t9md/t9md/master/img/ezbar/filename_notify.png)

* Gitブランチが master でない場合に色を変える。  
![Git-1](https://raw.github.com/t9md/t9md/master/img/ezbar/git-branch_notify.png)

* 特定のプラグインのモードが発動した場合にステータスラインの他の部品を隠す(easymotion 等で使う。)  
![Fill-1](https://raw.github.com/t9md/t9md/master/img/ezbar/ezbar_fill1.png)  
![Fill-2](https://raw.github.com/t9md/t9md/master/img/ezbar/ezbar_fill2.png)  

# クイックスタート
```Vim
let g:ezbar_enable   = 1
```

上記のみで、他に何も設定しなければ、起動時にデフォルトの設定が使われる。
デフォルトの設定は `autoload/ezbar/config/default.vim` にある。

## カスタマイズ

`autoload/ezbar/config/default.vim` を自分の設定フォルダにコピーして、`.vimrc` から `:source` する。

```Vim
" 簡単に編集出来るようにする。<Space>e で編集
nnoremap <Space>e  :<C-u>edit $EZBAR_CONFIG<CR>
let g:ezbar_enable   = 1
let $EZBAR_CONFIG = expand("~/ezbar_config.vim")
if filereadable($EZBAR_CONFIG)
  source $EZBAR_CONFIG
endif
```

## カスタマイズに使える仕組み

* 特別な変数: `__c`, `__color` , `__filetype` etc.
* Hook: `_init()`, `_finish()`, `_parts_missing()` etc.
* カラーテーブル: g:ezbar.color に保存して使う。
* ヘルパー関数: 主に色を操作する系の関数群

* 実例:
作者の設定が `autoload/ezbar/config/t9md.vim` にある。

* Help
See `:help ezbar`

## 色設定時のTIPS

1. `:EzBarColorCapture Constant` 等でハイライトをキャプチャ`Constant`の部分は好きな色。  
2. バッファに `p` で貼付け。作者の環境では以下のようになった。  

```Vim
{'gui': ['', '#e5786d'], 'cterm': ['', '13']}
```

3. 色の値を変更後に色をチェックする場合は、色設定の行を選択して `:EzbarColorCheck` する。  
