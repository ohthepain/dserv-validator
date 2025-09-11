<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false displayInfo=false; section>
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
                <h2 class="dserv-form-title">Signed Out Successfully</h2>
                <p class="dserv-form-description">You have been logged out of your account</p>
            </div>
            
            <div class="dserv-form-actions">
                <a href="/realms/AppUser/account" class="dserv-button dserv-button-primary">Back to Account</a>
                <a href="/realms/AppUser/protocol/openid-connect/auth?client_id=app-provider-backend-oidc&response_type=code&scope=openid&redirect_uri=http://app-provider.localhost:3000/" class="dserv-button" style="background: var(--dserv-secondary); margin-top: 0.75rem;">Login to App</a>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>
