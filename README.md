### LOADING 按钮

### 效果
![](2018-08-24 16.25.00.gif)

### 使用
 
 * 创建按钮
 
```

ANLoadButton *btn = [[ANLoadButton alloc] initWithFrame:CGRectMake(150, 200, 150, 44)];
[self.view addSubview:btn];
```

* show


```
展示成功
[self.loadBtn show:ANLoadSuccess];
展示失败
[self.loadBtn show:ANLoadError];
```



