
if Rails.env.development?
  ENV['PUBLISHABLE_KEY'] = "pk_test_PK56I8xRA5vMzyn7yhIQC6wk"
  ENV['SECRET_KEY'] = "sk_test_tzVXjCcObQMKQMPvstAX3hrs"
end

Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]