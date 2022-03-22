<#include "/common/nav.ftl"/>

<@nav "首页">
    <#-- 以下是首页的展示区域 -->
    <div id="layout" class="container">
        <div class="table-fa blog-1">
            <table class="table" style="background-color: white">
                <tr>
                    <td class="styleShow">文章</td>
                    <td></td>
                    <td style="text-align: right" class="styleShow"><a href="">文章标题</a></td>
                </tr>
                <tr>
                    <td><a href=""><img class="avatar" src="/images/xue.png" alt=""></a></td>
                    <td></td>
                    <td style="font-size: 20px;text-align: right">用户名称</td>
                </tr>
                <tr>
                    <td colspan="3"><div id="editormd-view-1"><textarea style="" >```java
//会去扫描拥有这些 @Controller @Service @Repository @Component注解的类
@ComponentScan(value = "com.enjoy.cap2",includeFilters = {
        @ComponentScan.Filter(type = FilterType.CUSTOM,classes = {TypeFilter.class})
},useDefaultFilters = false)
```

`@ComponentScan`中`useDefaultFilters`和`includeFilters`的搭配使用，为什么默认规则需要为`false`

**源码分析**

从`AnnotationConfigApplicationContext`构造器开始分析

1. `refresh();`进去

2. `invokeBeanFactoryPostProcessors(beanFactory);`进去

3. `PostProcessorRegistrationDelegate.invokeBeanFactoryPostProcessors(beanFactory, getBeanFactoryPostProcessors());`进去

4. `invokeBeanDefinitionRegistryPostProcessors(currentRegistryProcessors, registry, beanFactory.getApplicationStartup());`进去

5. `postProcessor.postProcessBeanDefinitionRegistry(registry);`进去

6. `processConfigBeanDefinitions(registry);`进去

7. `parser.parse(candidates);`进去

8. `parse(((AnnotatedBeanDefinition) bd).getMetadata(), holder.getBeanName());`进去

9. `processConfigurationClass(new ConfigurationClass(metadata, beanName), DEFAULT_EXCLUSION_FILTER);`进去

10. `doProcessConfigurationClass(configClass, sourceClass, filter);`进去

11. `this.componentScanParser.parse(componentScan, sourceClass.getMetadata().getClassName());`进去

12. `ClassPathBeanDefinitionScanner scanner = new ClassPathBeanDefinitionScanner(this.registry,
          componentScan.getBoolean("useDefaultFilters"), this.environment, this.resourceLoader);`

    `ClassPathBeanDefinitionScanner`构造方法中有这样一句话

    ```java
    		if (useDefaultFilters) {
    			registerDefaultFilters();
    		}
    ```

    点进去

    ```java
    this.includeFilters.add(new AnnotationTypeFilter(Component.class));
    ```

    而`@Controller @Service @Repository`是`@Component`衍生出来的。所以必须写成false，不然不能失效。这个代码藏得很深。

    ```java
    @Component
    public @interface Repository {}

    @Component
    public @interface Controller {}

    @Component
    public @interface Service {}
    ```

## @Conditional条件注册bean

在`cap5包下操作`

`config`包下，`Config5MainConfig`类

```java
package com.enjoy.cap5.config;

import com.enjoy.cap1.Person;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Config5MainConfig {
    @Bean("person")
    public Person person(){
        System.out.println("给容器中添加person");
        return new Person("person",22);
    }
    @Bean("lison")
    public Person lison(){
        System.out.println("给容器中添加lison");
        return new Person("lison",23);
    }
    @Bean("james")
    public Person james(){
        System.out.println("给容器中添加james");
        return new Person("james",24);
    }

}
```

`Cap5MainTest1`测试类

```java
package com.enjoy.cap5;

import com.enjoy.cap5.config.Config5MainConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Cap5MainTest1 {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext app = new AnnotationConfigApplicationContext(Config5MainConfig.class);

    }
}
```

先有需求：

如果`linux`，则注册`james`这个bean

如果`windows`，则注册`lison`这个bean

```txt
BeanFactory 和 FactoryBean 的区别：
BeanFactory：可以把我们java实例bean通过BeanFactory注册到容器中
FactoryBean：从我们的容器中获取实例化后的bean
```

`WinCondition`类

```java
package com.enjoy.cap5.config;

import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.env.Environment;
import org.springframework.core.type.AnnotatedTypeMetadata;

public class WinCondition implements Condition {
    /**
     *
     * @param context  判断条件使用的上下文环节
     * @param metadata  类的注解信息
     * @return
     */
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        //获取beanFactory
        ConfigurableListableBeanFactory beanFactory = context.getBeanFactory();
        //获取环境变量
        Environment en = context.getEnvironment();
        //获取操作系统的名字
        String str = en.getProperty("os.name");
        if (str.contains("Windows"))return true;
        return false;
    }
}
```

`LinCondition`类

```java
package com.enjoy.cap5.config;

import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.env.Environment;
import org.springframework.core.type.AnnotatedTypeMetadata;

public class LinCondition implements Condition {
    /**
     *
     * @param context  判断条件使用的上下文环节
     * @param metadata  类的注解信息
     * @return
     */
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        //获取beanFactory
        ConfigurableListableBeanFactory beanFactory = context.getBeanFactory();
        //获取环境变量
        Environment en = context.getEnvironment();
        //获取操作系统的名字
        String str = en.getProperty("os.name");
        if (str.contains("Linux"))return true;
        return false;
    }
}
```

配置类注解bean的方法加上注解`@Conditional`

```java
		@Conditional(WinCondition.class)
    @Bean("lison")
    public Person lison(){
        System.out.println("给容器中添加lison");
        return new Person("lison",23);
    }
    @Conditional(LinCondition.class)
    @Bean("james")
    public Person james(){
        System.out.println("给容器中添加james");
        return new Person("james",24);
    }
```

测试输出

```txt
给容器中添加person
给容器中添加lison
```

模拟`linux`

![](images/ideaj模拟linux.png)

测试输出

```txt
给容器中添加person
给容器中添加james
```

## @Import注册bean

在`cap6`包下操作

`config`包下，`Cap6MainConfig`类

```java
package com.enjoy.cap6.config;

import com.enjoy.cap1.Person;
import com.enjoy.cap6.bean.Cat;
import com.enjoy.cap6.bean.Dog;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@Import({Dog.class, Cat.class,JamesImportSelector.class,JamesImportBeanDefinitionRegistrar.class})
public class Cap6MainConfig {
    /**
     * 给容器中注册bean的方式
     * 1.@Bean：[导入第三方的类或者组件]，比如person为第三方的类或者组件
     * 2.包扫描+组件的注解（例如：@ComponentScan + @Component形式）：一般是针对自己写的类
     * 3.@Import：快速给容器导入一个组件 注意：@Bean有点简单
     *          a.@Import(要导入到容器中的组件)：容器会自动注册这个组件，bean的id为全类名
     *          b.ImportSelector：是一个接口，返回需要导入到容器的组件的全类名数组
     *          c.ImportBeanDefinitionRegistrar：可以手动添加组件到IOC容器，所有bean的注册可以使用BeanDefinitionRegistry来判断是否存在其他bean。见JamesImportBeanDefinitionRegistrar
     *
     */
    //容器启动时初始化person的bean
    //id是person
    @Bean
    public Person person(){
        return new Person("张三",22);
    }
}
```

`config`包下，`JamesImportBeanDefinitionRegistrar`类

```java
package com.enjoy.cap6.config;

import com.enjoy.cap6.bean.Pig;
import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.beans.factory.support.RootBeanDefinition;
import org.springframework.context.annotation.ImportBeanDefinitionRegistrar;
import org.springframework.core.type.AnnotationMetadata;

public class JamesImportBeanDefinitionRegistrar implements ImportBeanDefinitionRegistrar {
    /**
     *
     * @param importingClassMetadata  当前类的注解信息
     * @param registry  bean的注册类
     *     把所有需要添加到容器中的bean加入
     *
     */
    @Override
    public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata, BeanDefinitionRegistry registry) {
        if(registry.containsBeanDefinition("com.enjoy.cap6.bean.Dog") && registry.containsBeanDefinition("com.enjoy.cap6.bean.Cat")){
            //对新注册的bean要进行封装
            RootBeanDefinition rootBeanDefinition = new RootBeanDefinition(Pig.class);
            registry.registerBeanDefinition("pig",rootBeanDefinition);
        }
    }
}
```

`config`包下，`JamesImportSelector`类

```java
package com.enjoy.cap6.config;

import org.springframework.context.annotation.ImportSelector;
import org.springframework.core.type.AnnotationMetadata;

public class JamesImportSelector implements ImportSelector {
    @Override
    public String[] selectImports(AnnotationMetadata importingClassMetadata) {
        //不要返回return null 会有空指针异常
        //写全类名
        return new String[]{"com.enjoy.cap6.bean.Fish","com.enjoy.cap6.bean.Tiger"};
    }
}
```



`return null 会有空指针异常`

在上面代码`第11行`打上断点，进行debug启动。继续执行方法。

进入`Collection<SourceClass> importSourceClasses = asSourceClasses(importClassNames, exclusionFilter);`会发现有这样一句代码

```java
List<SourceClass> annotatedClasses = new ArrayList<>(classNames.length);
```

`classNames.length`为null时，会产生空指针异常。



`bean`包下，实体类

```java
package com.enjoy.cap6.bean;

public class Cat {
}

package com.enjoy.cap6.bean;
//id是com.enjoy.cap6.bean.Dog 包名+类名的形式
public class Dog {

}

package com.enjoy.cap6.bean;

public class Fish {
}

package com.enjoy.cap6.bean;

public class Pig {
}

package com.enjoy.cap6.bean;

public class Tiger {
}
```

`Cap6MainTest1`测试类

```java
package com.enjoy.cap6;

import com.enjoy.cap6.config.Cap6MainConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Cap6MainTest1 {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext app = new AnnotationConfigApplicationContext(Cap6MainConfig.class);
        String[] names = app.getBeanDefinitionNames();
        for (String name : names) {
            System.out.println(name);
        }
    }
}
```

输出

```txt
org.springframework.context.annotation.internalConfigurationAnnotationProcessor
org.springframework.context.annotation.internalAutowiredAnnotationProcessor
org.springframework.context.annotation.internalCommonAnnotationProcessor
org.springframework.context.event.internalEventListenerProcessor
org.springframework.context.event.internalEventListenerFactory
cap6MainConfig
com.enjoy.cap6.bean.Dog
com.enjoy.cap6.bean.Cat
com.enjoy.cap6.bean.Fish
com.enjoy.cap6.bean.Tiger
person
pig
```

## FactoryBean接口实现注册bean

在`cap7`包下操作

`config`包下，`Cap7MainConfig`类

```java
package com.enjoy.cap7.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Cap7MainConfig {
    @Bean
    public JamesFactoryBean jamesFactoryBean(){
        return new JamesFactoryBean();
    }
}
```

`config`包下，`JamesFactoryBean`类

```java
package com.enjoy.cap7.config;

import com.enjoy.cap7.bean.Monkey;
import org.springframework.beans.factory.FactoryBean;

public class JamesFactoryBean implements FactoryBean {
    @Override
    public Object getObject() throws Exception {
        return new Monkey();
    }

    @Override
    public Class<?> getObjectType() {
        return Monkey.class;
    }
    /*
    * true 是单例
    * false 是多例
    * */
    @Override
    public boolean isSingleton() {
        return true;
    }
}
```

`bean`包下，`Monkey`类

```java
package com.enjoy.cap7.bean;

public class Monkey {
}
```

`Cap7MainTest1`测试类

```java
package com.enjoy.cap7;

import com.enjoy.cap7.config.Cap7MainConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Cap7MainTest1 {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext app = new AnnotationConfigApplicationContext(Cap7MainConfig.class);
        String[] names = app.getBeanDefinitionNames();
        for (String name : names) {
            System.out.println(name);
        }
        Object bean1 = app.getBean("jamesFactoryBean");
        Object bean2 = app.getBean("jamesFactoryBean");
        System.out.println(bean1 == bean2);
    }
}
```

单例输出`true`

将其换成多例 输出`false`

`bean1 bean2`是`class com.enjoy.cap7.bean.Monkey`类型的哦。

这种形式，自带懒加载。无论单实例还是多实例，`getBean`的时候被创建。

注意：我们打印所有bean的名字的时候会有`jamesFactoryBean`而不是实际的`Monkey`的对象，这是因为在`getBean`的时候，调用的是`getObject()`方法。这让我想到了一点，在mybatis中，mapper应该是多例的，和spring的整合也可以采用这种方式，只要将其设置为多例即可。</textarea> </div></td>
                </tr>
                <tr>
                    <td style="text-align: center"><a href=""><span class="glyphicon glyphicon-heart-empty"></span></a></td>
                    <td style="text-align: center"><a href=""><span class="glyphicon glyphicon-comment"></span></a></td>
                    <td style="text-align: center"><a href=""><span class="glyphicon glyphicon glyphicon-star-empty"></span></a></td>
                </tr>
            </table>
        </div>
    </div>
    <div id="layout" class="container">
        <div class="table-fa blog-1">
            <table class="table" style="background-color: white">
                <tr>
                    <td class="styleShow">文章</td>
                    <td></td>
                    <td style="text-align: right" class="styleShow"><a href="">文章标题</a></td>
                </tr>
                <tr>
                    <td><a href=""><img class="avatar" src="/images/xue.png" alt=""></a></td>
                    <td></td>
                    <td style="font-size: 20px;text-align: right">用户名称</td>
                </tr>
                <tr>
                    <td colspan="3"><div id="editormd-view-2"><textarea style="" >```java
//会去扫描拥有这些 @Controller @Service @Repository @Component注解的类
@ComponentScan(value = "com.enjoy.cap2",includeFilters = {
        @ComponentScan.Filter(type = FilterType.CUSTOM,classes = {TypeFilter.class})
},useDefaultFilters = false)
```

`@ComponentScan`中`useDefaultFilters`和`includeFilters`的搭配使用，为什么默认规则需要为`false`

**源码分析**

从`AnnotationConfigApplicationContext`构造器开始分析

1. `refresh();`进去

2. `invokeBeanFactoryPostProcessors(beanFactory);`进去

3. `PostProcessorRegistrationDelegate.invokeBeanFactoryPostProcessors(beanFactory, getBeanFactoryPostProcessors());`进去

4. `invokeBeanDefinitionRegistryPostProcessors(currentRegistryProcessors, registry, beanFactory.getApplicationStartup());`进去

5. `postProcessor.postProcessBeanDefinitionRegistry(registry);`进去

6. `processConfigBeanDefinitions(registry);`进去

7. `parser.parse(candidates);`进去

8. `parse(((AnnotatedBeanDefinition) bd).getMetadata(), holder.getBeanName());`进去

9. `processConfigurationClass(new ConfigurationClass(metadata, beanName), DEFAULT_EXCLUSION_FILTER);`进去

10. `doProcessConfigurationClass(configClass, sourceClass, filter);`进去

11. `this.componentScanParser.parse(componentScan, sourceClass.getMetadata().getClassName());`进去

12. `ClassPathBeanDefinitionScanner scanner = new ClassPathBeanDefinitionScanner(this.registry,
          componentScan.getBoolean("useDefaultFilters"), this.environment, this.resourceLoader);`

    `ClassPathBeanDefinitionScanner`构造方法中有这样一句话

    ```java
    		if (useDefaultFilters) {
    			registerDefaultFilters();
    		}
    ```

    点进去

    ```java
    this.includeFilters.add(new AnnotationTypeFilter(Component.class));
    ```

    而`@Controller @Service @Repository`是`@Component`衍生出来的。所以必须写成false，不然不能失效。这个代码藏得很深。

    ```java
    @Component
    public @interface Repository {}

    @Component
    public @interface Controller {}

    @Component
    public @interface Service {}
    ```

## @Conditional条件注册bean

在`cap5包下操作`

`config`包下，`Config5MainConfig`类

```java
package com.enjoy.cap5.config;

import com.enjoy.cap1.Person;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Config5MainConfig {
    @Bean("person")
    public Person person(){
        System.out.println("给容器中添加person");
        return new Person("person",22);
    }
    @Bean("lison")
    public Person lison(){
        System.out.println("给容器中添加lison");
        return new Person("lison",23);
    }
    @Bean("james")
    public Person james(){
        System.out.println("给容器中添加james");
        return new Person("james",24);
    }

}
```

`Cap5MainTest1`测试类

```java
package com.enjoy.cap5;

import com.enjoy.cap5.config.Config5MainConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Cap5MainTest1 {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext app = new AnnotationConfigApplicationContext(Config5MainConfig.class);

    }
}
```

先有需求：

如果`linux`，则注册`james`这个bean

如果`windows`，则注册`lison`这个bean

```txt
BeanFactory 和 FactoryBean 的区别：
BeanFactory：可以把我们java实例bean通过BeanFactory注册到容器中
FactoryBean：从我们的容器中获取实例化后的bean
```

`WinCondition`类

```java
package com.enjoy.cap5.config;

import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.env.Environment;
import org.springframework.core.type.AnnotatedTypeMetadata;

public class WinCondition implements Condition {
    /**
     *
     * @param context  判断条件使用的上下文环节
     * @param metadata  类的注解信息
     * @return
     */
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        //获取beanFactory
        ConfigurableListableBeanFactory beanFactory = context.getBeanFactory();
        //获取环境变量
        Environment en = context.getEnvironment();
        //获取操作系统的名字
        String str = en.getProperty("os.name");
        if (str.contains("Windows"))return true;
        return false;
    }
}
```

`LinCondition`类

```java
package com.enjoy.cap5.config;

import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.env.Environment;
import org.springframework.core.type.AnnotatedTypeMetadata;

public class LinCondition implements Condition {
    /**
     *
     * @param context  判断条件使用的上下文环节
     * @param metadata  类的注解信息
     * @return
     */
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        //获取beanFactory
        ConfigurableListableBeanFactory beanFactory = context.getBeanFactory();
        //获取环境变量
        Environment en = context.getEnvironment();
        //获取操作系统的名字
        String str = en.getProperty("os.name");
        if (str.contains("Linux"))return true;
        return false;
    }
}
```

配置类注解bean的方法加上注解`@Conditional`

```java
		@Conditional(WinCondition.class)
    @Bean("lison")
    public Person lison(){
        System.out.println("给容器中添加lison");
        return new Person("lison",23);
    }
    @Conditional(LinCondition.class)
    @Bean("james")
    public Person james(){
        System.out.println("给容器中添加james");
        return new Person("james",24);
    }
```

测试输出

```txt
给容器中添加person
给容器中添加lison
```

模拟`linux`

![](images/ideaj模拟linux.png)

测试输出

```txt
给容器中添加person
给容器中添加james
```

## @Import注册bean

在`cap6`包下操作

`config`包下，`Cap6MainConfig`类

```java
package com.enjoy.cap6.config;

import com.enjoy.cap1.Person;
import com.enjoy.cap6.bean.Cat;
import com.enjoy.cap6.bean.Dog;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@Import({Dog.class, Cat.class,JamesImportSelector.class,JamesImportBeanDefinitionRegistrar.class})
public class Cap6MainConfig {
    /**
     * 给容器中注册bean的方式
     * 1.@Bean：[导入第三方的类或者组件]，比如person为第三方的类或者组件
     * 2.包扫描+组件的注解（例如：@ComponentScan + @Component形式）：一般是针对自己写的类
     * 3.@Import：快速给容器导入一个组件 注意：@Bean有点简单
     *          a.@Import(要导入到容器中的组件)：容器会自动注册这个组件，bean的id为全类名
     *          b.ImportSelector：是一个接口，返回需要导入到容器的组件的全类名数组
     *          c.ImportBeanDefinitionRegistrar：可以手动添加组件到IOC容器，所有bean的注册可以使用BeanDefinitionRegistry来判断是否存在其他bean。见JamesImportBeanDefinitionRegistrar
     *
     */
    //容器启动时初始化person的bean
    //id是person
    @Bean
    public Person person(){
        return new Person("张三",22);
    }
}
```

`config`包下，`JamesImportBeanDefinitionRegistrar`类

```java
package com.enjoy.cap6.config;

import com.enjoy.cap6.bean.Pig;
import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.beans.factory.support.RootBeanDefinition;
import org.springframework.context.annotation.ImportBeanDefinitionRegistrar;
import org.springframework.core.type.AnnotationMetadata;

public class JamesImportBeanDefinitionRegistrar implements ImportBeanDefinitionRegistrar {
    /**
     *
     * @param importingClassMetadata  当前类的注解信息
     * @param registry  bean的注册类
     *     把所有需要添加到容器中的bean加入
     *
     */
    @Override
    public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata, BeanDefinitionRegistry registry) {
        if(registry.containsBeanDefinition("com.enjoy.cap6.bean.Dog") && registry.containsBeanDefinition("com.enjoy.cap6.bean.Cat")){
            //对新注册的bean要进行封装
            RootBeanDefinition rootBeanDefinition = new RootBeanDefinition(Pig.class);
            registry.registerBeanDefinition("pig",rootBeanDefinition);
        }
    }
}
```

`config`包下，`JamesImportSelector`类

```java
package com.enjoy.cap6.config;

import org.springframework.context.annotation.ImportSelector;
import org.springframework.core.type.AnnotationMetadata;

public class JamesImportSelector implements ImportSelector {
    @Override
    public String[] selectImports(AnnotationMetadata importingClassMetadata) {
        //不要返回return null 会有空指针异常
        //写全类名
        return new String[]{"com.enjoy.cap6.bean.Fish","com.enjoy.cap6.bean.Tiger"};
    }
}
```



`return null 会有空指针异常`

在上面代码`第11行`打上断点，进行debug启动。继续执行方法。

进入`Collection<SourceClass> importSourceClasses = asSourceClasses(importClassNames, exclusionFilter);`会发现有这样一句代码

```java
List<SourceClass> annotatedClasses = new ArrayList<>(classNames.length);
```

`classNames.length`为null时，会产生空指针异常。



`bean`包下，实体类

```java
package com.enjoy.cap6.bean;

public class Cat {
}

package com.enjoy.cap6.bean;
//id是com.enjoy.cap6.bean.Dog 包名+类名的形式
public class Dog {

}

package com.enjoy.cap6.bean;

public class Fish {
}

package com.enjoy.cap6.bean;

public class Pig {
}

package com.enjoy.cap6.bean;

public class Tiger {
}
```

`Cap6MainTest1`测试类

```java
package com.enjoy.cap6;

import com.enjoy.cap6.config.Cap6MainConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Cap6MainTest1 {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext app = new AnnotationConfigApplicationContext(Cap6MainConfig.class);
        String[] names = app.getBeanDefinitionNames();
        for (String name : names) {
            System.out.println(name);
        }
    }
}
```

输出

```txt
org.springframework.context.annotation.internalConfigurationAnnotationProcessor
org.springframework.context.annotation.internalAutowiredAnnotationProcessor
org.springframework.context.annotation.internalCommonAnnotationProcessor
org.springframework.context.event.internalEventListenerProcessor
org.springframework.context.event.internalEventListenerFactory
cap6MainConfig
com.enjoy.cap6.bean.Dog
com.enjoy.cap6.bean.Cat
com.enjoy.cap6.bean.Fish
com.enjoy.cap6.bean.Tiger
person
pig
```

## FactoryBean接口实现注册bean

在`cap7`包下操作

`config`包下，`Cap7MainConfig`类

```java
package com.enjoy.cap7.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Cap7MainConfig {
    @Bean
    public JamesFactoryBean jamesFactoryBean(){
        return new JamesFactoryBean();
    }
}
```

`config`包下，`JamesFactoryBean`类

```java
package com.enjoy.cap7.config;

import com.enjoy.cap7.bean.Monkey;
import org.springframework.beans.factory.FactoryBean;

public class JamesFactoryBean implements FactoryBean {
    @Override
    public Object getObject() throws Exception {
        return new Monkey();
    }

    @Override
    public Class<?> getObjectType() {
        return Monkey.class;
    }
    /*
    * true 是单例
    * false 是多例
    * */
    @Override
    public boolean isSingleton() {
        return true;
    }
}
```

`bean`包下，`Monkey`类

```java
package com.enjoy.cap7.bean;

public class Monkey {
}
```

`Cap7MainTest1`测试类

```java
package com.enjoy.cap7;

import com.enjoy.cap7.config.Cap7MainConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Cap7MainTest1 {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext app = new AnnotationConfigApplicationContext(Cap7MainConfig.class);
        String[] names = app.getBeanDefinitionNames();
        for (String name : names) {
            System.out.println(name);
        }
        Object bean1 = app.getBean("jamesFactoryBean");
        Object bean2 = app.getBean("jamesFactoryBean");
        System.out.println(bean1 == bean2);
    }
}
```

单例输出`true`

将其换成多例 输出`false`

`bean1 bean2`是`class com.enjoy.cap7.bean.Monkey`类型的哦。

这种形式，自带懒加载。无论单实例还是多实例，`getBean`的时候被创建。

注意：我们打印所有bean的名字的时候会有`jamesFactoryBean`而不是实际的`Monkey`的对象，这是因为在`getBean`的时候，调用的是`getObject()`方法。这让我想到了一点，在mybatis中，mapper应该是多例的，和spring的整合也可以采用这种方式，只要将其设置为多例即可。</textarea> </div></td>
                </tr>
                <tr>
                    <td style="text-align: center"><a href=""><span class="glyphicon glyphicon-heart-empty"></span></a></td>
                    <td style="text-align: center"><a href=""><span class="glyphicon glyphicon-comment"></span></a></td>
                    <td style="text-align: center"><a href=""><span class="glyphicon glyphicon glyphicon-star-empty"></span></a></td>
                </tr>
            </table>
        </div>
    </div>
    <div id="layout" class="container">
        <div class="table-fa blog-1">
            <table class="table" style="background-color: white">
                <tr>
                    <td class="styleShow">文章</td>
                    <td></td>
                    <td style="text-align: right" class="styleShow"><a href="">文章标题</a></td>
                </tr>
                <tr>
                    <td><a href=""><img class="avatar" src="/images/xue.png" alt=""></a></td>
                    <td></td>
                    <td style="font-size: 20px;text-align: right">用户名称</td>
                </tr>
                <tr>
                    <td colspan="3"><div id="editormd-view-3"><textarea style="" >```java
//会去扫描拥有这些 @Controller @Service @Repository @Component注解的类
@ComponentScan(value = "com.enjoy.cap2",includeFilters = {
        @ComponentScan.Filter(type = FilterType.CUSTOM,classes = {TypeFilter.class})
},useDefaultFilters = false)
```

`@ComponentScan`中`useDefaultFilters`和`includeFilters`的搭配使用，为什么默认规则需要为`false`

**源码分析**

从`AnnotationConfigApplicationContext`构造器开始分析

1. `refresh();`进去

2. `invokeBeanFactoryPostProcessors(beanFactory);`进去

3. `PostProcessorRegistrationDelegate.invokeBeanFactoryPostProcessors(beanFactory, getBeanFactoryPostProcessors());`进去

4. `invokeBeanDefinitionRegistryPostProcessors(currentRegistryProcessors, registry, beanFactory.getApplicationStartup());`进去

5. `postProcessor.postProcessBeanDefinitionRegistry(registry);`进去

6. `processConfigBeanDefinitions(registry);`进去

7. `parser.parse(candidates);`进去

8. `parse(((AnnotatedBeanDefinition) bd).getMetadata(), holder.getBeanName());`进去

9. `processConfigurationClass(new ConfigurationClass(metadata, beanName), DEFAULT_EXCLUSION_FILTER);`进去

10. `doProcessConfigurationClass(configClass, sourceClass, filter);`进去

11. `this.componentScanParser.parse(componentScan, sourceClass.getMetadata().getClassName());`进去

12. `ClassPathBeanDefinitionScanner scanner = new ClassPathBeanDefinitionScanner(this.registry,
          componentScan.getBoolean("useDefaultFilters"), this.environment, this.resourceLoader);`

    `ClassPathBeanDefinitionScanner`构造方法中有这样一句话

    ```java
    		if (useDefaultFilters) {
    			registerDefaultFilters();
    		}
    ```

    点进去

    ```java
    this.includeFilters.add(new AnnotationTypeFilter(Component.class));
    ```

    而`@Controller @Service @Repository`是`@Component`衍生出来的。所以必须写成false，不然不能失效。这个代码藏得很深。

    ```java
    @Component
    public @interface Repository {}

    @Component
    public @interface Controller {}

    @Component
    public @interface Service {}
    ```

## @Conditional条件注册bean

在`cap5包下操作`

`config`包下，`Config5MainConfig`类

```java
package com.enjoy.cap5.config;

import com.enjoy.cap1.Person;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Config5MainConfig {
    @Bean("person")
    public Person person(){
        System.out.println("给容器中添加person");
        return new Person("person",22);
    }
    @Bean("lison")
    public Person lison(){
        System.out.println("给容器中添加lison");
        return new Person("lison",23);
    }
    @Bean("james")
    public Person james(){
        System.out.println("给容器中添加james");
        return new Person("james",24);
    }

}
```

`Cap5MainTest1`测试类

```java
package com.enjoy.cap5;

import com.enjoy.cap5.config.Config5MainConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Cap5MainTest1 {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext app = new AnnotationConfigApplicationContext(Config5MainConfig.class);

    }
}
```

先有需求：

如果`linux`，则注册`james`这个bean

如果`windows`，则注册`lison`这个bean

```txt
BeanFactory 和 FactoryBean 的区别：
BeanFactory：可以把我们java实例bean通过BeanFactory注册到容器中
FactoryBean：从我们的容器中获取实例化后的bean
```

`WinCondition`类

```java
package com.enjoy.cap5.config;

import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.env.Environment;
import org.springframework.core.type.AnnotatedTypeMetadata;

public class WinCondition implements Condition {
    /**
     *
     * @param context  判断条件使用的上下文环节
     * @param metadata  类的注解信息
     * @return
     */
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        //获取beanFactory
        ConfigurableListableBeanFactory beanFactory = context.getBeanFactory();
        //获取环境变量
        Environment en = context.getEnvironment();
        //获取操作系统的名字
        String str = en.getProperty("os.name");
        if (str.contains("Windows"))return true;
        return false;
    }
}
```

`LinCondition`类

```java
package com.enjoy.cap5.config;

import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.env.Environment;
import org.springframework.core.type.AnnotatedTypeMetadata;

public class LinCondition implements Condition {
    /**
     *
     * @param context  判断条件使用的上下文环节
     * @param metadata  类的注解信息
     * @return
     */
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        //获取beanFactory
        ConfigurableListableBeanFactory beanFactory = context.getBeanFactory();
        //获取环境变量
        Environment en = context.getEnvironment();
        //获取操作系统的名字
        String str = en.getProperty("os.name");
        if (str.contains("Linux"))return true;
        return false;
    }
}
```

配置类注解bean的方法加上注解`@Conditional`

```java
		@Conditional(WinCondition.class)
    @Bean("lison")
    public Person lison(){
        System.out.println("给容器中添加lison");
        return new Person("lison",23);
    }
    @Conditional(LinCondition.class)
    @Bean("james")
    public Person james(){
        System.out.println("给容器中添加james");
        return new Person("james",24);
    }
```

测试输出

```txt
给容器中添加person
给容器中添加lison
```

模拟`linux`

![](images/ideaj模拟linux.png)

测试输出

```txt
给容器中添加person
给容器中添加james
```

## @Import注册bean

在`cap6`包下操作

`config`包下，`Cap6MainConfig`类

```java
package com.enjoy.cap6.config;

import com.enjoy.cap1.Person;
import com.enjoy.cap6.bean.Cat;
import com.enjoy.cap6.bean.Dog;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@Import({Dog.class, Cat.class,JamesImportSelector.class,JamesImportBeanDefinitionRegistrar.class})
public class Cap6MainConfig {
    /**
     * 给容器中注册bean的方式
     * 1.@Bean：[导入第三方的类或者组件]，比如person为第三方的类或者组件
     * 2.包扫描+组件的注解（例如：@ComponentScan + @Component形式）：一般是针对自己写的类
     * 3.@Import：快速给容器导入一个组件 注意：@Bean有点简单
     *          a.@Import(要导入到容器中的组件)：容器会自动注册这个组件，bean的id为全类名
     *          b.ImportSelector：是一个接口，返回需要导入到容器的组件的全类名数组
     *          c.ImportBeanDefinitionRegistrar：可以手动添加组件到IOC容器，所有bean的注册可以使用BeanDefinitionRegistry来判断是否存在其他bean。见JamesImportBeanDefinitionRegistrar
     *
     */
    //容器启动时初始化person的bean
    //id是person
    @Bean
    public Person person(){
        return new Person("张三",22);
    }
}
```

`config`包下，`JamesImportBeanDefinitionRegistrar`类

```java
package com.enjoy.cap6.config;

import com.enjoy.cap6.bean.Pig;
import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.beans.factory.support.RootBeanDefinition;
import org.springframework.context.annotation.ImportBeanDefinitionRegistrar;
import org.springframework.core.type.AnnotationMetadata;

public class JamesImportBeanDefinitionRegistrar implements ImportBeanDefinitionRegistrar {
    /**
     *
     * @param importingClassMetadata  当前类的注解信息
     * @param registry  bean的注册类
     *     把所有需要添加到容器中的bean加入
     *
     */
    @Override
    public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata, BeanDefinitionRegistry registry) {
        if(registry.containsBeanDefinition("com.enjoy.cap6.bean.Dog") && registry.containsBeanDefinition("com.enjoy.cap6.bean.Cat")){
            //对新注册的bean要进行封装
            RootBeanDefinition rootBeanDefinition = new RootBeanDefinition(Pig.class);
            registry.registerBeanDefinition("pig",rootBeanDefinition);
        }
    }
}
```

`config`包下，`JamesImportSelector`类

```java
package com.enjoy.cap6.config;

import org.springframework.context.annotation.ImportSelector;
import org.springframework.core.type.AnnotationMetadata;

public class JamesImportSelector implements ImportSelector {
    @Override
    public String[] selectImports(AnnotationMetadata importingClassMetadata) {
        //不要返回return null 会有空指针异常
        //写全类名
        return new String[]{"com.enjoy.cap6.bean.Fish","com.enjoy.cap6.bean.Tiger"};
    }
}
```



`return null 会有空指针异常`

在上面代码`第11行`打上断点，进行debug启动。继续执行方法。

进入`Collection<SourceClass> importSourceClasses = asSourceClasses(importClassNames, exclusionFilter);`会发现有这样一句代码

```java
List<SourceClass> annotatedClasses = new ArrayList<>(classNames.length);
```

`classNames.length`为null时，会产生空指针异常。



`bean`包下，实体类

```java
package com.enjoy.cap6.bean;

public class Cat {
}

package com.enjoy.cap6.bean;
//id是com.enjoy.cap6.bean.Dog 包名+类名的形式
public class Dog {

}

package com.enjoy.cap6.bean;

public class Fish {
}

package com.enjoy.cap6.bean;

public class Pig {
}

package com.enjoy.cap6.bean;

public class Tiger {
}
```

`Cap6MainTest1`测试类

```java
package com.enjoy.cap6;

import com.enjoy.cap6.config.Cap6MainConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Cap6MainTest1 {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext app = new AnnotationConfigApplicationContext(Cap6MainConfig.class);
        String[] names = app.getBeanDefinitionNames();
        for (String name : names) {
            System.out.println(name);
        }
    }
}
```

输出

```txt
org.springframework.context.annotation.internalConfigurationAnnotationProcessor
org.springframework.context.annotation.internalAutowiredAnnotationProcessor
org.springframework.context.annotation.internalCommonAnnotationProcessor
org.springframework.context.event.internalEventListenerProcessor
org.springframework.context.event.internalEventListenerFactory
cap6MainConfig
com.enjoy.cap6.bean.Dog
com.enjoy.cap6.bean.Cat
com.enjoy.cap6.bean.Fish
com.enjoy.cap6.bean.Tiger
person
pig
```

## FactoryBean接口实现注册bean

在`cap7`包下操作

`config`包下，`Cap7MainConfig`类

```java
package com.enjoy.cap7.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Cap7MainConfig {
    @Bean
    public JamesFactoryBean jamesFactoryBean(){
        return new JamesFactoryBean();
    }
}
```

`config`包下，`JamesFactoryBean`类

```java
package com.enjoy.cap7.config;

import com.enjoy.cap7.bean.Monkey;
import org.springframework.beans.factory.FactoryBean;

public class JamesFactoryBean implements FactoryBean {
    @Override
    public Object getObject() throws Exception {
        return new Monkey();
    }

    @Override
    public Class<?> getObjectType() {
        return Monkey.class;
    }
    /*
    * true 是单例
    * false 是多例
    * */
    @Override
    public boolean isSingleton() {
        return true;
    }
}
```

`bean`包下，`Monkey`类

```java
package com.enjoy.cap7.bean;

public class Monkey {
}
```

`Cap7MainTest1`测试类

```java
package com.enjoy.cap7;

import com.enjoy.cap7.config.Cap7MainConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Cap7MainTest1 {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext app = new AnnotationConfigApplicationContext(Cap7MainConfig.class);
        String[] names = app.getBeanDefinitionNames();
        for (String name : names) {
            System.out.println(name);
        }
        Object bean1 = app.getBean("jamesFactoryBean");
        Object bean2 = app.getBean("jamesFactoryBean");
        System.out.println(bean1 == bean2);
    }
}
```

单例输出`true`

将其换成多例 输出`false`

`bean1 bean2`是`class com.enjoy.cap7.bean.Monkey`类型的哦。

这种形式，自带懒加载。无论单实例还是多实例，`getBean`的时候被创建。

注意：我们打印所有bean的名字的时候会有`jamesFactoryBean`而不是实际的`Monkey`的对象，这是因为在`getBean`的时候，调用的是`getObject()`方法。这让我想到了一点，在mybatis中，mapper应该是多例的，和spring的整合也可以采用这种方式，只要将其设置为多例即可。</textarea> </div></td>
                </tr>
                <tr>
                    <td style="text-align: center"><a href=""><span class="glyphicon glyphicon-heart-empty"></span></a></td>
                    <td style="text-align: center"><a href=""><span class="glyphicon glyphicon-comment"></span></a></td>
                    <td style="text-align: center"><a href=""><span class="glyphicon glyphicon glyphicon-star-empty"></span></a></td>
                </tr>
            </table>
        </div>
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
            var testEditormdView;
            $.get("/editormd/examples/test.md", function(markdown) {
                testEditormdView = editormd.markdownToHTML("editormd-view-1", {
                    markdown        : markdown ,
                    htmlDecode      : "style,script,iframe",
                    tocm            : true,
                    emoji           : true,
                    taskList        : true,
                    tex             : true,
                    flowChart       : true,
                    sequenceDiagram : true,
                });
                testEditormdView = editormd.markdownToHTML("editormd-view-2", {
                    markdown        : markdown ,
                    htmlDecode      : "style,script,iframe",
                    tocm            : true,
                    emoji           : true,
                    taskList        : true,
                    tex             : true,
                    flowChart       : true,
                    sequenceDiagram : true,
                });
                testEditormdView = editormd.markdownToHTML("editormd-view-3", {
                    markdown        : markdown ,
                    htmlDecode      : "style,script,iframe",
                    tocm            : true,
                    emoji           : true,
                    taskList        : true,
                    tex             : true,
                    flowChart       : true,
                    sequenceDiagram : true,
                });
                // 获取Markdown源码
                //console.log(testEditormdView.getMarkdown());
            });
        });
    </script>
</@nav>