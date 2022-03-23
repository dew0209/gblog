<#include "/common/nav.ftl"/>

<@nav "首页">
    <#-- 以下是首页的展示区域 -->
    <div id="content-blog">
        <#list pages.list as post>
            <div id="layout" class="container">
                <div class="table-fa blog-1">
                    <table class="table" style="background-color: white">
                        <tr>
                            <td class="styleShow">${post.id}</td>
                            <td></td>
                            <td style="text-align: right" class="styleShow"><a href="">${post.title}</a></td>
                        </tr>
                        <tr>
                            <td><a href=""><img class="avatar" src="/images/xue.png" alt=""></a></td>
                            <td></td>
                            <td style="font-size: 20px;text-align: right">${post.id}</td>
                        </tr>
                        <tr>
                            <td colspan="3"><div id="editormd-view-${post.id}" class="div-blog"><textarea style="" >${post.content}</textarea> </div></td>
                        </tr>
                        <tr>
                            <td style="text-align: center"><a href=""><span class="glyphicon glyphicon-heart-empty"></span></a></td>
                            <td style="text-align: center"><a href=""><span class="glyphicon glyphicon-comment"></span></a></td>
                            <td style="text-align: center"><a href=""><span class="glyphicon glyphicon glyphicon-star-empty"></span></a></td>
                        </tr>
                    </table>
                </div>
            </div>
        </#list>
    </div>
    <script src="/editormd/lib/marked.min.js"></script>
    <script src="/editormd/lib/prettify.min.js"></script>

    <script src="/editormd/lib/raphael.min.js"></script>
    <script src="/editormd/lib/underscore.min.js"></script>
    <script src="/editormd/lib/sequence-diagram.min.js"></script>
    <script src="/editormd/lib/flowchart.min.js"></script>
    <script src="/editormd/lib/jquery.flowchart.min.js"></script>
    <script src="/editormd//editormd.js"></script>
    <script type="text/javascript">
        $(function() {
            function renderMd() {
                $.get("/editormd/examples/test.md", function(markdown) {
                    $("#content-blog").children().each(function(index, value) {
                        //页面逐一渲染
                        console.log($(value).find(".div-blog").attr("id"));
                        editormd.markdownToHTML($(value).find(".div-blog").attr("id"), {
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
            }
            renderMd();
            window.addEventListener('scroll',function (e) {
                var scrollTop = $(this).scrollTop();
                var scrollHeight = $(document).height();
                var windowHeight = $(this).height();
                if(scrollTop + windowHeight == scrollHeight){
                    alert("已经到最底部了！");
                    var md = "<div id=\"layout\" class=\"container\">\n" +
                        "                <div class=\"table-fa blog-1\">\n" +
                        "                    <table class=\"table\" style=\"background-color: white\">\n" +
                        "                        <tr>\n" +
                        "                            <td class=\"styleShow\">嘻嘻嘻</td>\n" +
                        "                            <td></td>\n" +
                        "                            <td style=\"text-align: right\" class=\"styleShow\"><a href=\"\"></a></td>\n" +
                        "                        </tr>\n" +
                        "                        <tr>\n" +
                        "                            <td><a href=\"\"><img class=\"avatar\" src=\"/images/xue.png\" alt=\"\"></a></td>\n" +
                        "                            <td></td>\n" +
                        "                            <td style=\"font-size: 20px;text-align: right\">事实上</td>\n" +
                        "                        </tr>\n" +
                        "                        <tr>\n" +
                        "                            <td colspan=\"3\"><div id=\"editormd-view-100\" class=\"div-blog\"><textarea style=\"\" >`嘿嘿`</textarea> </div></td>\n" +
                        "                        </tr>\n" +
                        "                        <tr>\n" +
                        "                            <td style=\"text-align: center\"><a href=\"\"><span class=\"glyphicon glyphicon-heart-empty\"></span></a></td>\n" +
                        "                            <td style=\"text-align: center\"><a href=\"\"><span class=\"glyphicon glyphicon-comment\"></span></a></td>\n" +
                        "                            <td style=\"text-align: center\"><a href=\"\"><span class=\"glyphicon glyphicon glyphicon-star-empty\"></span></a></td>\n" +
                        "                        </tr>\n" +
                        "                    </table>\n" +
                        "                </div>\n" +
                        "            </div>";

                    $("#content-blog").append(md);
                    renderMd();
                }
            })
            function getMd() {

            }
        });
    </script>
</@nav>