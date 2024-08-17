---
title: "GEOにFASTQファイルを登録したときの備忘録"
emoji: "🧬"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["バイオインフォマティクス", "Tech"]
published: false
---

# はじめに

[Gene Expression Omnibus (GEO)](https://www.ncbi.nlm.nih.gov/geo/) にRNA-seqデータを投稿したので、その備忘録です。

# Gene Expression Omnibus (GEO) ってなんですか？

機能ゲノミクスのデータ (RNA-seq, ChIP-seq, HiCなど) を格納するリポジトリです。


:::message
生のシークエンスデータは[Sequence Read Archive (SRA)](https://www.ncbi.nlm.nih.gov/sra) に投稿します。
:::

# 情報源

- 作業マニュアル ([Submitting high-throughput sequence data to GEO](https://www.ncbi.nlm.nih.gov/geo/info/seq.html))


# 今回のケース

投稿するデータはマウス胚をRNA-seqにかけて得られたFASTQファイルです。  

## 0. ログイン

- [Submission Protal](https://submit.ncbi.nlm.nih.gov/subs/sra/)からログインします。
- Google Accountでも認証できるので便利です。

## 1. FASTQのアップロード

:::message
FASTQはすべて**gzipに圧縮**して、**単一のフォルダ**に格納します。
- gzip圧縮すると転送が速く済みます。
- 単一のフォルダに格納すると転送するコマンドが簡単になります。
:::

- 重たいファイル(>10GB)や数が多いファイル(>300)については、まずNCBIのサーバーにデータをアップロードすること（`preload option`）が推奨されています。
- 今回は100つくらいのファイルで、まあまあの数だったので`preload`を選択しました。
- `preload`の方法にもいろいろあるようですが、今回は使用経験のある`FTP upload`にしました。
	- [IBM Aspera Connect](https://www.ibm.com/aspera/connect/)を使うと高速に転送できるみたいです。
- `ncftp`コマンドの使い方は[こちら](http://genomespot.blogspot.com/2021/09/uploading-data-to-geo-which-method-is.html)を参考にしました。
- ファイル数や重さによりますが、数時間程度かかります。

```bash:ftp-upload.sh
ncftp
## おまじない
set passive on
set so-bufsize 33554432

## "FTP upload"のタブをクリックすると「パスワード」と「フォルダ名」が現れます。
open ftp://subftp:<パスワード>@ftp-private.ncbi.nlm.nih.gov
cd uploads/<フォルダ名>
mkdir -p <ユニークなフォルダ名>
cd <ユニークなフォルダ名>
put -R <FASTQが格納されているフォルダのパス>
```
![](https://storage.googleapis.com/zenn-user-upload/52affa6965e5-20220829.png)

## 2. GENERAL INFO

- 「BioProjectにすでに登録してあるサンプルですか？」と聞かれます。
  - 今回は新規のデータなので`No`と答えます。  
- 「BioSampleにすでに登録してあるサンプルですか？」と聞かれます。
  - 今回は新規のデータなので`No`と答えます。  
- Release dateは`Release on specified date or upon publication, whichever is first`を選択しました。  
  - 最大で4年後まで公開を先延ばしにできます。  

## 3. PROJECT INFO

- `Project title`と`Public description`を記載します。
  - 論文タイトルとアブストラクトをコピペすればOKだと思います。
  - 正式なタイトルやアブストラクトが決まっていなくても後日修正できるので、とりあえず一文を埋めます。

## 4. BIOSAMPLE TYPE

- サンプルの情報を入れるにあたって適切なテンプレートを選びます。
- 今回は「mus musculus」と検索したら出てきた`Model organism or animal`を選びました。

## 5. BIOSAMPLE ATTRIBUTES

- エクセルファイルをダウンロードして、情報を加筆します。  
- ペアエンドのサンプルはひとつのサンプルとして情報をまとめます。
	- ペアエンドの情報は次の`SRA METADATA`に記載します。

- 以下、遭遇したエラーとその対応です。

:::message alert
**Error: Multiple BioSamples cannot have identical attributes**への対処法
- sample_nameをユニークな名前にしてもダメでした。
- [こちらのやりとり](https://www.echemi.com/community/when-sra-data-uploads-biosample-error-appears-during-the-attributes-stage_mjart2208181049_42.html)を参考にし、**エクセルの適当なコラムに`source_material_id`を加えて、連番とした**ところ解決しました。
:::
![](https://storage.googleapis.com/zenn-user-upload/59c4d7e00b9a-20220829.png)

## 6. SRA METADATA

- エクセルファイルをダウンロードして、情報を加筆します。

![](https://storage.googleapis.com/zenn-user-upload/a983b0e7876a-20220829.png)

## 7. FILES

- 事前にアップロードしているので、フォルダ名を選択して`Continue`をします。

## 8. REVIEW ＆ SUBMIT

:::message
「確認・修正をお願いします」と聞かれますが、無視して投稿を終えましょう
:::
- 例えば、ここで「2 GENERAL INFO」を修正するとその後の3-7まですべて`Continue`を押さないとこのページに戻ってこれません。面倒です。
- 投稿したら各項目を独立に修正できるので、とても簡単です。

# 投稿後

## レビューワーアクセストークンの発行

- [Submission PortalのMy submissions](https://submit.ncbi.nlm.nih.gov/subs/)に移動します。  
- 投稿が終わっていれば`Status`の右上に`Manage data`というボタンが現れるので、それをクリックします。  
- Manage Data ＞BioProject: XXXの右横に`Reviewer link`ボタンがあるので、それをクリックすることでレビューワー用のURLが発行されます。  

![](https://storage.googleapis.com/zenn-user-upload/f0d554554fb4-20220829.png)

## BioSampleの更新

:::message
BioSampleの修正だけはメールで行わなければなりません。
:::

- 修正したエクセルファイルを添付して、以下のようなメールをbiosamplehelp[at]ncbi.nlm.nih.govに送りました。
- 1日で返信が来まして、3日以内に修正していただけました。

```
title: Update BioSample information

Dear BioSample staff,

We have recently uploaded our sequence data in SRA (PRJNA<番号>).
I am afraid that we would like to update the biosample information as
shown in the attached excel file.
We would be very grateful if you could help us.

Sincerely,
```

# （おまけ）DRAとの比較

- SRAに対応する日本のデータベースとして[DRA (DDBJ Sequence Read Archive)](https://www.ddbj.nig.ac.jp/dra/index-e.html)があります。  
- [以前(2021年5月)DARに投稿したとき](https://ddbj.nig.ac.jp/resource/sra-submission/DRA011971)との、SRAとの比較になります。個人的な感想です。
- 個人的にはSRAのほうが投稿画面がサクサク動いて快適なので、次回以降もSRAで投稿しようと思います。

| 項目                       | SRA | DRA | メモ                                                                                                                                                |
| -------------------------- | --- | --- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| 簡便さ                     | ○   | ◎   | 両方とも簡単でした😀とくにDRAは日本語の情報があるのでより簡単に感じるかもしれません。                                                                |
| 快適さ                     | ◎   | x   | SRAはサクサク動いてとても快適でした。一方、**DRAはページを遷移するだけで30秒くらいかかってかなりストレスでした。** いまは改善していることを切に願っています🙏 |
| 質問               | ○   | ◎   | SRAもDRAもメールで質問をすると迅速にご回答をいただけました。とくにDRAは日本語で質問できるのでありがたいです。                            |
| 投稿後のデータへのアクセス | x   | x   | どちらも目的のFASTQファイルがどこにあるのか分かりづらいです😵‍💫                                                                                              |

