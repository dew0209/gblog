<#include "/common/nav.ftl"/>

<@nav "首页">
    <#-- 以下是首页的展示区域 -->
    <div id="content-blog">
        <#list pages.list as post>
            <div id="layout" class="container">
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
                            <td colspan="3"><div id="editormd-view-${post.id}" class="div-blog"><textarea style="" class="show-5">${post.content}</textarea> </div></td>
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
    <script src="/editormd/editormd.js"></script>
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
            var pn = 2;
            var pnSize = 2;

            window.addEventListener('scroll',function (e) {
                var scrollTop = $(this).scrollTop();
                var scrollHeight = $(document).height();
                var windowHeight = $(this).height();
                if(scrollTop + windowHeight == scrollHeight){
                    var params = {
                        pn:pn++,
                        pnSize:pnSize
                    };
                    $.ajax({
                        url:"/get/more",
                        type:"post",
                        data:params,
                        success:function (d) {
                            /* 将数据回显上去 */
                            var listMd = d.data;
                            console.log(listMd)
                            $(listMd).each(function (index,value) {
                                var md = "<div id=\"layout\" class=\"container\">\n" +
                                    "                <div class=\"table-fa blog-1\">\n" +
                                    "                    <table class=\"table\" style=\"background-color: white\">\n" +
                                    "                        <tr>\n" +
                                    "                            <td class=\"styleShow show-1\"></td>\n" +
                                    "                            <td></td>\n" +
                                    "                            <td style=\"text-align: right\" class=\"styleShow\"><a href=\"\" class=\"show-2\">{}</a></td>\n" +
                                    "                        </tr>\n" +
                                    "                        <tr>\n" +
                                    "                            <td><a href=\"\"><img class=\"avatar show-3\" src=\"{post.user.avatar}\" alt=\"\"><span class=\"show-7\"></span></a></td>\n" +
                                    "                            <td></td>\n" +
                                    "                            <td style=\"font-size: 20px;text-align: right\" class=\"show-4\">{}</td>\n" +
                                    "                        </tr>\n" +
                                    "                        <tr>\n" +
                                    "                            <td colspan=\"3\"><div id=\"\" class=\"div-blog show-6\"><textarea style=\"\" class=\"show-5\">{}</textarea> </div></td>\n" +
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
                                var latL = $("#content-blog").children(":last-child");
                                latL.find(".show-1").html(value.type.typeName);
                                latL.find(".show-2").html(value.title);
                                latL.find(".show-3").attr("src",value.user.avatar);
                                latL.find(".show-7").text(value.user.username);
                                latL.find(".show-4").html(new Date(value.created).toLocaleString("en-US", {hour12: false}));
                                latL.find(".show-5").html(value.content);
                                latL.find(".show-6").attr("id","editormd-view" + value.id);
                            });
                            renderMd();
                        },
                        dataType:"json"
                    });
                }
            })
        });
    </script>
</@nav>