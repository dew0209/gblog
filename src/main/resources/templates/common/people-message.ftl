<#macro perseonMessage current_user nums>
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
                <div style="text-align: right">${current_user.status}</div>
            </li>
            <li class="list-group-item p-in-fa" style="width: 140px;height: 140px">
                <div class="p-in">
                    <a href=""><img style="width: 40px;height: 40px" src="/images/xue.png" alt="..." class="img-rounded"></a>
                </div>
                <div class="p-in">
                    <a href=""><img style="width: 40px;height: 40px" src="/images/xue.png" alt="..." class="img-rounded"></a>
                </div>
                <div class="p-in">
                    <a href=""><img style="width: 40px;height: 40px" src="/images/xue.png" alt="..." class="img-rounded"></a>
                </div>
                <div class="p-in">
                    <a href=""><img style="width: 40px;height: 40px" src="/images/xue.png" alt="..." class="img-rounded"></a>
                </div>
                <div class="p-in">
                    <a href=""><img style="width: 40px;height: 40px" src="/images/xue.png" alt="..." class="img-rounded"></a>
                </div>
                <div class="p-in">
                    <a href=""><img style="width: 40px;height: 40px" src="/images/xue.png" alt="..." class="img-rounded"></a>
                </div>
                <div class="p-in">
                    <a href=""><img style="width: 40px;height: 40px" src="/images/xue.png" alt="..." class="img-rounded"></a>
                </div>
                <div class="p-in">
                    <a href=""><img style="width: 40px;height: 40px" src="/images/xue.png" alt="..." class="img-rounded"></a>
                </div>
                <div class="p-in">
                    <a href=""><img style="width: 40px;height: 40px" src="/images/xue.png" alt="..." class="img-rounded"></a>
                </div>
            </li>
        </ul>
    </div>
</#macro>