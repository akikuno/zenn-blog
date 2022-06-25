# Conda Forgeに登録してみた

## 3行でまとめると

- 自作PyPIパッケージをconda-forgeに登録してみました
- `grayskull`での`meta.yaml`自動生成機能が神
- パッケージ名に大文字があると小文字に変換されてしまうので注意

## はじめに

これまで自作パッケージを[PyPI](https://pypi.org/manage/projects/)や[BioConda](https://bioconda.github.io/search.html?q=akikuno)に登録したことはありましたが、conda-forgeへは経験がありませんでした。

ちょうど最近conda-forgeに提出できそうなパッケージを作ったので、試してみました。

WindowsとPOSIXのパスを変換するシンプルなPythonモジュールです。

https://github.com/akikuno/wslPath


## ガイドライン

以下の登録手順を参考にしました。

https://conda-forge.org/docs/maintainer/adding_pkgs.html


## `grayskull`のインストール

ガイドラインにしたがって`grayskull`をインストールしました。
どうやら自動で`meta.yaml`を生成してくれるツールのようです。

```python
conda create -y -n grayskull
conda install -y -n grayskull -c conda-forge grayskull
conda activate grayskull
```

## grayskullで`meta.yaml`を生成

以下のコマンドを打つと、`{パッケージ名}/meta.yaml`（今回は`wslPath/meta.yaml`）が作られます。

```python
grayskull pypi --strict-conda-forge wslPath
```

## `staged-recipes`をフォークし、meta.yamlを入れる

こちらのリポジトリをフォークします。

https://github.com/conda-forge/staged-recipes


`staged-recipes/recipes/{パッケージ名}`のディレクトリを作り、そこに先ほど生成した`meta.yaml`をコピーします。

```bash
git clone https://github.com/akikuno/staged-recipes.git
mkdir -p staged-recipes/recipes/wskPath/
cp wslPath/meta.yaml staged-recipes/recipes/wskPath/
```

そして変更をcommitします。（VScodeのGUIでやってしまったのでコマンドは割愛します。）

## Pull requestを送る

以下のフォークしたリポジトリを開くと、`This branch is 1 commit ahead of conda-forge:main.`となっています。  
`1 commit ahead`をクリックして`View pull request`を押すとPull requestを送ることができます。

そうするとフォーク先（conda-forge）のPull requestsに移行しまして、いよいよ登録作業が始まります。

https://github.com/conda-forge/staged-recipes/pull/19381

いろいろと細かい注意事項を見せられますが、  
1. Pull requestのタイトルを意味のあるものにする
2. `@conda-forge/help-python`などで特定のコミュニティにレビューを依頼する  
の2点に注意すれば大丈夫でした。

いちおうChecklistはすべて埋めました。

`@conda-forge/help-python`はどうやら自動チェックが終わった後にやるべきだったようです。

また、`@conda-forge/help-python`と`@conda-forge/staged-recipes`の両方を使っている方もいました。

[4日間、レビューがなかった場合もあるよう](https://github.com/conda-forge/staged-recipes/pull/19335#issuecomment-1159718490)なので、[`@conda-forge/help-python`と`@conda-forge/staged-recipes`の両方を使ってアナウンスする](https://github.com/conda-forge/staged-recipes/pull/19301#issuecomment-1156315688)ほうが良いのかもしれません。

## Mergeを待つ

あとはマージされるのを座して待ちます。

今回は金曜日の正午にレビューを依頼して、土曜日の深夜にマージされました。

コミュニティの迅速な対応に深謝いたします。

## 結果

conda-forgeに登録することができました。

https://anaconda.org/conda-forge/wslpath

## 注意点

本家コマンドは`wslpath`でありさすがに丸かぶりは避けたかったので`wslPath`とcamelCaseにしました。  

PyPIでは`wslPath`のままで表記されたのですが、conda-forgeでは`wslpath`と小文字となってしまいました。

**パッケージ名がすべて小文字になる**というのは注意点かと思います。


いちおう`conda install -c conda-forge wslPath`とcamelCaseにしてもインストールできました。

## おわりに

思った以上に簡単にconda-forgeに登録できました。

Biocondaのときには[パッケージについて簡単な説明を付ける必要があったりした](https://github.com/bioconda/bioconda-recipes/pull/30635)のですが、conda-forgeはとくにございませんでした。


また`grayskull`で`meta.yaml`を自動生成できるのは目からウロコでした。自動生成されたファイルについて手直しがまったく必要なかったので、登録のハードルが劇的に下がりました。別の機会にBioCondaに登録するときにも使おうと思います。

