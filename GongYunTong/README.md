
### Created by pingjun lin on 2016/11/14.

## V健康+

 
 > 项目介绍：V健康+
 
### 框架iOS前端介绍

iOS的前端主要分为5个主要模块，分别是"动态","活动","福利","发现","我"。布局的方式采用主流的UITabViewController中嵌套UINavigationController的方式。每一个模块作为UITabViewController的一个item。模块之间保持代码间的独立，不会产生代码的侵染。

UI的布局大部分采用的是Storyboard，将5个模块分成对应的5个Storyboard，既方便管理团队开发管理，也降低对机器性能的要求。

### 单独模块的介绍

#### 动态

动态的展现模式是列表类型，使用UITableView展示，列表Cell分为三种类型，分别为单图，大图，三图。对应的type = 1, type = 2, type = 3。根据不一样的type使用不一样的cell。

 

