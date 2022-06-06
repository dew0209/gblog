<#include "/common/nav.ftl"/>
<link href="/crop-avatar/css/cropper.min.css" rel="stylesheet">
<link href="/crop-avatar/css/main.css" rel="stylesheet">
<style>
    .info-up .info-left {
        float: left;
        width: 220px;
        height: 220px;
        margin-right: 50px;

    }
    .info-up {
        margin: 0 400px;
        margin-top: 40px;
    }
    .info-up .info-right {
        float: right;
        width: 700px;
        height: 600px;

    }
</style>
<@nav "博客列表">
    <section>
        <div class="info-up">
            <section class="">
                <div class="container info-left" id="crop-avatar">
                    <div class="avatar-view" title="Change the avatar">
                        <img src="${infoUser.avatar}" style="height: 100%;width: 100%" alt="Avatar">
                    </div>
                    <div class="modal fade" id="avatar-modal" aria-hidden="true" aria-labelledby="avatar-modal-label" role="dialog" tabindex="-1">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <form class="avatar-form" action="/info/avatar" enctype="multipart/form-data" method="post">
                                    <div class="modal-header">
                                        <button class="close" data-dismiss="modal" type="button">&times;</button>
                                        <h4 class="modal-title" id="avatar-modal-label">修改头像</h4>
                                    </div>
                                    <div class="modal-body">
                                        <div class="avatar-body">
                                            <div class="avatar-upload">
                                                <input class="avatar-src" name="avatar_src" type="hidden">
                                                <input class="avatar-data" name="avatar_data" type="hidden">
                                                <label for="avatarInput">Local upload</label>
                                                <input class="avatar-input" id="avatarInput" name="avatar_file" type="file">
                                            </div>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="avatar-wrapper"></div>
                                                </div>
                                            </div>
                                            <div class="row avatar-btns">
                                                <div class="col-md-3">
                                                    <button style="background-color: blue" class="btn btn-primary btn-block avatar-save" type="submit">完成</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="loading" aria-label="Loading" role="img" tabindex="-1"></div>
                </div>
            </section>
            <section class="info-right">
                <#-- 显示个人信息 -->
                <div class="panel-body">
                    <div class="row" style="margin-left: 20px; margin-right: 20px;background-color: white;box-shadow: 1px 1px -1px -1px">
                        <h3 style="text-align: left;font-size: 16px;margin:10px">个人信息</h3>
                        <hr/>
                        <form id="form_upload_profileinfo" class="form-horizontal" role="form" action="/user/profile/index/" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="csrfmiddlewaretoken" value="CnvbSqpmzu4mGwN8rMV1AwaLzKH3TYib9u8yUPYFxXYGZSRp1ymFktYHGxjoA1Rg">

                            <div class="form-group">
                                <label class="control-label col-md-3"><label for="id_username">用户名:</label></label>
                                <div class="col-md-7"><input type="text" name="username" value="${infoUser.username}" class="username form-control" maxlength="30" required id="id_username"></div>
                                <span class="text-danger small"></span>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3"><label for="id_username">个人简介:</label></label>
                                <div class="col-md-7"><input type="text" name="sign" value="${infoUser.sign}" class="sign form-control" maxlength="30" required id="id_username"></div>
                                <span class="text-danger small"></span>
                            </div>
                            <button type="button" class="btn btn-success btn-base-info" style="border-radius: 5px;background-color: blue">更新信息</button>
                        </form>
                    </div>
                </div>

                <#-- 账号安全 -->
                <div class="panel-body">
                    <div class="row" style="margin-left: 20px; margin-right: 20px;background-color: white;box-shadow: 1px 1px -1px -1px">
                        <h3 style="text-align: left;font-size: 16px;margin:10px">账号安全</h3>
                        <hr/>
                        <form id="form_upload_profileinfo" class="form-horizontal" role="form" action="" method="post" enctype="multipart/form-data">
                            <div class="form-group">
                                <label class="control-label col-md-3"><label for="id_username">当前密码：</label></label>
                                <div class="col-md-7"><input type="password"  name="oldpass" value="" class="oldpass form-control" maxlength="30" required id="id_username"></div>
                                <span class="text-danger small"></span>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3"><label for="id_username">新密码：</label></label>
                                <div class="col-md-7"><input type="password"  name="newpass" value="" class="newpass form-control" maxlength="30" required id="id_username"></div>
                                <span class="text-danger small"></span>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3"><label for="id_username">新密码：</label></label>
                                <div class="col-md-7"><input type="password" name="newpassAgain" value="" class="form-control newpassAgain" maxlength="30" required id="id_username"></div>
                                <span class="text-danger small"></span>
                            </div>
                            <button type="button" class="btn btn-success btn-pass-info" style="border-radius: 5px;background-color: blue">更新密码</button>
                            <script>
                                $(function () {
                                    $(".btn-pass-info").click(function () {
                                        var params = {
                                            oldpass: $(".oldpass").val(),
                                            newpass: $(".newpass").val(),
                                            newpassAgain: $(".newpassAgain").val()
                                        };
                                        console.log(1111);
                                        $.ajax({
                                            url:"/info/setPas",
                                            type:"post",
                                            data:params,
                                            success:function (d) {
                                                console.log(d);
                                                if(d.status == -1){
                                                    alert(d.msg);
                                                    return;
                                                }
                                                alert("修改成功！")
                                                location.href = "http://localhost:8080/" + d.action;
                                            },
                                            dataType:"json"
                                        });
                                    });

                                    $(".btn-base-info").click(function () {
                                        var params = {
                                            username: $(".username").val(),
                                            sign: $(".sign").val(),

                                        };
                                        console.log(1111);
                                        $.ajax({
                                            url:"/info/setBase",
                                            type:"post",
                                            data:params,
                                            success:function (d) {
                                                console.log(d);
                                                if(d.status == -1){
                                                    alert(d.msg);
                                                    return;
                                                }
                                                alert("修改成功！")
                                                location.href = "http://localhost:8080/" + d.action;
                                            },
                                            dataType:"json"
                                        });
                                    });
                                })
                            </script>
                        </form>
                    </div>
                </div>
            </section>
        </div>
    </section>

</@nav>

        <script src="/crop-avatar/js/cropper.js"></script>
        <script src="/crop-avatar/js/main.js"></script>