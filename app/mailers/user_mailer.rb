class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("activate_mail.title")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("reset_mail.title")
  end
end
