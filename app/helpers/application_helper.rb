module ApplicationHelper
   ALERT_CONVERSION_MAP = { :error => 'danger' }
   def get_alert_class(alert_type)
      return ALERT_CONVERSION_MAP[alert_type] if ALERT_CONVERSION_MAP.has_key?(alert_type)
      alert_type
   end
end
