<#include "/common/nav.ftl"/>
<@nav "个人空间">
    <link rel="stylesheet" href="/css/person-message.css" />
    <section class="person-show-self">
        <div class="person-show-diff">
            <!-- 个人信息区域 -->
            <div class="person-only">
                <ul class="list-group">
                    <li class="list-group-item">
                        <img src="${current_user.avatar}" alt="..." class="img-rounded">
                    </li>
                    <li class="list-group-item">
                        <div class="username-show">${current_user.username}</div>
                        <div>${current_user.sign}</div>
                    </li>
                    <li class="list-group-item">
                        <div><span>关注数：</span> ${nums.focusNum} </div>
                        <div><span>阅读量：</span> ${nums.readingNum} </div>
                        <div><span>粉丝数：</span> ${nums.fansNum} </div>
                        <div style="text-align: right">
                            <#if current_user.status = 1>
                                在线
                            </#if>
                            <#if current_user.status != 1>
                                离线
                            </#if>
                        </div>
                    </li>
                    <li class="list-group-item p-in-fa" style="width: 140px;height: 140px">
                        <#list visitors as item>
                            <div class="p-in">
                                <a href="/other/user/${item.visitorUser.id}"><img style="width: 40px;height: 40px" src="${item.visitorUser.avatar}" title="${item.visitorTime?string('MM/dd/yyyy, HH:mm:ss')}" class="img-rounded"></a>
                            </div>
                        </#list>
                    </li>
                </ul>
            </div>
            <div class="mess-people">
                <!-- 展示 -->
                <!-- 1. 导航条 -->
                <nav class="nav-people">
                    <ul>
                        <li class="item-click"><a href="#">动态</a></li>
                        <li class="item-click"><a href="#">博客</a></li>
                        <!-- 付费对本人和非本人有不同的区别 -->
                        <li class="item-click"><a href="#">付费</a></li>
                        <li class="item-click"><a href="#">收藏</a></li>
                        <!-- 只对本人开放 -->
                        <li class="item-click"><a href="#">粉丝</a></li>
                        <li class="item-click"><a href="#">关注</a></li>
                        <li class="item-click"><a href="#">通知</a></li>
                    </ul>
                </nav>
                <div class="clear"></div>
                <!-- 2.  动态 -->
                <section>
                    <ul>
                        <li class="item-show" style="display: block">
                            <div class="pe-blog">
                                <#list pages.list as post>
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
                                                <td colspan="3"><div id="editormd-view-${post.id}" class="div-blog"><textarea style="" class="show-5">${post.content}</textarea> </div></td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                </#list>
                            </div>
                        </li>
                        <li class="item-show">
                            <!-- 标题           时间   阅读量  （按时间进行排序）-->
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th scope="row">#</th>
                                        <th>标题</th>
                                        <th>时间</th>
                                        <th>阅读量</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <#-- 展示 -->
                                <tr>
                                    <th scope="row">4</th>
                                    <td>spring学习笔记四</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>112</td>
                                </tr>
                                <tr>
                                    <th scope="row">4</th>
                                    <td>spring学习笔记四</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>112</td>
                                </tr>
                                </tbody>
                            </table>
                            <div align="right">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination" style="margin-right: 5px">
                                        <li>
                                            <a href="#" aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                        <#--<li class="active"><a href="#" >1</a></li>
                                        <li><a href="#">2</a></li>
                                        <li><a href="#">3</a></li>
                                        <li><a href="#">4</a></li>
                                        <li><a href="#">5</a></li>-->
                                        <li>
                                            <a href="#" aria-label="Next">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </li>
                        <!-- 付费对本人和非本人有不同的区别 -->
                        <li class="item-show">
                            <table class="table table-striped">
                                <thead>
                                <tr>
                                    <th scope="row">#</th>
                                    <th>标题</th>
                                    <th>时间</th>
                                    <th>收/总 (人数)</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>spring学习笔记一</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>2/4</td>
                                </tr>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>spring学习笔记一</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>2/4</td>
                                </tr>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>spring学习笔记一</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>2/4</td>
                                </tr>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>spring学习笔记一</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>2/4</td>
                                </tr>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>spring学习笔记一</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>2/4</td>
                                </tr>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>spring学习笔记一</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>2/4</td>
                                </tr>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>spring学习笔记一</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>2/4</td>
                                </tr>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>spring学习笔记一</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>2/4</td>
                                </tr>
                                </tbody>
                            </table>

                            <div align="right">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination" style="margin-right: 5px">
                                        <li>
                                            <a href="#" aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                        <li class="active"><a href="#" >1</a></li>
                                        <li><a href="#">2</a></li>
                                        <li><a href="#">3</a></li>
                                        <li><a href="#">4</a></li>
                                        <li><a href="#">5</a></li>
                                        <li>
                                            <a href="#" aria-label="Next">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>

                            <div align="right" style="margin: 5px">
                                <button type="button" class="btn btn-info">结算收益</button>
                            </div>
                        </li>
                        <li class="item-show">
                            <!--
                                类型	标题	作者	日期	阅读	删除
                            -->
                            <table class="table table-striped">
                                <thead>
                                <tr>
                                    <th scope="row">#</th>
                                    <th>类型</th>
                                    <th>标题</th>
                                    <th>作者</th>
                                    <th>日期</th>
                                    <th>阅读</th>
                                    <th>删除</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>博客</td>
                                    <td>spring学习笔记</td>
                                    <td>godx</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>12</td>
                                    <td><a href="#">删除</a></td>
                                </tr>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>博客</td>
                                    <td>spring学习笔记</td>
                                    <td>godx</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>12</td>
                                    <td><a href="#">删除</a></td>
                                </tr>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>博客</td>
                                    <td>spring学习笔记</td>
                                    <td>godx</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>12</td>
                                    <td><a href="#">删除</a></td>
                                </tr>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>博客</td>
                                    <td>spring学习笔记</td>
                                    <td>godx</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>12</td>
                                    <td><a href="#">删除</a></td>
                                </tr>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>博客</td>
                                    <td>spring学习笔记</td>
                                    <td>godx</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>12</td>
                                    <td><a href="#">删除</a></td>
                                </tr>
                                <tr>
                                    <th scope="row">1</th>
                                    <td>博客</td>
                                    <td>spring学习笔记</td>
                                    <td>godx</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td>12</td>
                                    <td><a href="#">删除</a></td>
                                </tr>
                                </tbody>
                            </table>

                            <div align="right">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination" style="margin-right: 5px">
                                        <li>
                                            <a href="#" aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                        <li class="active"><a href="#" >1</a></li>
                                        <li><a href="#">2</a></li>
                                        <li><a href="#">3</a></li>
                                        <li><a href="#">4</a></li>
                                        <li><a href="#">5</a></li>
                                        <li>
                                            <a href="#" aria-label="Next">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </li>
                        <!-- 只对本人开放 -->
                        <li class="item-show">粉丝 内容</li>
                        <li class="item-show">关注 内容</li>
                        <li class="item-show">通知 内容</li>

                    </ul>

                </section>
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
        var ok = false;
        $(function() {
            function renderMd() {
                $.get("/editormd/examples/test.md", function(markdown) {
                    $(".pe-blog").children().each(function(index, value) {
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
                if(ok)return;
                console.log("监听滚动");
                var scrollTop = $(this).scrollTop();
                var scrollHeight = $(document).height();
                var windowHeight = $(this).height();
                if(scrollTop + windowHeight == scrollHeight){
                    var params = {
                        pn:pn++,
                        pnSize:pnSize,
                        id:${current_id}
                    };
                    $.ajax({
                        url:"/user/get/more",
                        type:"post",
                        data:params,
                        success:function (d) {
                            /* 将数据回显上去 */
                            var listMd = d.data;
                            console.log(listMd)
                            $(listMd).each(function (index,value) {
                                var md = "<div id=\"layout\">\n" +
                                    "                                    <!-- 拆分1 -->\n" +
                                    "                                    <div class=\"table-fa blog-1\">\n" +
                                    "                                        <table class=\"table\" style=\"background-color: white\">\n" +
                                    "                                            <tr>\n" +
                                    "                                                <td class=\"styleShow show-1\"></td>\n" +
                                    "                                                <td></td>\n" +
                                    "                                                <td style=\"text-align: right\" class=\"styleShow\"><a href=\"\" class=\"show-2\"></a></td>\n" +
                                    "                                            </tr>\n" +
                                    "                                            <tr>\n" +
                                    "                                                <td><a href=\"\"><img class=\"avatar show-3\" src=\"{post.user.avatar}\" alt=\"\"> <span class=\"show-7\"></span></a></td>\n" +
                                    "                                                <td></td>\n" +
                                    "                                                <td style=\"font-size: 20px;text-align: right\" class=\"show-4\"></td>\n" +
                                    "                                            </tr>\n" +
                                    "                                            <tr>\n" +
                                    "                                                <td colspan=\"3\"><div id=\"22\" class=\"div-blog show-6\"><textarea style=\"\" class=\"show-5\"></textarea> </div></td>\n" +
                                    "                                            </tr>\n" +
                                    "                                        </table>\n" +
                                    "                                    </div>\n" +
                                    "                                </div>";
                                $(".pe-blog").append(md);
                                var latL = $(".pe-blog").children(":last-child");
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
        $(".item-click").each(function (index,value) {
            console.log(value);
            $(value).click(function () {
                $(".item-show").each(function (j,val) {
                    console.log($(val).css("display"));
                    if(index != j){
                        $(val).css("display","none");
                    }else {
                        $(val).css("display","block");
                        if(index != 0)ok = true;
                        else ok = false;
                        if(index == 1)f1(1);
                    }
                })
            })
        });
        function f1(pn) {
            console.log("博客部分");
            /* 显示和列表 */
            /*
            * <tr>
                                        <th scope="row">4</th>
                                        <td>spring学习笔记四</td>
                                        <td>2022-04-02 10:23:00</td>
                                        <td>112</td>
                                    </tr>
            * */
            var params = {
                pn:pn,
                pnSize:10,
                id:${current_id}
            };
            $.ajax({
                url:"/user/f1",
                type:"post",
                data:params,
                success:function (d) {
                    //分页等数据都在这里
                    console.log(d);
                },
                dataType:"json"
            });
        }
    </script>
</@nav>