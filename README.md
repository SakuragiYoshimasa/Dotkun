# Dotkun

## 用語定義
Account
プレイしているユーザーの情報

Game
オンライン、オフラインすべて含めて、抽象化した「ゲーム」

~~Table
テーブルビュー

~~TableCell
テーブルビューのセル

~~Collection
コレクションビュー

~~CollectionCell
コレクションビューのセル

~~Label, ~~Button, ~~ViewController

~~List
[T]

Util
staticなfuncとか、標準クラスのextensionとか

Constants
色とか設定情報、staticなもの

Home
タブで切り替えられる画面群


## ViewController

LoginViewController → HomeTabBarController

HomeTabBarControllerが複数Viewを管理するタブ
    SelectGameViewController
        プレイするゲームを選択
    AccountViewController
        ユーザーの情報を確認できる


## 開発体制
PRベース

## 開発環境
- Swift
- cocoapods
- fabric


