SCHEDULER.every '30s' do
  require 'bundler/setup'
  require 'nagiosharder'

  environments = {
    prod: { url: 'http://my-prod-nagios/cgi-bin/nagios3/', username: 'nagios', password: 'nagios' },
    dev: { url: 'http://my-dev-nagios/cgi-bin/nagios3/', username: 'nagios', password: 'nagios' },
  }

  environments.each do |key, env|
    nag = NagiosHarder::Site.new(env[:url], env[:username], env[:password])
    unacked = nag.service_status(:service_status_types => [:warning, :critical], :service_props => [:no_scheduled_downtime, :state_unacknowledged, :checks_enabled])

    critical_count = 0
    warning_count = 0
    unacked.each do |alert|
      if alert["status"].eql? "CRITICAL"
        critical_count += 1
      elsif alert["status"].eql? "WARNING"
        warning_count += 1
      end
    end
  
    status = critical_count > 0 ? "red" : (warning_count > 0 ? "yellow" : "green")
  
    send_event('nagios-' + key.to_s, { criticals: critical_count, warnings: warning_count, status: status })
  end
end
