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

### パート関数内で使用可能な特別な変数

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

| *Name*                     | *Description*                                                    |
| -------------------------- | ---------------------------------------------------------------- |
| g:ezbar                    | 各設定を格納する辞書                                             |
| g:ezbar.theme              | カラーテーマ名を設定                                             |
| g:ezbar.parts              | レイアウトの各要素に対応するパート関数群が格納される辞書。       |
| g:ezbar.active             | アクティブウィンドウで使用されるレイアウト(文字列 or リスト)     |
| g:ezbar.inactive           | インアクティブウィンドウで使用されるレイアウト(文字列 or リスト) |
| g:ezbar.color              | パート関数から参照したい色を格納する辞書                         |
| g:ezbar.alias              | パート関数の別名を格納する辞書。レイアウト内で別名を使用できる   |
| g:ezbar.hide_rule          | ウィンドウ幅が狭い時にパートを隠すルールを指定する辞書           |
| g:ezbar.separator_L        | 次(隣)のパートの背景色が同じ場合に使われる                       |
| g:ezbar.separator_R        | 次(隣)のパートの背景色が同じ場合に使われる                       |
| g:ezbar.separator_border_L | 次(隣)のパートの背景色が異なる場合に使われる                     |
| g:ezbar.separator_border_R | 次(隣)のパートの背景色が異なる場合に使われる                     |
                   
### 処理の流れ

#### 前提となる知識
Vim のステータスライン(`:help 'statusline'`) は `'statusline'` 変数に文字列(又は文字列を返す関数名)を設定する事で、カスタマイズする。  
このプラグインをインストールすると、ステータスラインが更新される度に、`ezbar#string()` が呼ばれる。  
`ezbar#string()` は文字列を返す。その文字列が今あなたが見ているステータスラインである。  

#### 詳細な流れ
1. 各ウィンドウ毎のステータスラインを評価する際、ウィンドウ毎に`ezbar#string()` が呼ばれる。
2. 使用するレイアウトを決定する。アクティブウィンドウの場合は、`g:ezbar.active` が、インアクティブウィンドウの場合は `g:ezbar.inactive` が使用される。
レイアウトが文字列の場合、`split()` を呼んで、空白文字で分割して `List` にする。
3. エイリアス(`g:ezbar.alias`)が設定されている場合、レイアウト内で使われていエイリアス(別名)をアンエイリアスする(別名をパート関数の名前に書き換える)。
4. フック(`__init()`) が呼ばれる。
5. `__init()` フック内で、レイアウトが変更された場合、再度レイアウトのリスト化、アンエイリアスを行う。
6. レイアウトリストの各要素に対応するパート関数を呼ぶ。対応するパート関数が見つからない場合 `__part_missing({partname})` を呼ぶ。
パート関数の返り値を標準化する(normalize)。標準化とは、パート関数の返り値が文字列であれば、辞書化し、辞書に対して、必要な属性(セクションカラー等)を設定する。
7. 's' フィールドが空のパートを削除する。
8. フック(`__finish()`) が呼ばれる。
9. 各パートにセパレータ(左右セパレータではない)を挿入し、文字列化して返す(これが`ezbar#string()`の返り値)

### 実例
#### セクションのカラーの指定
レイアウト内で使用する文字列は基本的に g:parts 内のパート関数に対応するが以下の例外がある。
* セクションカラーの指定
以下は全てセクションカラーの指定とみなされる。`-` は一文字以上であれば何文字でも良い。
`|{color_name}` 
`-{color_name}` 
`--{color_name}` 

* 左右を分けるセパレータの指定
一文字以上の `=` は左右を分けるセパレータになる。
`=`, `==`, `===` も全て同じ意味。
`={colorname}` の様にセクションカラーを同時に指定することも可能

#### パート関数を作って使う

`g:ezbar.parts` に辞書関数を登録し、その関数をレイアウトの中で使えば良い。
```Vim
let g:ezbar = {}
let g:ezbar.active = ['readonly']
let g:ezbar.parts = {}
function! g:ezbar.parts.readonly() "{{{1
  return getwinvar(self.__winnr, '&readonly') ? g:ezbar.sym.lock : ''
endfunction
```

複数のパート関数を作成する場合、以下の様にした方が煩雑でない。
```Vim
let g:ezbar = {}
let g:ezbar.active = ['readonly']
let g:ezbar.inactive = ['readonly']

let s:u = {}
function! s:u.readonly() "{{{1
  return getwinvar(self.__winnr, '&readonly') ? g:ezbar.sym.lock : ''
endfunction
let g:ezbar.parts = s:u
unlet s:u
```
パート関数は、文字列か、辞書を返さなければならない。
文字列を返した場合、空の文字列でなければ、そのままパートの値として表示される。
辞書の場合は以下の様に、`s` フィールドに文字列を設定して返す。
`{ 's': {string} }`
辞書を返す場合は、色の指定も可能。
`{ 's': {string}, 'ic': {color_inactive}, 'ac': {color_active}, 'c': 'color' }`
色は全てオプション。
色は以下の順位で参照される
1. パート辞書の `ic`(インアクティブウインドウ時), `ac`(アクティブウィンドウ時)
2. パート辞書の `c`
3. セクションカラー

#### パーツ集を使う

パーツ集は '&rtp/autoload/ezbar/parts/{parts_name}.vim' から検索される。
標準で `default.vim` が提供されている。
パーツ集のパーツを取得するには、バーツ集の名前と、使用するパートを指定して `ezbar#part#use()` を呼び出す。
この関数は指定したパート集から、選択したパート郡のみを含んだ辞書を返すので、これを `g:ezbar.parts` に設定すれば良い。

let s:u = ezbar#parts#use('default', {'parts': s:features })
```Vim
let s:features = [
      \ 'mode',
      \ 'readonly',
      \ 'filename',
      \ 'modified',
      \ 'filetype',
      \ 'win_buf',
      \ 'encoding',
      \ 'percent',
      \ 'line_col'
      \ ]
let s:u = ezbar#parts#use('default', {'parts': s:features })
unlet s:features
let g:ezbar.parts = s:u
```
#### エイリアスを使う
レイアウトはリストでも、文字列でも指定できる。
エイリアスを使って、文字列でレイアウトを表現すれば、より簡潔にレイアウトを指定出来る。
以下のレイアウトをエイリアスを使用して書きなおしてみる。

* 書き換え前
```Vim
let g:ezbar.active = [
      \ '----------- 1',
      \ 'mode',
      \ '----------- 2',
      \ 'win_buf',
      \ '----------- 3',
      \ 'cwd',
      \ '===========',
      \ 'readonly',
      \ '----------- 2',
      \ 'filename',
      \ 'filetype',
      \ '----------- 1',
      \ 'modified',
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ ]
let g:ezbar.inactive = [
      \ '----------- inactive',
      \ 'win_buf',
      \ 'modified',
      \ '==========',
      \ 'filename',
      \ 'filetype',
      \ 'encoding',
      \ 'line_col',
      \ ]
```

* 書き換え後(エイリアスを使用)
```Vim
let g:ezbar.alias = {
      \ 'm':   'mode',
      \ 'wb':  'win_buf',
      \ 'ro':  'readonly',
      \ 'mod': 'modified',
      \ 'fn':  'filename',
      \ 'ft':  'filetype',
      \ '%':   'percent',
      \ 'enc': 'encoding',
      \ 'lc':  'line_col',
      \ '|i':  '|inactive',
      \ }
let g:ezbar.active = '|1 m |2 wb |3 cwd = ro |2 fn ft |1 mod enc % lc'
let g:ezbar.inactive = '|i wb mod = fn ft enc lc'
```

#### ウィンドウ幅によって表示するパーツを隠す
各パート関数内で、`__width` を使用して、ウィンドウ幅を判断し、表示したくない場合は空の文字列を返せば、そのパートは表示されない。
しかし、このような処理をパート関数毎に実装するとパート関数の汎用性が無くなるし、煩雑である。

`g:ezbar.hide_rule` 辞書とヘルパー関数`__.hide()`を使用すれば簡潔に設定できる
```Vim
" window 幅が90より狭い場合、'cwd' パートを隠す。65 より小さい場合 'fugitive'
" を隠す。以下同様
let g:ezbar.hide_rule = {
      \ 90: ['cwd'],
      \ 65: ['fugitive'],
      \ 60: ['encoding', 'filetype'],
      \ 50: ['percent'],
      \ 35: ['mode', 'readonly', 'cwd'],
      \ }
" 実際に隠すには、__init() フックの中で、__.hide() を呼ぶ必要がある。
" __.hide() " にはオプション引数としてListを渡せる。ウィンドウ幅とは別の条件で隠したい
" パートがあれば、オプション引数で渡せば良い
function! s:u.__init() "{{{1
  let hide = []
  " choosewin が有効な場合、validate パート(行末スペースの検出)を隠す
  if get(g:, 'choosewin_active', 0)
    let hide += ['validate']
  endif
  call self.__.hide(hide)
endfunction
```

#### 色を変更する
#### カラーテーマを作る

#### 実例:
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
