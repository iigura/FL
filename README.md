# F/L - study for Forth-like language
--------

# はじめに
F/L は Lua で記述された Forth 系プログラミング言語です。オリジナルの Forth とは異なり、浮動小数点値や文字列、無名ワードブロックなどを値として取り扱うことができます。

# インストール方法
Github https://github.com/iigura/FL よりファイル一式をダウンロードして下さい。これらのファイルは lua で書かれた言語処理系のソースコード（拡張子 .lua）と F/L のプログラム（拡張子 .fls）から構成されています。全てテキストファイルです。

# 起動方法と終了方法
FL.lua があるディレクトリで lua FL.lua として下さい。EOF を入力（mac のターミナル等では Ctrl-D 押下）で終了します。

# 使い方
Forth における . と dup などは同様に使用できますので、 5 dup * . と入力しリターンキーを押すと 5 の 2 乗である 25 が表示されます。詳しくは「[F/L でのプログラミング](https://qiita.com/iigura/items/fe7a69e53cb8b1fd2d7a) 」をご覧ください。

# 関連文書
* （簡易な）プログラミングガイド：[F/L でのプログラミング](https://qiita.com/iigura/items/fe7a69e53cb8b1fd2d7a) 
* 辞書ごとのリファレンス：[F/L のワード一覧](https://qiita.com/iigura/items/d8413b256012c8f828bd)
* その他（雑記）：[メイキングオブ・プログラミング言語 F/L](https://qiita.com/iigura/items/756e07bafdd5dd361657)

