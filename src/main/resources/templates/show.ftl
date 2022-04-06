<#include "/common/nav.ftl"/>
<@nav "个人空间">
    <script>
        //主楼id  文章id 回复评论的评论id 回复评论的作者id  回复内容
        function funRe(a,b,c,d,e) {
            var url = "/comment/add";
            var params ={
                id:a,
                postId:b,
                replayId:c,
                userId:d,
                comment:e
            }
            $.ajax({
                url:url,
                type:"post",
                data:params,
                success:function (d) {
                    location.href = "/post/blog/${post.id}"
                },
                dataType:"json"
            })
        }
    </script>
    <link href="/css/edit.css" rel="stylesheet">
    <section class="">
        <div class="">
            <div class="mess-people">
                <!-- 2.  动态 -->
                <section>
                    <ul>
                        <li class="item-show" style="display: block">
                            <div class="pe-blog">
                                <div id="layout">
                                    <!-- 拆分1 -->
                                    <div class="table-fa blog-1">
                                        <table class="table" style="background-color: white">
                                            <tr>
                                                <td class="styleShow show-1">${post.type.typeName}</td>
                                                <td></td>
                                                <td style="text-align: right" class="styleShow"><a href="" class="show-2">${post.title}</a></td>
                                            </tr>
                                            <tr>
                                                <td><a href=""><img class="avatar show-3" src="${post.user.avatar}" alt=""> <span class="show-7">${post.user.username}</span></a></td>
                                                <td></td>
                                                <td style="font-size: 20px;text-align: right" class="show-4">${post.created?string('MM/dd/yyyy, HH:mm:ss')}</td>
                                            </tr>
                                            <tr>
                                                <td colspan="3"><div id="editormd-view-1" class="div-blog"><textarea style="" class="show-5">${post.content}</textarea></div></td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </li>
                    </ul>

                </section>
                <!-- 点赞，喜欢 -->
                <span class="love">
                        <a href=""><span class="glyphicon glyphicon-heart-empty"></span></a>
                    </span>
                <!-- 收藏 -->
                <span class="collection">
                        <a href=""><span class="glyphicon glyphicon-star-empty"></span></a>
                    </span>
            </div>
        </div>
        <div class="fa-comment-sub">
            <div align="left" class="comment-sum">2 条评论</div>
            <hr>
            <textarea class="form-control review-commit-fa" rows="3"></textarea>
            <div align="right" class="review-commit"><button type="button" class="btn btn-info" style="margin-top: 20px;margin-bottom: 20px">提交评论</button></div>
            <hr>
            <!-- 评论展示区域 -->
            <div class="comment-show">
                <!-- 这是一条评论 -->
                <!-- 主楼 -->
                <#list comment as item>
                    <div>
                    <div class="row" style="box-shadow: 0 0 10px lightgray;">
                        <div class="col-md-1"  style="max-width: 60px;">
                            <a href = "/user/${item.userId}">
                                <img class="img-circle" src="${item.avatar}" alt="用户头像" width="45px">
                            </a>
                        </div>
                        <div class="col-md-11">
                            <div>
                                <a href="/user/${item.userId}" style="font-size: 15px;">
                                    ${item.userName}
                                </a>
                                &nbsp;
                                <span class="comment-title" title="2022-02-15 22:25">${item.created?string('MM/dd/yyyy, HH:mm:ss')}</span>
                                &nbsp;&nbsp;&nbsp;
                                <a id="" class="review-comment review-${item.id}">回复</a>
                            </div>
                            <div style="margin-top: 5px">
                                ${item.comment}
                            </div>
                            <div class="review-comment-show-${item.id}" style="display: none">
                                <textarea class="form-control comm-${item.id}" rows="3"></textarea>
                                <div align="right"><button type="button" class="btn btn-info click-${item.id}" style="margin-top: 20px;margin-bottom: 20px">提交回复</button></div>
                                <script>
                                    $(".review-${item.id}").click(function () {
                                        if($(".review-comment-show-${item.id}").css("display") == "none"){
                                            $(".review-comment-show-${item.id}").css("display","block");
                                            $(".review-${item.id}").html("收起");
                                        }else {
                                            $(".review-comment-show-${item.id}").css("display","none");
                                            $(".review-${item.id}").html("回复");
                                        }
                                    })
                                    $(".click-${item.id}").click(function () {
                                        funRe(${item.id},${post.id},0,${item.userId},$(".comm-${item.id}").val());
                                    });

                                </script>
                            </div>
                            <!-- 附楼 -->
                            <#list item.reComm as it>
                                <div style="margin: 5px 0">
                                <div class="row">
                                    <div class="col-md-1"  style="max-width: 60px;">
                                        <a href = "/user/${it.userId}">
                                            <img class="img-circle" src="${it.avatar}" alt="用户头像" width="45px">
                                        </a>
                                    </div>
                                    <div class="col-md-11">
                                        <div>
                                            <a href="/user/${it.userId}" style="font-size: 15px;">
                                                ${it.userName}
                                            </a>
                                            &nbsp;
                                            <span class="comment-title" title="2022-02-15 22:25">${it.created?string('MM/dd/yyyy, HH:mm:ss')}</span>
                                            &nbsp;&nbsp;&nbsp;
                                            <span>回复了${it.reName}的评论</span>
                                            <a id="" class="review-comment-2 review-${it.id}">回复</a>
                                            <a id="" class="review-del-${it.id}">删除</a>
                                            <script>

                                            </script>

                                        </div>
                                        <div id="comment_content_186185">
                                            ${it.comment}
                                        </div>
                                        <div class="review-comment-show-${it.id}" style="display: none">
                                            <textarea class="form-control comm-${it.id}" rows="3"></textarea>
                                            <div align="right"><button type="button" class="btn btn-info click-${it.id}" style="margin-top: 20px;margin-bottom: 20px">提交回复</button></div>
                                            <script>
                                                $(".review-${it.id}").click(function () {
                                                    if($(".review-comment-show-${it.id}").css("display") == "none"){
                                                        $(".review-comment-show-${it.id}").css("display","block");
                                                        $(".review-${it.id}").html("收起");
                                                    }else {
                                                        $(".review-comment-show-${it.id}").css("display","none");
                                                        $(".review-${it.id}").html("回复");
                                                    }
                                                });

                                                $(".click-${it.id}").click(function () {
                                                    funRe(${item.id},${post.id},${it.id},${it.userId},$(".comm-${it.id}").val());
                                                });
                                            </script>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            </#list>
                        </div>

                    </div>
                </div>
                </#list>
            </div>
        </div>
    </section>
    <script src="/editormd/lib/marked.min.js"></script>
    <script src="/editormd/lib/prettify.min.js"></script>

    <script src="/editormd/lib/raphael.min.js"></script>
    <script src="/editormd/lib/underscore.min.js"></script>
    <script src="/editormd/lib/sequence-diagram.min.js"></script>
    <script src="/editormd/lib/flowchart.min.js"></script>
    <script src="/editormd/lib/jquery.flowchart.min.js"></script>
    <script src="/editormd/editormd.js"></script>
    <script type="text/javascript">
        $(function() {
            $.get("/editormd/examples/test.md", function(markdown) {
                editormd.markdownToHTML("editormd-view-1", {
                    markdown        : markdown ,
                    htmlDecode      : "style,script,iframe",
                    tocm            : true,
                    emoji           : true,
                    taskList        : true,
                    tex             : true,
                    flowChart       : true,
                    sequenceDiagram : true,
                });
            });
        });
    </script>
    <script>
        //评论
        $(".review-commit").click(function () {
            /* 请求后端的路径 */
            var url = "/comment/${post.id}";
            var params ={
                review:$(".review-commit-fa").val() + "",
            }
            $.ajax({
                url:url,
                type:"post",
                data:params,
                success:function (d) {
                    location.href = "/post/blog/${post.id}";
                },
                dataType:"json"
            })
        });
    </script>
</@nav>