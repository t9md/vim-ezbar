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

# 使ってみる
インストールするだけ。

上記のみで、他に何も設定しなければ、起動時にデフォルトの設定が使われる。
デフォルトの設定は `autoload/ezbar/config/default.vim` にある。

# カスタマイズ

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

### 特別な変数

| *Name*      | *Description*                                        |
| -------------- | -------------------------------------------------    |
| `__active `    | アクティブウィンドウかどうか？                       |
| `__mode     `  | `mode()` の返り値                                    |
| `__winnr    `  | ウィンドウ番号(`winnr()`)                            |
| `__bufnr    `  | バッファ番号(`bufnr()`)                              |
| `__width    `  | ウィンドウの幅(`winwidth()`)                         |
| `__filetype `  | ファイルタイプ(`&filetype`)                          |
| `__buftype  `  | バッファタイプ(`&buftype`)                           |
| `__parts    `  | 標準化(normalize) されたパーツが格納された辞書       |
| `__color    `  | g:ezbar.color と同じ。アクセスの利便性の為           |
| `__layout   `  | ウィンドウで使われるレイアウト(`List`)               |
| `__c        `  | 現在のセクションカラー(色の指定がない場合に使われる) |
| `__         `  | パーツ作成時に使えるヘルパー関数群を格納した辞書     |

### フック(Hook)
| *Name*      | *Description*                                        |
| -------------- | -------------------------------------------------    |
| `__init()`    | 最初に呼ばれる                       |
| `__part_missing({partname})`  | 対応するパート関数がない場合に呼ばれる |
| `__finish()`  | 最後に呼ばれる |

### g:ezbar 辞書
全ての設定はこの辞書のフィールドとして設定する。
ここにないものも(名前がかぶらない限り)勝手に作って、パート関数から参照して良い(ここはユーザーが自由にやれば良い)。

| *Name*            | *Description*                                                    |
| ----------------- | ---------------------------------------------------------------- |
| g:ezbar           | 各設定を格納する辞書                                             |
| g:ezbar.theme     | カラーテーマ名を設定                                             |
| g:ezbar.color     | パート関数から参照したい色を格納する辞書                         |
| g:ezbar.alias     | パート関数の別名を格納する辞書。レイアウト内で簡易名を使用できる |
| g:ezbar.hide_rule | ウィンドウ幅が狭い時にパートを隠すルールを指定する辞書           |
                   
### 処理の流れ

#### 前提となる知識
Vim のステータスライン(`:help 'statusline'`) は `'statusline'` 変数に文字列(又は文字列を返す関数名)を設定する事で、カスタマイズする。
このプラグインをインストールすると、ステータスラインが更新される度に、`ezbar#string()` が呼ばれる。
`ezbar#string()` は文字列を返す。その文字列が今貴方が見ているステータスラインである。

#### 詳細な流れ
1. 各ウィンドウ毎のステータスラインを評価する際、ウィンドウ毎に`ezbar#string()` が呼ばれる。
2. 使用するレイアウトを決定する。アクティブウィンドウの場合は、`g:ezbar.active` が、インアクティブウィンドウの場合は `g:ezbar.inactive` が使用される。
レイアウトが文字列の場合、`split()` を呼んで、空白文字で分割して `List` にする。
3. エイリアス(`g:ezbar.alias`)が設定されている場合、レイアウト内で使われていエイリアス(簡易名)をアンエイリアスする(簡易名をパート関数の名前に書き換える)。
4. レイアウト
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
