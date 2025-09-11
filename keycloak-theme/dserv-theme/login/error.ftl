<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=true displayInfo=false; section>
    <#if section = "header">
        <div class="dserv-login-header">
            <div class="dserv-brand">
                <div class="dserv-icon">
                    <svg class="dserv-icon-svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                        <polyline points="22,6 12,13 2,6"></polyline>
                    </svg>
                </div>
                <h1 class="dserv-title">Dserv.io</h1>
            </div>
            <p class="dserv-subtitle">The Fast Way to the New Liquidity</p>
        </div>
    <#elseif section = "form">
        <div class="dserv-form-container">
            <div class="dserv-form-header">
                <h2 class="dserv-form-title">Error</h2>
                <p class="dserv-form-description">Something went wrong</p>
            </div>
            
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
