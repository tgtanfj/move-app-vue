export function getTemplateReset(link: string) {
  return `<p>You requested a password reset. Click the link below to reset your password:</p>
    <p>
    <a href="${link}">Reset Password</a>
    </p>`;
}
