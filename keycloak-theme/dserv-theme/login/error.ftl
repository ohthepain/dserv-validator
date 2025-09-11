<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=true displayInfo=false; section>
    <#if section = "header">
        <div class="dserv-login-header">
            <h1>Error</h1>
            <p>Something went wrong</p>
        </div>
    <#elseif section = "form">
        <div class="dserv-error-message">
            <#if message?has_content && message.summary?has_content>
                <div class="dserv-alert dserv-alert-error">
                    <span class="dserv-alert-text">${message.summary}</span>
                </div>
            </#if>
            <div class="dserv-form-actions">
                <a href="${url.loginUrl}" class="dserv-button dserv-button-primary">Back to Login</a>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>
