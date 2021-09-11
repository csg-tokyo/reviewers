# 論文誌査読管理システム Reviewers

## サイト固有設定

* ` config/initializers/contact_addr.rb`

必要に応じて上記のファイルを作成する。ファイルの内容は以下のようにする。

```
module ContactInfo
  # サイトの URL
  def self.site_url
    'https://www.foo.com/'
  end

  # 編集委員会のメールアドレス
  # 著者への通知文の Cc: 欄にこのメールアドレスが現れる
  def self.editor_email
    'editor@foo.com'
  end

  # 著者への通知文の署名
  def self.chiefs_signature
    <<EOT
      <p>某組織 編集委員長<br/>
        某氏</p>

        <p>〒xxx-xxxx 某所<br/>
        某組織<br/>
        E-mail: someone@foo.com</p>
EOT
  end
end

```

ファイルを作成しないとデフォルト値が用いられる。

また画面のヘッダとフッタを修正するには `app/views/layouts/_header.html.erb` と
`app/views/layouts/_footer.html.erb` を修正する。

## データベース初期化

```
sudo -u postgres createuser -s -P jssst
DB_PASS=‘<pass>' bundle exec rake db:create RAILS_ENV=production
DB_PASS=‘<pass>' bundle exec rake db:migrate RAILS_ENV=production
DB_PASS=‘<pass>' rails c -e production

User.create!(:name=>”<user name>", :password=>”<user pass>", :password_confirmation => “<pass>", :email=>”<user email>", :admin=>true)
```

最後の行の &lt;user name&gt; は査読管理システム上の管理者権限をもつユーザ名。
&lt;user pass&gt; はそのパスワード。

## 起動方法

```
RAILS_ENV='production' MAIL_SERVER='<mail server host name>' MAIL_ADDR='<email address>' DB_PASS='<pass>' SECRET_KEY_BASE=`bundle exec rake secret` bundle exec pumactl start
```

SMTP 認証を使わないので MAIL_SERVER は MAIL_ADDR 宛のメールを最終的に受け取れるサーバでなければならない。

## 停止方法

```
bundle exec pumactl halt
```

## データベース

production 環境では PostgreSQL が使われる。
一部のデータは `./files/` に保存される。

## テスト環境

テスト環境で実行する場合は次のようにする。開発環境ではデータベースとして sqlite3 が使われる。

```
bundle install --without production
bundle exec rake db:migrate RAILS_ENV=development
```

次にデータベースに管理者権限をもつアカウントを作成する。

```
RAILS_ENV='development' bundle exec rails c
```

プロンプトが現れるので以下のように実行する。

```
> User.create!(:name=>"editor", :password=>"editor", :password_confirmation => "editor", :email=>"editor@bar.com", :admin=>true)
> exit
```

これで管理者アカウントが作られる。管理者アカウントは名称が `editor` で
ログイン名が `editor@bar.com`、パスワードが `editor` である。
メールアドレスがログイン名となる。

実行するには以下のようにする。

```
RAILS_ENV='development' bundle exec puma
```
