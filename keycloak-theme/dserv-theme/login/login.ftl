<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
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
                <h2 class="dserv-form-title">Get Started</h2>
                <p class="dserv-form-description">Sign in to your account or create a new one</p>
            </div>
            
            <div class="dserv-tabs">
                <div class="dserv-tab-list">
                    <button class="dserv-tab-trigger dserv-tab-active" data-tab="signin">Sign In</button>
                    <button class="dserv-tab-trigger" data-tab="signup">Sign Up</button>
                </div>
                
                <div class="dserv-tab-content" id="signin-tab">
                    <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
                        <div class="dserv-form-group">
                            <label class="dserv-label" for="username">Email</label>
                            <#if usernameEditDisabled??>
                                <input tabindex="1" id="username" class="dserv-input" name="username" value="${(login.username!'')}" type="email" disabled />
                            <#else>
                                <input tabindex="1" id="username" class="dserv-input" name="username" value="${(login.username!'')}" type="email" autofocus autocomplete="off" placeholder="Enter your email" />
                            </#if>
                        </div>

                        <div class="dserv-form-group">
                            <label class="dserv-label" for="password">Password</label>
                            <input tabindex="2" id="password" class="dserv-input" name="password" type="password" autocomplete="off" placeholder="Enter your password" />
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
            </div>
        </div>
    <#elseif section = "info" >
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div class="dserv-registration-info">
                <p>New user? <a tabindex="6" href="${url.registrationUrl}">Register</a></p>
            </div>
        </#if>
    <#elseif section = "socialProviders" >
        <div class="dserv-social-section">
            <div class="dserv-divider">
                <span class="dserv-divider-text">Or continue with</span>
            </div>
            
            <div class="dserv-social-buttons">
                <div class="dserv-social-row">
                    <button class="dserv-social-button dserv-google-button" onclick="handleGoogleLogin()">
                        <svg class="dserv-social-icon" viewBox="0 0 24 24">
                            <path fill="currentColor" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                            <path fill="currentColor" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                            <path fill="currentColor" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                            <path fill="currentColor" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                        </svg>
                        Google
                    </button>
                    
                    <button class="dserv-social-button dserv-github-button" onclick="handleGithubLogin()">
                        <svg class="dserv-social-icon" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
                        </svg>
                        GitHub
                    </button>
                </div>
            </div>
            
            <div class="dserv-footer-links">
                <a href="/tosheymail.html" target="_blank" rel="noopener noreferrer" class="dserv-footer-link">Terms of Service</a>
                <span class="dserv-footer-separator">•</span>
                <a href="/privacypolicyheymail.html" target="_blank" rel="noopener noreferrer" class="dserv-footer-link">Privacy Policy</a>
            </div>
            
            <div class="dserv-debug-section">
                <button onclick="clearAllData()" class="dserv-debug-button">Clear all data and reload</button>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>

<script>
function handleGoogleLogin() {
    // Stub for Google login - implement OAuth flow
    console.log('Google login clicked');
    alert('Google login - to be implemented');
}

function handleGithubLogin() {
    // Stub for GitHub login - implement OAuth flow
    console.log('GitHub login clicked');
    alert('GitHub login - to be implemented');
}

function clearAllData() {
    localStorage.clear();
    sessionStorage.clear();
    window.location.reload();
}

// Tab switching functionality
document.addEventListener('DOMContentLoaded', function() {
    const tabTriggers = document.querySelectorAll('.dserv-tab-trigger');
    const tabContents = document.querySelectorAll('.dserv-tab-content');
    
    tabTriggers.forEach(trigger => {
        trigger.addEventListener('click', function() {
            const targetTab = this.getAttribute('data-tab');
            
            // Remove active class from all triggers
            tabTriggers.forEach(t => t.classList.remove('dserv-tab-active'));
            // Add active class to clicked trigger
            this.classList.add('dserv-tab-active');
            
            // Hide all tab contents
            tabContents.forEach(content => content.style.display = 'none');
            // Show target tab content
            const targetContent = document.getElementById(targetTab + '-tab');
            if (targetContent) {
                targetContent.style.display = 'block';
            }
        });
    });
});
</script>
