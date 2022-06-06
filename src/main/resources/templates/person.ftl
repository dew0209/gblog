<#include "/common/nav.ftl"/>
<@nav "个人空间">
    <style>
        .aba {
            margin-bottom: 10px;
        }
        .show-area {
            width: 600px;
            height: 260px;
            overflow: scroll;
        }
    </style>
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
                        <#--<div><span>关注数：</span> ${nums.focusNum} </div>-->
                        <div><span>阅读量：</span> ${nums.readingNum} </div>
                        <#--<div><span>粉丝数：</span> ${nums.fansNum} </div>-->
                        <div style="text-align: right">
                            <@shiro.hasRole name="suadmin">
                                <span class="delete-post">
                                    <#-- 封禁用户 -->
                                    <#if blogSt == 0>
                                        <form action="/user/s1/" method="post">
                                            <input type="hidden" name="id" width="0" height="0" value="${current_user.id}">
                                            <button type="submit" href="" class="btn btn-info  danger-user">禁用用户</button>
                                        </form>
                                    </#if>
                                    <#if blogSt != 0>
                                        <form action="/user/u1/" method="post">
                                            <input type="hidden" name="id" width="0" height="0" value="${current_user.id}">
                                        <button type="submit" class="btn btn-danger  danger-user">恢复封禁</button>
                                        </form>

                                    </#if>
                                    <#-- 禁用写博客 -->
                                    <#if blogNopay == 0>
                                        <form action="/user/s2/" method="post">
                                            <input type="hidden" name="id" value="${current_user.id}">
                                            <button type="submit"  class="btn btn-info s danger-user">禁用博客</button>
                                        </form>
                                    </#if>
                                    <#if blogNopay != 0>
                                        <form action="/user/u2/" method="post">
                                            <input type="hidden" name="id" value="${current_user.id}">
                                            <button type="submit"  class="btn btn-danger s danger-user">禁用博客</button>
                                        </form>
                                    </#if>
                                    <#-- 禁用付费 -->
                                    <#if blogPay == 0>
                                        <form action="/user/s3/" method="post">
                                            <input type="hidden" width="0" height="0" name="id" value="${current_user.id}">
                                            <button type="submit"  class="btn btn-info  danger-user">禁用付费</button>
                                        </form>
                                    </#if>
                                    <#if blogPay != 0>
                                        <form action="/user/u3/" method="post">
                                            <input type="hidden" width="0" height="0" name="id" value="${current_user.id}">
                                            <button type="submit"  class="btn btn-danger  danger-user">恢复付费</button>
                                        </form>
                                    </#if>
                                </span>
                            </@shiro.hasRole>
                            <button type="button" class="btn btn-info send-mess">发消息</button>
                            <script>

                                var ws =  new WebSocket('ws://localhost:8080/chatLJ');

                                //websocket交互
                                //建立连接后触发
                                ws.onopen = function () {
                                    console.log("建立连结");
                                };

                                //接收到服务端的推送后触发
                                ws.onmessage = function (evt) {
                                    console.log(evt.data);
                                    var resJson = JSON.parse(evt.data);
                                    console.log(resJson.fromUser)
                                    $("div[idex-id="+resJson.fromUser+"]").append("<div align=\"left\"  class='aba'>"+resJson.message+"</div>");
                                    $("div[idex-id="+resJson.fromUser+"]").scrollTop($("div[idex-id="+resJson.fromUser+"]").prop("scrollHeight"));
                                };
                                //关闭连接触发
                                ws.onclose = function () {};
                                function sendMess(a,obj){
                                    //发送数据给服务端
                                    var sendJson = {"toId": a, "message": $(obj).parent().find("textarea").val(),id:<@shiro.principal property="id"/>};
                                    ws.send(JSON.stringify(sendJson));
                                    $("div[idex-id="+a+"]").append("<div align=\"right\"  class='aba'>"+$(obj).parent().find("textarea").val()+"</div>");
                                    $(obj).parent().find("textarea").val("")
                                    $("div[idex-id="+a+"]").scrollTop($("div[idex-id="+a+"]").prop("scrollHeight"));
                                }
                                var okFlag = false;
                                $(function () {
                                    $(".send-mess").click(function () {
                                        //
                                        var params ={
                                            id:${current_user.id}
                                        }
                                        var url = "/chat/mess";
                                        $.ajax({
                                            url:url,
                                            type:"post",
                                            data:params,
                                            success:function (d) {
                                                /**
                                                 *
                                                 * 点发消息获取当前用户所有的会话列表
                                                 * 点击单独的人，获取历史聊天记录，按时间排序[只展示最新五条]
                                                 *
                                                 *
                                                 * */
                                                $(".chat-lianxiren").find(".list-group").empty();
                                                $(".chat-body").find(".list-group").empty();
                                                console.log(d);
                                                for(var i = 0;i < d.data.length;i++){
                                                    console.log(d.data[i].id);
                                                    //拼接参数和聊天框
                                                    var str = "";
                                                    var str_mess = "";

                                                    str = "<li class=\"list-group-item chat-click\">\n" +
                                                        "                                <img src=\""+d.data[i].avatar+"\" alt=\"\">\n" +
                                                        "                                <span style=\"margin-left: 10px\">"+ d.data[i].username +"</span>\n" +
                                                        "                            </li>";
                                                    str_mess = "<li class=\"list-group-item chat-show\">\n" +
                                                        "                                <div class=\"show-area\" idex-id = '"+ d.data[i].id +"'></div>\n" +
                                                        "                                <textarea class=\"form-control\" rows=\"3\"></textarea>\n" +
                                                        "                                <button type=\"button\" class=\"btn btn-info\" onclick='sendMess("+d.data[i].id+",this)'>发送</button>\n" +
                                                        "                            </li>";

                                                    $(".chat-lianxiren").find(".list-group").append(str);
                                                    $(".chat-body").find(".list-group").append(str_mess);
                                                }
                                                $(".chat-click").each(function (index,value) {
                                                    console.log(value);
                                                    $(value).click(function () {
                                                        console.log(value);
                                                        $(".chat-show").each(function (j,val) {
                                                            console.log($(val).css("display"));
                                                            if(index != j){
                                                                $(val).css("display","none");
                                                            }else {
                                                                $(val).css("display","block");
                                                                /* 正确的tab切换 */
                                                                //获取聊天记录？ 等会在写，触发请求进行获取历史聊天记录
                                                                getHisMess(val,d.data[index]);
                                                            }
                                                        })
                                                    })
                                                });
                                                console.log("启动聊天页面")
                                                console.log(document.querySelector('.chat-fa'));
                                                document.querySelector('.chat-fa').style.display = 'block';
                                            },
                                            dataType:"json"
                                        })
                                    });
                                    function getHisMess(val,personObj) {
                                        //获取信息
                                        //只获取最近十条记录
                                        $(val).find(".show-area").empty();
                                        console.log(val);
                                        console.log(personObj);
                                        var params = {
                                          id:personObj.id
                                        };
                                        $.ajax({
                                            url: "/chat/his",
                                            type: "post",
                                            data: params,
                                            success: function (d) {
                                                //获取到最近十条的聊天记录
                                                console.log(d);
                                                debugger
                                                for(var i = 0;i < d.data.length;i++){
                                                    if(d.data[i].loc == "1"){
                                                        $(val).find(".show-area").append("<div align=\"left\" class='aba'>"+d.data[i].mess+"</div>")
                                                    }else {
                                                        $(val).find(".show-area").append("<div align=\"right\"  class='aba'>"+d.data[i].mess+"</div>")

                                                    }
                                                }

                                            }
                                        })
                                    }
                                })
                            </script>
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
                        <li class="item-click"><a href="#">订单</a></li>


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
                                                <#if post.content??>
                                                    <td style="text-align: right" class="styleShow"><a href="/post/blog/${post.id}" class="show-2">${post.title}</a></td>
                                                <#else>
                                                    <td style="text-align: right" class="styleShow"><a href="/yui/post/blog/${post.id}" class="show-2">${post.title}</a></td>
                                                </#if>

                                            </tr>
                                            <tr>

                                                <td><a href="/user/${post.user.id}"><img class="avatar show-3" src="${post.user.avatar}" alt=""> <span class="show-7">${post.user.username}</span></a></td>
                                                <td></td>
                                                <td style="font-size: 20px;text-align: right" class="show-4">${post.created?string('MM/dd/yyyy, HH:mm:ss')}</td>
                                            </tr>
                                            <tr>
                                                <#-- 付费显示介绍，文章显示内容 -->
                                                <#if post.content??>
                                                    <td colspan="3"><div id="editormd-view-${post.id}" class="div-blog"><textarea style="" class="show-5">${post.content}</textarea> </div></td>
                                                <#else>
                                                    <td colspan="3"><div id="editormd-view-${post.id}" class="div-blog"><textarea style="" class="show-5">${post.introduce}</textarea> </div></td>
                                                </#if>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                </#list>
                            </div>
                        </li>
                        <li class="item-show">
                            <!-- 标题           时间   阅读量  （按时间进行排序）-->
                            <table class="table table-striped table-blog">
                                <thead>
                                    <tr>
                                        <th scope="row">#</th>
                                        <th>标题</th>
                                        <th>时间</th>
                                        <th>阅读量</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <#-- 展示 js数据回显的时候进行展示 -->
                                </tbody>
                            </table>
                            <div align="right">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination pagination-blog-fa" style="margin-right: 5px">
                                        <li>
                                            <a href="#" aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                        <li class="blog-pagination">
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
                            <table class="table table-striped table-pay">
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
                                    <ul class="pagination pagination-pay-fa" style="margin-right: 5px">
                                        <li>
                                            <a href="#" aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                        <li class="pay-pagination">
                                            <a href="#" aria-label="Next">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>

                            <div align="right" style="margin: 5px">
                                <#-- ${current_user.id} -->
                                <#if isOwen != 1>
                                    <button type="button" class="get-money btn btn-info">结算收益</button>
                                    <#--
                                        整收益的
                                    -->
                                    <script>

                                        $(".get-money").click(function () {
                                            var par = prompt("请输入您的支付宝账号/姓名");
                                            console.log(par);
                                            var params = {"par":par};
                                            $.ajax({
                                                url:"/yui/getMon",
                                                type:"post",
                                                data:params,
                                                success:function (d) {
                                                    alert("收到！系统将为您计算收益后转账，如需修改账号/姓名，请多次提交请求即可")
                                                },
                                                dataType:"json"
                                            });
                                        });
                                    </script>
                                </#if>
                            </div>
                        </li>
                        <li class="item-show">
                            <!--
                                类型	标题	作者	日期	阅读	删除
                            -->
                            <table class="table table-striped table-coll">
                                <thead>
                                <tr>
                                    <th scope="row">#</th>
                                    <th>类型</th>
                                    <th>标题</th>
                                    <th>作者</th>
                                    <th>日期</th>

                                </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>

                            <div align="right">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination pagination-coll-fa" style="margin-right: 5px">
                                        <li>
                                            <a href="#" aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>

                                        <li class="coll-pagination">
                                            <a href="#" aria-label="Next">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </li>
                        <li class="item-show">
                            <!--
                                类型	标题	作者	日期	阅读	删除
                            -->
                            <table class="table table-striped table-coll">
                                <thead>
                                <tr>
                                    <th scope="row">#</th>
                                    <th>类型</th>
                                    <th>标题</th>
                                    <th>作者</th>
                                    <th>日期</th>

                                </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>

                            <div align="right">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination pagination-coll-fa" style="margin-right: 5px">
                                        <li>
                                            <a href="#" aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>

                                        <li class="coll-pagination">
                                            <a href="#" aria-label="Next">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </li>
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
                                if(value.type.id==2){
                                    latL.find(".show-2").attr("href","/yui/post/blog/" + value.id);
                                }else {
                                    latL.find(".show-2").attr("href","/post/blog/" + value.id);
                                }
                                latL.find(".show-3").attr("src",value.user.avatar);
                                latL.find(".show-7").text(value.user.username);
                                latL.find(".show-4").html(new Date(value.created).toLocaleString("en-US", {hour12: false}));
                                if(value.type.id==2){
                                    latL.find(".show-5").html(value.introduce);
                                }else {
                                    latL.find(".show-5").html(value.content);
                                }
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
                        if(index == 1)f1(1);//博客
                        if(index == 2)f2(1);//付费
                        if(index == 3)f3(1);//收藏
                        if(index == 4)f4(1);//收藏

                    }
                })
            })
        });

        function f4(pn) {
            console.log("订单部分");
            //清空数据
            $(".table-coll").find("tbody").children().remove();
            //清空分页
            $(".pagination-coll-fa").children(".paging-btn").remove();
            var params = {
                pn:pn,
                pnSize:10,
                id:${current_id}
            };
            $.ajax({
                url:"/user/f4",
                type:"post",
                data:params,
                success:function (d) {
                    //分页等数据都在这里
                    console.log(d);
                    //回显分页
                    for(var i = 1;i <= d.data.totalPage;i++){
                        console.log("处理分页");
                        var eleStr = "";
                        if(i == d.data.currPage){
                            eleStr = "<li class=\"active paging-btn\"><a href=\"JavaScript:f3("+i+")\" >"+i+"</a></li>"

                        }else {
                            eleStr = "<li class=\"paging-btn\"><a href=\"JavaScript:f3("+i+")\" >"+i+"</a></li>";
                        }
                        $(".coll-pagination").before(eleStr);
                    }

                    /*
                    *
                    *
                    * <th scope="row">1</th>
                                    <td>博客</td>
                                    <td>spring学习笔记</td>
                                    <td>godx</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td><a href="#">删除</a></td>
                    * */
                    //回显数据
                    for(var i = 0;i < d.data.list.length;i++){

                        console.log(d.data.list[i].postId);
                        if(d.data.list[i].typeName == "博客"){
                            //创建元素
                            var eleTr = "<tr>\n" +
                                "                                        <th scope=\"row\">"+ ((pn - 1)* 10 + (i + 1))+"</th>\n" +
                                "                                        <td>"+d.data.list[i].typeName+"</td>\n" +
                                "                                        <td><a href='/post/blog/" + d.data.list[i].postId + "'>"+d.data.list[i].title+"</a></td>\n" +
                                "                                        <td><a href='/user/"+ d.data.list[i].userId +"'>"+d.data.list[i].username+"</a></td>\n" +
                                "                                        <td>"+new Date(d.data.list[i].date).toLocaleString("en-US", {hour12: false})+"</td>\n" +
                                "                                    </tr>"
                            $(".table-coll").find("tbody").append(eleTr);
                        }else {
                            //创建元素
                            var eleTr = "<tr>\n" +
                                "                                        <th scope=\"row\">"+ ((pn - 1)* 10 + (i + 1))+"</th>\n" +
                                "                                        <td>"+d.data.list[i].typeName+"</td>\n" +
                                "                                        <td><a href='/yui/post/blog/" + d.data.list[i].postId + "'>"+d.data.list[i].title+"</a></td>\n" +
                                "                                        <td><a href='/user/"+ d.data.list[i].userId +"'>"+d.data.list[i].username+"</a></td>\n" +
                                "                                        <td>"+new Date(d.data.list[i].date).toLocaleString("en-US", {hour12: false})+"</td>\n" +
                                "                                    </tr>"
                            $(".table-coll").find("tbody").append(eleTr);
                        }
                    }

                },
                dataType:"json"
            });
        }

        function f3(pn) {
            console.log("收藏部分");
            //清空数据
            $(".table-coll").find("tbody").children().remove();
            //清空分页
            $(".pagination-coll-fa").children(".paging-btn").remove();
            var params = {
                pn:pn,
                pnSize:10,
                id:${current_id}
            };
            $.ajax({
                url:"/user/f3",
                type:"post",
                data:params,
                success:function (d) {
                    //分页等数据都在这里
                    console.log(d);
                    //回显分页
                    for(var i = 1;i <= d.data.totalPage;i++){
                        console.log("处理分页");
                        var eleStr = "";
                        if(i == d.data.currPage){
                            eleStr = "<li class=\"active paging-btn\"><a href=\"JavaScript:f3("+i+")\" >"+i+"</a></li>"

                        }else {
                            eleStr = "<li class=\"paging-btn\"><a href=\"JavaScript:f3("+i+")\" >"+i+"</a></li>";
                        }
                        $(".coll-pagination").before(eleStr);
                    }

                    /*
                    *
                    *
                    * <th scope="row">1</th>
                                    <td>博客</td>
                                    <td>spring学习笔记</td>
                                    <td>godx</td>
                                    <td>2022-04-02 10:23:00</td>
                                    <td><a href="#">删除</a></td>
                    * */
                    //回显数据
                    for(var i = 0;i < d.data.list.length;i++){

                        console.log(d.data.list[i].postId);
                        if(d.data.list[i].typeName == "博客"){
                            //创建元素
                            var eleTr = "<tr>\n" +
                                "                                        <th scope=\"row\">"+ ((pn - 1)* 10 + (i + 1))+"</th>\n" +
                                "                                        <td>"+d.data.list[i].typeName+"</td>\n" +
                                "                                        <td><a href='/post/blog/" + d.data.list[i].postId + "'>"+d.data.list[i].title+"</a></td>\n" +
                                "                                        <td><a href='/user/"+ d.data.list[i].userId +"'>"+d.data.list[i].username+"</a></td>\n" +
                                "                                        <td>"+new Date(d.data.list[i].date).toLocaleString("en-US", {hour12: false})+"</td>\n" +
                                "                                    </tr>"
                            $(".table-coll").find("tbody").append(eleTr);
                        }else {
                            //创建元素
                            var eleTr = "<tr>\n" +
                                "                                        <th scope=\"row\">"+ ((pn - 1)* 10 + (i + 1))+"</th>\n" +
                                "                                        <td>"+d.data.list[i].typeName+"</td>\n" +
                                "                                        <td><a href='/yui/post/blog/" + d.data.list[i].postId + "'>"+d.data.list[i].title+"</a></td>\n" +
                                "                                        <td><a href='/user/"+ d.data.list[i].userId +"'>"+d.data.list[i].username+"</a></td>\n" +
                                "                                        <td>"+new Date(d.data.list[i].date).toLocaleString("en-US", {hour12: false})+"</td>\n" +
                                "                                    </tr>"
                            $(".table-coll").find("tbody").append(eleTr);
                        }
                    }

                },
                dataType:"json"
            });
        }
        function f2(pn) {
            console.log("付费部分");
            //处理付费部分的逻辑
            //清空数据
            $(".table-pay").find("tbody").children().remove();
            //清空分页
            $(".pagination-pay-fa").children(".paging-btn").remove();
            //获取数据
            var params = {
                pn:pn,
                pnSize:10,
                id:${current_id}
            };
            $.ajax({
                url:"/user/f2",
                type:"post",
                data:params,
                success:function (d) {
                    //分页等数据都在这里
                    console.log(d);
                    //回显分页
                    for(var i = 1;i <= d.data.totalPage;i++){
                        console.log("处理分页");
                        var eleStr = "";
                        if(i == d.data.currPage){
                            eleStr = "<li class=\"active paging-btn\"><a href=\"JavaScript:f2("+i+")\" >"+i+"</a></li>"

                        }else {
                            eleStr = "<li class=\"paging-btn\"><a href=\"JavaScript:f2("+i+")\" >"+i+"</a></li>";
                        }
                        $(".pay-pagination").before(eleStr);
                    }
                    //回显数据
                    for(var i = 0;i < d.data.list.length;i++){
                        console.log(d.data.list[i].title);
                        //创建元素
                        var eleTr = "<tr>\n" +
                            "                                        <th scope=\"row\">"+ ((pn - 1)* 10 + (i + 1))+"</th>\n" +
                            "                                        <td><a href='/yui/post/blog/" + d.data.list[i].id + "'>"+d.data.list[i].title+"</a></td>\n" +
                            "                                        <td>"+new Date(d.data.list[i].date).toLocaleString("en-US", {hour12: false})+"</td>\n" +
                            "                                        <td>"+d.data.list[i].getNum + '/' + d.data.list[i].allNum +"</td>\n" +
                            "                                    </tr>"
                        $(".table-pay").find("tbody").append(eleTr);
                    }

                },
                dataType:"json"
            });
        }
        function f1(pn) {
            console.log("博客部分");
            //清空数据
            $(".table-blog").find("tbody").children().remove();
            //请空分页
            $(".pagination-blog-fa").children(".paging-btn").remove();
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
                id:${current_id} /* 用户id */
            };
            $.ajax({
                url:"/user/f1",
                type:"post",
                data:params,
                success:function (d) {
                    //分页等数据都在这里
                    console.log(d);
                    //回显分页
                    for(var i = 1;i <= d.data.totalPage;i++){
                        console.log("处理分页");
                        var eleStr = "";
                        if(i == d.data.currPage){
                            eleStr = "<li class=\"active paging-btn\"><a href=\"JavaScript:f1("+i+")\" >"+i+"</a></li>"

                        }else {
                            eleStr = "<li class=\"paging-btn\"><a href=\"JavaScript:f1("+i+")\" >"+i+"</a></li>";
                        }
                        $(".blog-pagination").before(eleStr);
                    }
                    //回显数据
                    for(var i = 0;i < d.data.list.length;i++){
                        console.log(d.data.list[i].title);
                        //创建元素
                        var eleTr = "<tr>\n" +
                            "                                        <th scope=\"row\">"+ ((pn - 1)* 10 + (i + 1))+"</th>\n" +
                            "                                        <td><a href='/post/blog/" + d.data.list[i].id + "'>"+d.data.list[i].title+"</a></td>\n" +
                            "                                        <td>"+new Date(d.data.list[i].created).toLocaleString("en-US", {hour12: false})+"</td>\n" +
                            "                                        <td>"+d.data.list[i].viewCount+"</td>\n" +
                            "                                    </tr>"
                        $(".table-blog").find("tbody").append(eleTr);
                    }

                },
                dataType:"json"
            });
        }
    </script>
</@nav>