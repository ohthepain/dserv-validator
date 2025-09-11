<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false displayInfo=false; section>
    <#if section = "header">
        <div class="dserv-login-header">
            <h1>Information</h1>
        </div>
    <#elseif section = "form">
        <div class="dserv-info-message">
            <#if message?has_content && message.summary?has_content>
                <div class="dserv-alert dserv-alert-${message.type!}">
                    <span class="dserv-alert-text">${message.summary}</span>
                </div>
            </#if>
            <div class="dserv-form-actions">
                <a href="${url.loginUrl}" class="dserv-button dserv-button-primary">Back to Login</a>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>
