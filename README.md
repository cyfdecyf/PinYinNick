用途
====

程序可以在 Mac 上为联系人添加拼音缩写的昵称，添加后可在 Address Book 中用缩写搜索联系人。通过
iCloud 同步后，也可以用缩写在 iOS 上搜索联系人，效果如下图：

<img src="https://img.skitch.com/20120525-n93785yk6qdctmf5gcjdx62ueb.png" alt="PYNickInContacts" />

如果您觉得 iPhone 上拨打电话、发送短信或邮件时搜索联系人不方便，推荐尝试
[Dialvetica](http://itunes.apple.com/us/app/dialvetica-contacts/id404074258?mt=8)。
在添加了拼音昵称后用起来得心应手。

使用说明
=======

**注意：系统要求为 Lion，仅在 Lion 10.7.3, 10.7.4 上测试过。**

这是个非常简单的程序。界面如下：

<img src="https://img.skitch.com/20120504-dpg2q91s8hiyd7ygx3wmjfrcc9.jpg"
alt="PinYinNickScreenShot" />

蓝色的联系人表示是添加了昵称的，点击保存按钮时会把修改保存到 Address Book 中。

对于下列联系人不会改动其昵称：

- 原先已有昵称
- 名字中不包含中文

界面上可以直接修改联系人昵称，点击列表标题栏可以进行排序。

文件菜单提供了删除所有中文联系人昵称的功能。

没有对多音字进行特别处理，因此一些姓氏和名词会得到错误的缩写，例如姓氏“查”会得到
"c"，“银行”得到的是 "yx"。（暂时没有解决这个问题的打算。）

其他
====

- 拼音查询使用的是我自己写的库 [hanzi2pinyin](https://github.com/cyfdecyf/hanzi2pinyin)
  - 这个库只覆盖了 Unihan block1 中的汉字，日常使用应该足够
- 图标下载自 [IconArchive](http://www.iconarchive.com/show/oxygen-icons-by-oxygen-icons.org/Mimetypes-x-office-address-book-icon.html)，由 [Oxygen](http://www.oxygen-icons.org/) 设计
