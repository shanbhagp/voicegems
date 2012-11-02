class DevelopmentMailInterceptor
  def self.delivering_email(message)
     unless current_user.email == 'teststartx@example.com' 
       message.subject = "#{message.to} #{message.subject}"
       message.to = "shanbhagp@aol.com"
     end 
  end
end

