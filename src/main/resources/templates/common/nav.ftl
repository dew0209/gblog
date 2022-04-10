<#macro nav title>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>${title}</title>
        <link rel="stylesheet" href="/css/bootstrap.min.css">
        <link rel="stylesheet" href="/css/nav.css">
        <link rel="stylesheet" href="/css/loginSection.css">
        <link rel="stylesheet" href="/editormd/examples/css/style.css" />
        <link rel="stylesheet" href="/editormd/css/editormd.preview.css" />
        <link rel="stylesheet" href="/editormd/css/editormd.css" />
        <script src="/js/jquery-3.6.0.min.js"></script>
        <script src="/js/bootstrap.js"></script>
        <script src="/js/common/nav.js"></script>
    </head>
    <body>
        <#-- 导航条 + 登录 -->
        <!--导航条 -->
        <nav class="navbtn w navbar navbar-default">
            <div class="container-fluid">
                <div class="navbar-header">
                    <!-- 这个是小屏幕会显示的汉堡条（三条横线） -->
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                        <span class="sr-only">小屏幕时会显示</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="/index">离客</a>
                </div>
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">
                        <!-- active表示当前的链接已经被选中了 -->
                        <li class=""><a href="/index">首页 <span class="sr-only">(current)</span></a></li>

                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">文章<span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="/post/1" class="blackC">博客</a></li>
                                <!-- divider会出现分割线 -->
                                <li role="separator" class="divider"></li>
                                <li><a href="/yui/1" class="blackC">付费</a></li>
                            </ul>
                        </li>
                        <li><a href="#"></a></li>
                    </ul>
    
                    <!-- 未登录 -->
                    <@shiro.guest>
                        <ul class="nav navbar-nav navbar-right">
                            <li><a href="#" id="link">登录</a></li>
                        </ul>
                    </@shiro.guest>
                    <!-- 已经登录 消息提醒的字体图标+个人中心 -->
                    <@shiro.user>
                        <ul class="nav navbar-nav navbar-right">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                    <span class="glyphicon glyphicon-bell" aria-hidden="true"></span>
                                    <img src="<@shiro.principal property="avatar"/>" alt="" class="avatar"> <@shiro.principal property="username"/> <span class="caret"></span></a>
                                <ul class="dropdown-menu">
                                    <li><a href="/user/<@shiro.principal property="id"/>" class="blackC">我的空间</a></li>
                                    <li><a href="/info/<@shiro.principal property="id"/>" class="blackC">个人信息</a></li>
                                    <!-- divider会出现分割线 -->
                                    <li role="separator" class="divider"></li>
                                    <li><a href="/order/<@shiro.principal property="id"/>" class="blackC">我的订单</a></li>
                                    <li role="separator" class="divider"></li>
                                    <li><a href="/user/logout" class="blackC">退出</a></li>
                                </ul>
                            </li>
                        </ul>
                    </@shiro.user>

                </div>
            </div>
        </nav>
        <!-- 登录模态 -->
        <section class="loginSection w">
            <div class="container">
                <div class="form-box">
                    <!-- 注册 -->
                    <div class="register-box hidden">
                        <h1>register</h1>
                        <input type="text" placeholder="用户名" name="username" id="username">
                        <input type="email" placeholder="邮箱" name="email" id="email">
                        <input type="password" placeholder="密码" name="password" id="password">
                        <input type="password" placeholder="确认密码" name="passwordAgain" id="passwordAgain">
                        <div id="sendEmailCode">
                            <input type="text" placeholder="验证码" name="verify" id="verify"><button id="sendCode">验证</button>
                        </div>
                        <div>
                            <span id="error-message"></span>
                        </div>
                        <button id="gblog-register">注册</button>
                    </div>
                    <!-- 登录 -->
                    <div class="login-box">
                        <h1>login</h1>
                        <input type="text" placeholder="邮箱" name="email" id="login-email">
                        <input type="password" placeholder="密码" name="password" id="login-password">
                        <div>
                            <span id="login-error--message"></span>
                        </div>
                        <button id="gblog-login">登录</button>
                    </div>
                </div>

                <div>
                    <div class="con-box left">
                        <h2>欢迎来到<br><span>离客</span></h2>
                        <p>快来书写你的专属<span>博客</span>吧</p>
                        <img src="/images/yui.png" alt="">
                        <p>已有账号</p>
                        <button id="login">去登陆</button>
                    </div>
                    <div class="con-box right">
                        <h2>欢迎来到<br><span>离客</span></h2>
                        <p>快来看看你的<span>博客</span>吧</p>
                        <img src="/images/xue.png" alt="">
                        <p>没有账号？</p>
                        <button id="register">去注册</button>
                    </div>
                    <span class="glyphicon glyphicon-remove-circle loginClose" aria-hidden="true"></span>
                </div>
            </div>
        </section>
        <!-- 登录模态框的遮挡层 -->
        <section>
            <div id="bg" class="login-bg"></div>
        </section>
        <#nested>
    </body>
    </html>

</#macro>