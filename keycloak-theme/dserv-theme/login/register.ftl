<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password','password-confirm') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section = "header">
        <div class="dserv-login-header">
            <h1>Create Account</h1>
            <p>Join DServ today</p>
        </div>
    <#elseif section = "form">
        <div class="dserv-registration-form">
            <form id="kc-register-form" action="${url.registrationAction}" method="post">
                <div class="dserv-form-group">
                    <#if !realm.registrationEmailAsUsername>
                        <input type="text" id="username" class="dserv-input" name="username" placeholder="Username" autofocus autocomplete="username" />
                    </#if>
                </div>

                <div class="dserv-form-group">
                    <input type="text" id="email" class="dserv-input" name="email" placeholder="Email" autocomplete="email" />
                </div>

                <#if !realm.registrationEmailAsUsername>
                    <div class="dserv-form-group">
                        <input type="text" id="firstName" class="dserv-input" name="firstName" placeholder="First name" autocomplete="given-name" />
                    </div>
                    <div class="dserv-form-group">
                        <input type="text" id="lastName" class="dserv-input" name="lastName" placeholder="Last name" autocomplete="family-name" />
                    </div>
                </#if>

                <#if passwordRequired??>
                    <div class="dserv-form-group">
                        <input type="password" id="password" class="dserv-input" name="password" placeholder="Password" autocomplete="new-password" />
                    </div>
                    <div class="dserv-form-group">
                        <input type="password" id="password-confirm" class="dserv-input" name="password-confirm" placeholder="Confirm password" autocomplete="new-password" />
                    </div>
                </#if>

                <div class="dserv-form-actions">
                    <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                    <input type="submit" class="dserv-button dserv-button-primary" value="Create Account"/>
                </div>
            </form>
        </div>
    <#elseif section = "info" >
        <div class="dserv-registration-info">
            <p>Already have an account? <a href="${url.loginUrl}">Sign in</a></p>
        </div>
    </#if>
</@layout.registrationLayout>
