# Firebase Auth Email Templates

Firebase Auth email templates are configured in the Firebase Console, not
deployed from this repository.

Use these files as the HTML body for:

- `verify_email.html`: Authentication > Templates > Email address verification
- `password_reset.html`: Authentication > Templates > Password reset

Required Firebase Console setting:

1. Open Authentication > Templates.
2. For password reset and email verification, set the custom action URL to:
   `https://tiny-sfogliatella-25121e.netlify.app/`
3. Keep `%LINK%` in the email body. Firebase replaces it with the real action
   link containing `mode` and `oobCode`.
4. Add the reset page domain to Authentication > Settings > Authorized domains
   if it is not already listed.

The Netlify page handles:

- `mode=resetPassword` with `confirmPasswordReset`.
- `mode=verifyEmail` with `applyActionCode`.
