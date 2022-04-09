<#include "/common/nav.ftl"/>
<link rel="stylesheet" href="/css/write.css">
<@nav "写博客">
    <!-- 编辑区域 -->
    <section class="editor-sec" style="height: 630px">

            <div id="layout">
                <div class="editor-self">
                    <div class="form-group">
                        <labe.form-groupl class="sr-only" for="title">标题</labe.form-groupl>
                        <input type="text" class="form-control col-lg-4" id="title" placeholder="标题">
                    </div>
                    <div class="form-group">
                        <label class="sr-only" for="category">分类</label>
                        <input type="text" name="category" class="form-control col-lg-4" id="category" placeholder="分类(以逗号隔开，最多支持三个)">
                    </div>
                    <div class="form-group">
                        <label class="sr-only" for="price">价格</label>
                        <select class="form-control" id="price" name="price">
                            <option value="0">价格[1~5]</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                        </select>
                    </div>
                </div>
                <div class="clear"></div>
                <div id="test-editormd-dist">
                    <textarea style="display:none;" class="text-md-my introduce" name="introduce">介绍</textarea>
                </div>
                <div id="test-editormd">
                    <textarea style="display:none;" class="text-md-my content" name="content">正文（付费内容）</textarea>
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
                height: "70%",
                emoji : true,
                path : '/editormd/lib/'
            });
            editormd("test-editormd-dist", {
                width: "100%",
                height: "30%",
                emoji : true,
                path : '/editormd/lib/',
                toolbarIcons: function () {
                    return [''];
                }
            });
        });
        $(function () {
            $(".sub-md").click(function () {
                /* 获取值，发送请求即可 */
                console.log($("#title").val());
                console.log($("#category").val());
                console.log($("#price").find("option:selected").val());
                console.log($(".introduce").val());
                console.log($(".content").val());
                /* 请求后端的路径 */
                var url = "/yui/add";
                //获得各项参数
                //val()获得输入字段的值
                var params ={
                    title:$("#title").val(),
                    content:$(".content").val(),
                    keywords:$("#category").val(),
                    price:$("#price").find("option:selected").val(),
                    introduce:$(".introduce").val()
                }
                $.ajax({
                    url:url,
                    type:"post",
                    data:params,
                    success:function (d) {
                        alert(d.msg);
                    },
                    dataType:"json"
                })
            });
        })
    </script>

</@nav>