FKY-Git Commit
============
方块一移动端代码库


规范
---

## Commit
1. 提交的次数尽可能多
2. 提交的内容尽可能少
3. 提交的内容要专注
4. 作者信息需要输入正确的姓名和公司邮箱

#### Commit注释格式
**[类型][类型信息]提交描述**

`类型`和`类型信息`描述这次提交的目的，如：修复一个问题；添加一个功能；优化一个功能。

`提交描述`则说明如何去做，如：添加了非空判断的代码；添加自动登陆的代码；去除无效的代码。 

##### 类型（必选）与类型信息（可选）
已定义的`类型`：
- `Bug` or `B` 问题 
- `Feature` or `F` 功能
- `Optimize` or `O` 优化
- `Task` or `T` 小任务

为什么不定义Add或Remove为类型？  
比如：Optimize这种修改，可能包含Add和Remove。所以，类型不应该是具体操作。

`类型信息`是指`类型`相关的信息。  
举个栗子：`Bug`对应的是禅道中的Bug ID


**如需要新的类型，请在下面回复讨论**

##### 提交描述
类型信息可以是禅道中Bug号，也可以是禅道中task的标题，或者其它信息。 

#### 举个栗子 
1. [B][方块1移动端-1954]因xxx导致此bug，修复方案：xxx
2. [F][登录模块]采用RAC重写

可以使用一些常见的动作来描述问题：Fixed, Add, Update, Improve, Remove, Change

## 分支
采用`Git Flow`的模型，略有不同。

### Git Flow

[Git Flow](http://nvie.com/posts/a-successful-git-branching-model/)是一套Git工作流模型[中文参考](http://www.ituring.com.cn/article/56870)，为软件迭代的不同阶段定义了对应的分支命名标准。SourceTree已经集成了对Git Flow完整的支持，通过工具栏按扭可以完成整个流程操作。

#### 分支

- master 归档已发布版本的分支，在合并release分支时会自动合并到master。只有在需要创建hotfix分支时，才需要在master分支上操作
- develop 开发分支
- feature 新需求或Bug修复的分支
- release 版本集成测试分支
- hotfix 需要在已发布的版本基础上修复问题的分支

#### 流程图
![Git Flow模型全图](http://git.111.com:8082/yangyouyong/mobile/raw/master/FKY/gitflow_model.png)

#### 其它要求

- 使用有意义的名称创建分支
- 为了避免冲突，在feature分支的开发过程中需要及时合并develop的更新，这样就需要保证develop上没有不完整的功能代码。
- 从feature合并回develop时，需要在GitLab上发Merge Request。当前QA没有对分支进行测试，所以这一过程非常有必要。
- 如果出现多个人修改相同的地方时，需要将feature推送到服务器，然后多人在同feature分支下进行修改。
- release分支创建后，统一邮件通知大家，集成测试中Bug在release分支上修复，这点需要注意。release分支尽量不要做大的修改。

#### SourceTree使用

##### Git Flow生命周期

首次点击项目的Git Flow按扭时，分出现不同阶段的分支名称设置，保持默认设置。

![GitFlow 初始化](http://git.111.com:8082/yangyouyong/mobile/raw/develop/FKY/gitflow_init.png)

本地初始化后再次点击Git Flow按扭时，选择设置开发类型(功能开发,bug修复)。

![GitFlow 开发类型选择](http://git.111.com:8082/yangyouyong/mobile/raw/develop/FKY/gitflow_featureBranch.png)

给新开的分支命名后,即可在该分支下进行开发(功能开发,bug修复,测试等)

![GitFlow 创建分支](http://git.111.com:8082/yangyouyong/mobile/raw/develop/FKY/gitflow_featureBranch_create.png)

在该分支上功能开发完毕,再次点击Git Flow按扭 完成功能开发,sourceTree会将分支代码合并到develop分支中去
![GitFlow 分支开发完毕](http://git.111.com:8082/yangyouyong/mobile/raw/develop/FKY/gitflow_branch_finished.png)


参照
- [基于git的源代码管理模型——git flow](http://www.ituring.com.cn/article/56870)