<#include "/common/nav.ftl"/>
<link rel="stylesheet" href="/css/write.css">
<@nav "写博客">
    <!-- 编辑区域 -->
    <section class="editor-sec">
        <div id="layout">
            <div class="editor-self">
                <div class="form-group">
                    <labe.form-groupl class="sr-only" for="title">标题</labe.form-groupl>
                    <input type="text" class="form-control" id="title" value="${post.title}" placeholder="">
                </div>
                <div class="form-group">
                    <label class="sr-only" for="category">分类</label>
                    <input type="text" class="form-control col-lg-6" id="category" value="${post.keywords}" placeholder="">
                </div>
            </div>
            <div id="test-editormd">
                <textarea style="display:none;" class="text-md-my">${post.content}</textarea>
            </div>
        </div>
    </section>
    <div align="right" style="margin: 0 200px">
        <button type="button" class="btn btn-info sub-md">提交</button>
    </div>
    <script src="/editormd/editormd.js"></script>
    <script type="text/javascript">
        var testEditor;
        $(function() {
            testEditor = editormd("test-editormd", {
                width: "100%",
                height: "90%",
                emoji : true,
                path : '/editormd/lib/'
            });
        });
        $(function () {
            $(".sub-md").click(function () {
                /* 获取值，发送请求即可 */
                console.log($(".text-md-my").html());
                console.log($("#title").val());
                console.log($("#category").val());
                /* 请求后端的路径 */
                var url = "/post/updateToNoPay";
                //获得各项参数
                //val()获得输入字段的值
                var params ={
                    title:$("#title").val(),
                    content:$(".text-md-my").html(),
                    keywords:$("#category").val(),
                    id:${post.id}
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
        })
    </script>

</@nav>