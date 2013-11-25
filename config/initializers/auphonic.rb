require 'miniphonic'



if Rails.env.development?
  ENV['VG_AUPHONIC_PRESET'] = "hNxw4afLvAqzuceRc3KjVK"
  ENV['VG_AUPHONIC_SERVICE'] = "PPzeGb8UQQTtAzbembHyxB"
  ENV['VG_AUPHONIC_USER'] = "praveen@name-coach.com"
  ENV['VG_AUPHONIC_PW'] = "bugsbegone"
end

Miniphonic.configure do |m|
  m.user = ENV['VG_AUPHONIC_USER']
  m.password = ENV['VG_AUPHONIC_PW'] 
end
