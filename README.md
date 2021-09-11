# 論文誌査読管理システム Reviewers

## サイト固有設定

* app/helpers/articles_helper.rb

サイト固有の情報が記されているので、開設するサイトに合わせて修正する。

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

テスト環境で起動するだけなら `bundle exec puma` だけでよい。

## 停止方法

```
bundle exec pumactl halt
```
