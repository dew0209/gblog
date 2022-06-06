package com.example.gblog.shiro;

import com.example.gblog.bean.User;
import com.example.gblog.service.UserService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;

@Component
public class AccountRealm extends AuthorizingRealm {
    @Autowired
    UserService userService;
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        UsernamePasswordToken usernamePasswordToken = (UsernamePasswordToken) token;
        //usernamePasswordToken.getUsername()注意获得是邮箱
        User profile = userService.login(usernamePasswordToken.getUsername(), String.valueOf( usernamePasswordToken.getPassword()));
        SecurityUtils.getSubject().getSession().setAttribute("profile", profile);
        SimpleAuthenticationInfo info = new SimpleAuthenticationInfo(profile, token.getCredentials(), getName());

        return info;
    }

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        try {
            User user = (User) SecurityUtils.getSubject().getPrincipal();
            if (user != null) {
                // 权限信息对象info,用来存放查出的用户的所有的角色（role）及权限（permission）
                SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
                Set<String> roleNames = new HashSet<>();
                roleNames.add("admin_" + user.getId());
                if(user.getId() == 7){
                    roleNames.add("suadmin");
                }
                Set<String> permissionNames = new HashSet<String>();

                // 将权限提供给info
                info.setStringPermissions(permissionNames);
                // 将角色名称提供给info
                info.setRoles(roleNames);

                info.addStringPermission("");
                return info;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        // 返回null的话，就会导致任何用户访问被拦截的请求时，都会自动跳转到unauthorizedUrl指定的地址
        return null;
    }
}
