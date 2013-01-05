用途
====

PinYinNick 给 Mac 上的联系人添加拼音缩写作为昵称。

添加后在 Contacts.app (原 Address Book.app), Mail.app 等程序中可使用拼音缩写来搜索联系人。iCloud 同步后，也可用缩写在 iOS 上搜索联系人，效果如下图：

<img src="https://www.evernote.com/shard/s2/sh/eff7e0ba-ebef-44c6-a77d-bd5233a8dcfe/2990a27e4d5723c5aa68c43ef4886db4/deep/0/PinYinNick%20makes%20contact%20search%20easy.jpg" alt="PYNickInContacts" />

使用说明
=======

**注意：系统要求至少为 Lion。PinYinNick 在 Lion 和 Mountain Lion 上测试过。**

这是个非常简单的程序。界面如下：

<img src="https://www.evernote.com/shard/s2/sh/8528f9c8-8e43-45cb-800e-6884fa046a44/14c5c0eed94abc4b1a39e8976c4d0ec3/deep/0/PinYinNick%20on%20OS%20X.jpg"
alt="PinYinNickScreenShot" />

蓝色联系人表示添加了昵称，点击保存按钮时会把修改保存到系统联系人信息中。

下列联系人不会改动其昵称：

- 原先已有昵称
- 名字中不含中文

点击昵称可进行修改，点击列表标题栏可排序。

文件菜单提供了删除所有中文联系人昵称的功能。

没有对多音字进行特别处理，因此一些姓氏和名词会得到错误的缩写，例如姓氏“查”会得到
"c"，“银行”得到的是 "yx"。（暂时没有解决这个问题的打算。）

其他
====

- 拼音查询使用的是我自己写的库 [hanzi2pinyin](https://github.com/cyfdecyf/hanzi2pinyin)
  - 这个库只覆盖了 Unihan block1 中的汉字，日常使用应该足够
- 图标下载自 [IconArchive](http://www.iconarchive.com/show/oxygen-icons-by-oxygen-icons.org/Mimetypes-x-office-address-book-icon.html)，由 [Oxygen](http://www.oxygen-icons.org/) 设计
- 如果觉得 iPhone 上拨打电话、发短信或邮件时搜索联系人不方便，推荐尝试
[Dialvetica](http://itunes.apple.com/us/app/dialvetica-contacts/id404074258?mt=8)，添加拼音昵称之后用起来会很方便
