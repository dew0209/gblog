$(function () {
    /* 点击登录和注册按钮之间的视图切换*/
    var login=document.getElementById('login');
    var register=document.getElementById('register');
    var form_box=document.getElementsByClassName('form-box')[0];
    var register_box=document.getElementsByClassName('register-box')[0];
    var login_box=document.getElementsByClassName('login-box')[0];
    register.addEventListener('click',()=>{
        form_box.style.transform='translateX(80%)';
        login_box.classList.add('hidden');
        register_box.classList.remove('hidden');
    })
    login.addEventListener('click',()=>{
        form_box.style.transform='translateX(0%)';
        register_box.classList.add('hidden');
        login_box.classList.remove('hidden');
    })
    var mask = document.querySelector('.login-bg');
    var loginUpDown = document.querySelector('#link');
    var loginSection = document.querySelector('.loginSection');
    var loginClose = document.querySelector('.loginClose');
    loginUpDown.addEventListener('click',()=>{
        loginSection.style.display = 'flex';
        mask.style.display = 'block';
    })
    loginClose.addEventListener('click',()=>{
        loginSection.style.display = 'none';
        mask.style.display = 'none';
    })
    //注册发送ajax请求
    $("#gblog-register").click(function () {
        /* 请求后端的路径 */
        var url = "/user/register";
        //获得各项参数
        //val()获得输入字段的值
        var params ={
            username:$("#username").val() + "",
            email:$("#email").val() + "",
            password:$("#password").val() + "",
            passwordAgain:$("#passwordAgain").val() + ""
        }
        $.ajax({
            url:url,
            type:"post",
            data:params,
            success:function (d) {
                login.click();
            },
            dataType:"json"
        })
    })
    /* 发送邮件 */
    $("#sendCode").click(function () {
        var url = "/user/verify"
        var params ={
            email:$("#email").val() + ""
        }
        $.ajax({
            url:url,
            type:"get",
            data:params,
            success:function (d) {
                console.log(d.msg);
            },
            dataType:"json"
        })
    })
    //登录发送ajax请求
    $("#gblog-login").click(function () {
        /* 请求后端的路径 */
        var url = "/user/login";
        //获得各项参数
        //val()获得输入字段的值
        var params ={
            email:$("#login-email").val() + "",
            password:$("#login-password").val() + "",
        }
        $.ajax({
            url:url,
            type:"post",
            data:params,
            success:function (d) {
                //window.location=d.action;
                location.reload();
            },
            dataType:"json"
        })
    })
})