<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section = "header">
        <div class="dserv-login-header">
            <h1>Welcome to DServ</h1>
            <p>Please sign in to your account</p>
        </div>
    <#elseif section = "form">
        <div class="dserv-login-form">
            <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
                <div class="dserv-form-group">
                    <#if usernameEditDisabled??>
                        <input tabindex="1" id="username" class="dserv-input" name="username" value="${(login.username!'')}" type="text" disabled />
                    <#else>
                        <input tabindex="1" id="username" class="dserv-input" name="username" value="${(login.username!'')}" type="text" autofocus autocomplete="off" placeholder="Username or email" />
                    </#if>
                </div>

                <div class="dserv-form-group">
                    <input tabindex="2" id="password" class="dserv-input" name="password" type="password" autocomplete="off" placeholder="Password" />
                </div>

                <div class="dserv-form-options">
                    <#if realm.rememberMe && !usernameEditDisabled??>
                        <div class="dserv-checkbox">
                            <#if login.rememberMe??>
                                <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" checked>
                            <#else>
                                <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox">
                            </#if>
                            <label for="rememberMe">Remember me</label>
                        </div>
                    </#if>
                </div>

                <div class="dserv-form-actions">
                    <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                    <input tabindex="4" class="dserv-button dserv-button-primary" name="login" id="kc-login" type="submit" value="Sign In"/>
                </div>
            </form>
        </div>
    <#elseif section = "info" >
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div class="dserv-registration-info">
                <p>New user? <a tabindex="6" href="${url.registrationUrl}">Register</a></p>
            </div>
        </#if>
    <#elseif section = "socialProviders" >
        <#if realm.password && social.providers??>
            <div class="dserv-social-login">
                <hr/>
                <p>Or sign in with</p>
                <#list social.providers as p>
                    <a id="social-${p.alias}" class="dserv-social-button dserv-social-${p.alias}" href="${p.loginUrl}">
                        <span>${p.displayName}</span>
                    </a>
                </#list>
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>
