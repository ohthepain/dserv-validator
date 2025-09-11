<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false displayInfo=false; section>
    <#if section = "header">
        <div class="dserv-login-header">
            <h1>Logout</h1>
            <p>You have been logged out successfully.</p>
        </div>
    <#elseif section = "form">
        <div class="dserv-logout-success">
            <div class="dserv-form-actions">
                <a href="/realms/AppUser/account" class="dserv-button dserv-button-primary">Back to Account</a>
                <a href="/realms/AppUser/protocol/openid-connect/auth?client_id=app-provider-backend-oidc&response_type=code&scope=openid&redirect_uri=http://app-provider.localhost:3000/" class="dserv-button" style="background: var(--dserv-secondary); margin-left: 1rem;">Login to App</a>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>